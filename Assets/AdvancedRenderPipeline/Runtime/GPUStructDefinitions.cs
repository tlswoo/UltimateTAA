using System;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Rendering;

namespace AdvancedRenderPipeline.Runtime {
	
	public static class GPUStructDefinitions {
		
	}
	
	[Serializable]
	public struct PackedRTHandleProperties {
		public int4 viewportSize;
		public int4 rtSize;
		public float4 rtHandleScale;
	}

	[Serializable]
	public struct CameraData {
		public float4 cameraPosWS;
		public float4 cameraFwdWS;
		public float4 screenSize;
		public float4x4 frustumCornersWS;
		public float4x4 prevFrustumCornersWS;
		public PackedRTHandleProperties _rtHandleProps;
	}

	[Serializable]
	public struct DiffuseProbeParams {
		public float4 _DiffuseProbeParams0;
		public float4 _DiffuseProbeParams1;
		public float4 _DiffuseProbeParams2;
		public int4 _DiffuseProbeParams3;
		public float4 _DiffuseProbeParams4;
		public float4 _DiffuseProbeParams5;
	}

	[Serializable]
	public struct DirectionalLight {
		public float4 direction;
		public float4 color; // rgb - final light color, a - unused
	}
	
	public enum DiffuseProbeDebugMode {
		IRRADIANCE = 0,
		INDIRECT_DIFFUSE = 1,
		ALBEDO = 2,
		SKY_VISIBILITY = 3,
		ENCODED_NORMAL = 4,
		NORMAL = 5,
		RADIAL_DEPTH = 6,
		RADIAL_DEPTH_NORM = 7,
		VISIBILITY_DEPTH = 8,
		VISIBILITY_DEPTH_NORM = 9,
		VISIBILITY_DEPTH_2 = 10,
		VISIBILITY_DEPTH_2_NORM = 11,
		RADIANCE = 12
	}
}