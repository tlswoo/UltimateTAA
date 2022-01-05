Shader "Advanced Render Pipeline/ARPStandard" {
    
    Properties {
        [Enum(Dynamic, 1, Alpha, 2, Custom, 3)]
        _StencilRef("Stencil Ref", int) = 1
        [Enum(UnityEngine.Rendering.CullMode)]
        _Cull("Cull", Float) = 0
        _AlbedoTint("Albedo Tint", Color) = (1,1,1,1)
        _AlbedoMap("Albedo", 2D) = "white" { }
        _NormalScale("Normal Scale", Range(0, 1)) = 1
        [NoScaleOffset]
        _NormalMap("Normal", 2D) = "bump" { }
        _MetallicScale("Metallic Scale", Range(0, 1)) = 0
        _SmoothnessScale("Smoothness Scale", Range(0, 1)) = 1
        _MetallicSmoothnessMap("Metallic (RGB) Smoothness (A)", 2D) = "white" { }
        // _SpecularMap("Specular", 2D) = "black" { }
        // _SmoothnessMap("Smoothness", 2D) = "white" { }
        _OcclusionMap("Occlusion", 2D) = "white" { }
        [HDR]
        _EmissiveTint("Emissive Tint", Color) = (0, 0, 0, 1)
        _EmissiveMap("Emissive", 2D) = "black" { }
    }
    
    SubShader {
        
        UsePass "Hidden/ARPDepth/DynamicDepth"
        
        UsePass "Hidden/ARPDepth/MotionVectors"
        
        UsePass "Hidden/ARPShadow/OpaqueShadowCaster"
        
        Pass {
            
            Tags {
                "LightMode" = "OpaqueForward"
            }
            
            ZTest Equal
            ZWrite Off
			Cull [_Cull]
            
            HLSLPROGRAM

            #pragma multi_compile_instancing
            #pragma vertex StandardVertex
            #pragma fragment StandardFragment

            #include "../ShaderLibrary/ARPCommon.hlsl"

            struct VertexInput {
                float3 posOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float2 baseUV : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct VertexOutput {
                float4 posCS : SV_POSITION;
                float3 posWS : VAR_POSITION;
                float3 normalWS : VAR_NORMAL;
                float4 tangentWS : VAR_TANGENT;
                float3 viewDirWS : TEXCOORD1;
                float2 baseUV : VAR_BASE_UV;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct GBufferOutput {
                float4 forward : SV_TARGET0;
                float3 gbuffer1 : SV_TARGET1;
                float4 gbuffer2 : SV_TARGET2;
            };

            UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
                UNITY_DEFINE_INSTANCED_PROP(float, _NormalScale)
                UNITY_DEFINE_INSTANCED_PROP(float, _MetallicScale)
                UNITY_DEFINE_INSTANCED_PROP(float, _SmoothnessScale)
                UNITY_DEFINE_INSTANCED_PROP(float4, _AlbedoTint)
                UNITY_DEFINE_INSTANCED_PROP(float4, _EmissiveTint)
                UNITY_DEFINE_INSTANCED_PROP(float4, _AlbedoMap_ST)
                // UNITY_DEFINE_INSTANCED_PROP(float4, _NormalMap_ST)
                // UNITY_DEFINE_INSTANCED_PROP(float4, _MetallicSmoothnessMap_ST)
                // UNITY_DEFINE_INSTANCED_PROP(float4, _OcclusionMap_ST)
                // UNITY_DEFINE_INSTANCED_PROP(float4, _EmissiveMap_ST)
            UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)

            VertexOutput StandardVertex(VertexInput input) {
                VertexOutput output;
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, output);

                float3 posWS = TransformObjectToWorld(input.posOS);
                output.posWS = posWS;
                // output.posCS = TransformObjectToHClip(input.posOS);
                output.posCS = TransformWorldToHClip(posWS);
                output.normalWS = TransformObjectToWorldNormal(input.normalOS);
                output.tangentWS = TransformObjectToWorldTangent(input.tangentOS);

                output.viewDirWS = normalize(_CameraPosWS.xyz - posWS);
                
                float4 albedoST = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _AlbedoMap_ST);
                output.baseUV = input.baseUV * albedoST.xy + albedoST.zw;
                return output;
            }

            GBufferOutput StandardFragment(VertexOutput input) {
                UNITY_SETUP_INSTANCE_ID(input);
                
                GBufferOutput output;

                float3 normalWS = normalize(input.normalWS);
                float normalScale = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _NormalScale);
                float3 normalData = UnpackNormalScale(SAMPLE_TEXTURE2D(_NormalMap, sampler_NormalMap, input.baseUV), normalScale);
                
                float3 N = ApplyNormalMap(normalData, normalWS, input.tangentWS);
                float3 V = input.viewDirWS;
                float3 L = _MainLight.direction.xyz;

                float NdotV;
                N = GetViewReflectedNormal(N, V, NdotV);
                float3 H = normalize(V + L);
                float LdotH = saturate(dot(L, H));
                float NdotH = saturate(dot(N, H));
                float NdotL = saturate(dot(N, L));

                float3 albedo = SAMPLE_TEXTURE2D(_AlbedoMap, sampler_AlbedoMap, input.baseUV).rgb;
                albedo *= UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _AlbedoTint).rgb;

                float occlusion = SAMPLE_TEXTURE2D(_OcclusionMap, sampler_OcclusionMap, input.baseUV).r;
                // albedo *= occlusion;

                float4 metallicSmoothness = SAMPLE_TEXTURE2D(_MetallicSmoothnessMap, sampler_MetallicSmoothnessMap, input.baseUV);
                
                float linearSmoothness = metallicSmoothness.a;
                // float linearSmoothness = 1.0f - metallicSmoothness.g;
                linearSmoothness *= UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _SmoothnessScale);
                float linearRoughness = LinearSmoothToLinearRoughness(linearSmoothness);
                linearRoughness = ClampMinLinearRoughness(linearRoughness);
                float roughness = LinearRoughnessToRoughness(linearRoughness);
                // roughness = ClampMinRoughness(roughness);

                float metallic = metallicSmoothness.r;
                // float metallic = metallicSmoothness.b;
                metallic *= UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _MetallicScale);

                float3 emissive = SAMPLE_TEXTURE2D(_EmissiveMap, sampler_EmissiveMap, input.baseUV).rgb;
                emissive += UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _EmissiveTint).rgb;

                float3 diffuse = (1.0 - metallic) * albedo;
                float3 f0 = GetF0(albedo, metallic);
                
                float3 energyCompensation;
                float lut = GetDFromLut(energyCompensation, f0, roughness, NdotV);
                // lut = GetDGFFromLut(energyCompensation, f0, roughness, NdotV).a;

                // float fd = CalculateFd(NdotV, NdotL, LdotH, linearRoughness);
                float fd = CalculateFdMultiScatter(NdotV, NdotL, NdotH, LdotH, linearRoughness);
                // float3 fr = CalculateFrMultiScatter(NdotV, NdotL, NdotH, LdotH, roughness, f0, energyCompensation);
                float3 fr = CalculateFr(NdotV, NdotL, NdotH, LdotH, roughness, f0);

                float3 mainLighting = NdotL * _MainLight.color.rgb;

                diffuse *= fd * mainLighting;

                float3 specular = fr * mainLighting;

                float3 directLighting = diffuse + specular;

                float3 kS = F_SchlickRoughness(f0, NdotV, linearRoughness);
                float3 kD = 1.0f - kS;
                kD *=  1.0f - metallic;
                
                float3 R = reflect(-V, N);

                float iblOcclusion = ComputeHorizonSpecularOcclusion(R, normalWS);

                float3 indirectDiffuse = EvaluateDiffuseIBL(kD, N, albedo, lut) * min(occlusion, iblOcclusion);
                
                output.forward = float4(directLighting + indirectDiffuse + emissive, iblOcclusion);
                // output.forward = float4(indirectDiffuse, iblOcclusion);
                // output.forward = float4(energyCompensation - 1.0f, 1.0f);
                // output.gbuffer1 = PackNormalOctQuadEncode(N);
                output.gbuffer1 = EncodeNormal(N);
                output.gbuffer2 = float4(f0, linearRoughness);
                return output;
            }

            ENDHLSL
        }
    }
    
    CustomEditor "AdvancedRenderPipeline.Editor.ShaderGUIs.MVShaderGUI"
}
