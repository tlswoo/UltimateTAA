using UnityEngine;
using UnityEngine.Rendering;

namespace AdvancedRenderPipeline.Runtime {
	public static class ShaderKeywordManager {

		#region Camera Params

		public static readonly int CAMERA_DATA = Shader.PropertyToID("CameraData");
		public static readonly int UNITY_MATRIX_VP = Shader.PropertyToID("unity_MatrixVP");
		public static readonly int UNITY_MATRIX_I_VP = Shader.PropertyToID("unity_InvMatrixVP");
		public static readonly int UNITY_PREV_MATRIX_VP = Shader.PropertyToID("unity_MatrixPreviousVP");
		public static readonly int UNITY_PREV_MATRIX_I_VP = Shader.PropertyToID("unity_InvMatrixPreviousVP");
		public static readonly int UNITY_MATRIX_NONJITTERED_VP = Shader.PropertyToID("_NonJitteredMatrixVP");
		public static readonly int UNITY_MATRIX_NONJITTERED_I_VP = Shader.PropertyToID("_InvNonJitteredMatrixVP");

		#endregion

		#region Light Params

		public static readonly int MAIN_LIGHT = Shader.PropertyToID("_MainLight");
		public static readonly int MAIN_LIGHT_DATA = Shader.PropertyToID("MainLightData");

		#endregion

		#region Shadow Params

		public static readonly int SHADOW_CONSTANT_BIAS = Shader.PropertyToID("_ShadowConstantBias");
		public static readonly int SHADOW_NORMAL_BIAS = Shader.PropertyToID("_ShadowNormalBias");
		public static readonly int MAIN_LIGHT_SHADOW_DIST = Shader.PropertyToID("_MainLightShadowDist");
		public static readonly int MAIN_LIGHT_SHADOW_STR = Shader.PropertyToID("_MainLightShadowStr");
		public static readonly int MAIN_LIGHT_SHADOW_TINT = Shader.PropertyToID("_MainLightShadowTint");
		public static readonly int MAIN_LIGHT_SHADOWMAP_SIZE = Shader.PropertyToID("_MainLightShadowmapSize");
		public static readonly int MAIN_LIGHT_INV_VP = Shader.PropertyToID("_MainLightInvVP");

		#endregion

		#region IBL Params

		public static readonly int PREINTEGRATED_DGF_LUT = Shader.PropertyToID("_PreintegratedDGFLut");
		public static readonly int PREINTEGRATED_D_LUT = Shader.PropertyToID("_PreintegratedDLut");
		public static readonly int PREINTEGRATED_GF_LUT = Shader.PropertyToID("_PreintegratedGFLut");
		public static readonly int GLOBAL_ENV_MAP = Shader.PropertyToID("_GlobalEnvMap");
		public static readonly int GLOBAL_ENV_MAP_SPECULAR = Shader.PropertyToID("_GlobalEnvMapSpecular");
		public static readonly int GLOBAL_ENV_MAP_DIFFUSE = Shader.PropertyToID("_GlobalEnvMapDiffuse");
		public static readonly int GLOBAL_ENV_MAP_ROTATION = Shader.PropertyToID("_GlobalEnvMapRotation");
		public static readonly int SKYBOX_MIP_LEVEL = Shader.PropertyToID("_SkyboxMipLevel");

		#endregion

		#region Render Targets

		public static readonly int MAIN_TEXTURE = Shader.PropertyToID("_MainTex");
		public static readonly int RAW_COLOR_TEXTURE = Shader.PropertyToID("_RawColorTex");
		public static readonly int COLOR_TEXTURE = Shader.PropertyToID("_ColorTex");
		public static readonly int TAA_COLOR_TEXTURE = Shader.PropertyToID("_TaaColorTex");
		public static readonly int PREV_TAA_COLOR_TEXTURE = Shader.PropertyToID("_PrevTaaColorTex");
		public static readonly int HDR_COLOR_TEXTURE = Shader.PropertyToID("_HdrColorTex");
		public static readonly int DISPLAY_TEXTURE = Shader.PropertyToID("_DisplayTex");
		public static readonly int DEPTH_TEXTURE = Shader.PropertyToID("_DepthTex");
		public static readonly int PREV_DEPTH_TEXTURE = Shader.PropertyToID("_PrevDepthTex");
		public static readonly int STENCIL_TEXTURE = Shader.PropertyToID("_StencilTex");
		public static readonly int PREV_STENCIL_TEXTURE = Shader.PropertyToID("_PrevStencilTex");
		public static readonly int VELOCITY_TEXTURE = Shader.PropertyToID("_VelocityTex");
		public static readonly int PREV_VELOCITY_TEXTURE = Shader.PropertyToID("_PrevVelocityTex");
		public static readonly int GBUFFER_1_TEXTURE = Shader.PropertyToID("_GBuffer1");
		public static readonly int GBUFFER_2_TEXTURE = Shader.PropertyToID("_GBuffer2");
		public static readonly int GBUFFER_3_TEXTURE = Shader.PropertyToID("_GBuffer3");
		public static readonly int SCREEN_SPACE_CUBEMAP = Shader.PropertyToID("_ScreenSpaceCubemap");
		public static readonly int SCREEN_SPACE_REFLECTION = Shader.PropertyToID("_ScreenSpaceReflection");
		public static readonly int PREV_SCREEN_SPACE_REFLECTION = Shader.PropertyToID("_PrevScreenSpaceReflection");
		public static readonly int INDIRECT_SPECULAR = Shader.PropertyToID("_IndirectSpecular");
		public static readonly int MAIN_LIGHT_SHADOW_MAP = Shader.PropertyToID("_MainLightShadowmap");

		#endregion

		#region Color Grading & Tonemapping

		public static readonly int TONEMAPPING_MODE = Shader.PropertyToID("_TonemappingMode");
		public static readonly int COLOR_GRADE_PARAMS = Shader.PropertyToID("_ColorGradeParams");
		public static readonly int COLOR_FILTER = Shader.PropertyToID("_ColorFilter");

		#endregion

		#region Temporal Related
		
		public static readonly int ENABLE_REPROJECTION = Shader.PropertyToID("_EnableReprojection");
		public static readonly int JITTER_PARAMS = Shader.PropertyToID("_JitterParams");
		public static readonly int TAA_PARAMS_0 = Shader.PropertyToID("_TaaParams_0");
		public static readonly int TAA_PARAMS_1 = Shader.PropertyToID("_TaaParams_1");
		public static readonly int TAA_PARAMS_2 = Shader.PropertyToID("_TaaParams_2");

		#endregion

		#region Miscs



		#endregion
	}
}