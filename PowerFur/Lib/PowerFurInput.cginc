#if !defined(POWER_FUR_INPUT_CGINC)
#define POWER_FUR_INPUT_CGINC
    struct appdata
    {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
        float3 normal:NORMAL;
        float4 color:COLOR;
    };

    struct v2f
    {
        float4 uv : TEXCOORD0;
        UNITY_FOG_COORDS(1)
        float4 vertex : SV_POSITION;
        float3 diffColor:TEXCOORD2;

        float3 worldPos:TEXCOORD3;
        float3 worldNormal :TEXCOORD4;
    };

    sampler2D _MainTex;
    sampler2D _FurMaskMap; // r alpha noise, g position offset atten ,b ao
    sampler2D _FlowMap;

CBUFFER_START(UnityPerMaterial)
    float4 _MainTex_ST;
    float4 _Color;
    float4 _FurMaskMap_ST;

    int _VertexOffsetAttenUseFurMaskY;
    float _Density;
    float _Length,_Rigidness;
    //
    float _FurRadius;
    float _OcclusionPower;
    float4 _OcclusionColor;
    float4 _UVOffset;

    // ao 
    int _FragmentAOOn,_VertexAOOn;

    //flow map
    int _FlowMapOn;
    float4 _FlowMap_ST;
    float _FlowMapIntensity;

    //wind
    int _WindOn;
    float _WindScale;
    float3 _WindDir;

    // diffuse color
    float4 _Color1,_Color2;

    float _ThicknessMax,_ThicknessMin;
    int _LightOn;
    float _Roughness;
    float _Metallic;
CBUFFER_END
#endif //POWER_FUR_INPUT_CGINC