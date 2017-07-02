﻿Shader "Hidden/GrayscaleMaskImageEffect"
{
	Properties
	{
		[HideInInspector] _MainTex ("Texture", 2D) = "white" {}
		[NoScaleOffset] _MaskTex ("Mask (A)", 2D) = "white" {}
		_Intensity ("Intensity", Range(0,1)) = 1
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _MaskTex;
			float _Intensity;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);

				// mask is stored in alpha channel of mask texture
				// use 'Alpha 8' texture format for mask texture
				float weight = tex2D(_MaskTex, i.uv).a;

				// blend between color and grayscale depeding on weight,
				// aka alpha intensity, from mask texture				
				col.rgb = lerp(col.rgb, Luminance(col.rgb), weight * _Intensity);

				return col;
			}
			ENDCG
		}
	}
}
