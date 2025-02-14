Shader "Unlit/Bg"
{
    Properties
    {
        _ColorTop ("Top Color", Color) = (0.1, 0.4, 0.8, 1)
        _ColorBottom ("Bottom Color", Color) = (0.2, 0.2, 0.4, 1)
        _WaveSpeed ("Wave Speed", Float) = 0.5
        _WaveHeight ("Wave Height", Float) = 0.2
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

            float4 _ColorTop;
            float4 _ColorBottom;
            float _WaveSpeed;
            float _WaveHeight;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Create animated gradient with subtle wave
                float wave = sin(i.uv.x * 6.28318 + _Time.y * _WaveSpeed) * _WaveHeight;
                float t = i.uv.y + wave;
                fixed4 col = lerp(_ColorBottom, _ColorTop, t);
                return col;
            }
            ENDCG
        }
    }
}