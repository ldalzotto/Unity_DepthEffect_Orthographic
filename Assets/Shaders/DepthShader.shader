Shader "Unlit/DepthShader"
{
	Properties
	{
		 _MainTex("Texture", 2D) = "white" {}
		 _HighlightThresholdMax("Highlight Threshold Max", Range(0,0.05)) = 1
		 _RegularColor("RCD", Color) = (1,1,1,1)
		 _HighlightColor("RCD", Color) = (1,1,1,1)
	}
		SubShader
		 {
			 Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
			 Blend SrcAlpha OneMinusSrcAlpha
			 ZWrite Off
			 Cull Off
			 Pass
			 {

				 CGPROGRAM

				 #pragma vertex vert
				 #pragma fragment frag

				 #include "UnityCG.cginc"

				 struct appdata
				 {
					 float4 vertex : POSITION;
					 float2 uv : TEXCOORD0;
				 };

				 struct v2f
				 {
					 float2 uv : TEXCOORD0;
					 float4 vertex : SV_POSITION;
					 float4 screenPos : TEXCOORD1;
				 };

				 sampler2D _MainTex;
				 sampler2D _CameraDepthTexture;
				 float4 _RegularColor;
				 float4 _HighlightColor;
				 float4 _MainTex_ST;
				 float _HighlightThresholdMax;

				 v2f vert(appdata v)
				 {
					 v2f o;
					 o.vertex = UnityObjectToClipPos(v.vertex);
					 o.screenPos = ComputeScreenPos(o.vertex);
					 return o;
				 }

				 fixed4 frag(v2f i) : SV_Target
				 {
					  float4 finalColor = _RegularColor;

					  // sample the texture in the orthographic way
					  float sceneDepth = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)).r;
					  float objectZ = i.screenPos.z;
					  float diff = (abs(sceneDepth - objectZ)) / _HighlightThresholdMax;
					  if (diff < 1) {
						  finalColor = lerp(_HighlightColor,
							  _RegularColor, float4(diff, diff, diff, diff));
					  }

					  // float debugDiff = (abs(sceneDepth - objectZ)) * 1000;
					 //  return fixed4(debugDiff, debugDiff, debugDiff, 1);

						return finalColor;
					}
					ENDCG
				}
		 }
			 FallBack "VertexLit"
}
