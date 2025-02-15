Shader "Unlit/Bg"
{
    Properties
    {
        _ColorSky ("Sky Color", Color) = (0.4, 0.7, 1.0, 1)
        _ColorHorizon ("Horizon Color", Color) = (0.6, 0.8, 1.0, 1)
        _ColorGround ("Ground Color", Color) = (0.3, 0.8, 0.3, 1)
        _HorizonLine ("Horizon Line", Range(0, 1)) = 0.5
        _HorizonBlend ("Horizon Blend", Range(0, 0.5)) = 0.1
        _CloudSpeed ("Cloud Speed", Float) = 0.2
        _CloudScale ("Cloud Scale", Float) = 4.0
        _CloudDensity ("Cloud Density", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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

            float4 _ColorSky;
            float4 _ColorHorizon;
            float4 _ColorGround;
            float _HorizonLine;
            float _HorizonBlend;
            float _CloudSpeed;
            float _CloudScale;
            float _CloudDensity;

            // Simple noise function
            float noise(float2 uv) {
                return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453123);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Create sky gradient
                float gradientBlend = smoothstep(_HorizonLine - _HorizonBlend, _HorizonLine + _HorizonBlend, i.uv.y);
                float4 skyColor = lerp(_ColorHorizon, _ColorSky, gradientBlend);
                float4 groundColor = lerp(_ColorHorizon, _ColorGround, 1 - gradientBlend);
                float4 baseColor = lerp(groundColor, skyColor, step(i.uv.y, _HorizonLine));

                // Add clouds in sky area
                if (i.uv.y > _HorizonLine) {
                    float2 cloudUV = i.uv * _CloudScale;
                    cloudUV.x += _Time.y * _CloudSpeed;
                    
                    float cloud = noise(cloudUV) * noise(cloudUV * 2.5 + 8.7);
                    cloud = smoothstep(_CloudDensity, 0.95, cloud);
                    
                    // Only add clouds above horizon
                    float cloudMask = smoothstep(_HorizonLine, _HorizonLine + 0.1, i.uv.y);
                    baseColor = lerp(baseColor, float4(1,1,1,1), cloud * cloudMask * 0.3);
                }

                return baseColor;
            }
            ENDCG
        }
    }
}