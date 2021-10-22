#if !defined(POWER_FUR_INPUT_CGINC)
#define POWER_FUR_INPUT_CGINC
    struct appdata
    {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
        float3 normal:NORMAL;
        float4 color:COLOR;
        UNITY_VERTEX_INPUT_INSTANCE_ID
    };

    struct v2f
    {
        float4 uv : TEXCOORD0;
        UNITY_FOG_COORDS(1)
        float4 vertex : SV_POSITION;
        float3 diffColor:TEXCOORD2;

        float3 worldPos:TEXCOORD3;
        float3 worldNormal :TEXCOORD4;
        UNITY_VERTEX_INPUT_INSTANCE_ID 
    };

    sampler2D _MainTex;
    sampler2D _FurMaskMap; // r alpha noise, g position offset atten ,b ao
    sampler2D _FlowMap;

#if !defined(INSTANCING_ON) 
CBUFFER_START(UnityPerMaterial)
    float4 _MainTex_ST;
    float4 _Color;
    float4 _FurMaskMap_ST;

    int _VertexOffsetAttenUseFurMaskY;
    float _Density;
    float _Length;
    float _Rigidness;
    
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
    #if !defined(MULTI_PASS)
    float _FurOffset;
    #endif
#else
UNITY_INSTANCING_BUFFER_START(PropBuffer)
    UNITY_DEFINE_INSTANCED_PROP(float4,_MainTex_ST)
    UNITY_DEFINE_INSTANCED_PROP(float4,_Color)
    UNITY_DEFINE_INSTANCED_PROP(float4,_FurMaskMap_ST)
    UNITY_DEFINE_INSTANCED_PROP(float,_VertexOffsetAttenUseFurMaskY)
    UNITY_DEFINE_INSTANCED_PROP(float,_Density)

    UNITY_DEFINE_INSTANCED_PROP(float,_Length)
    UNITY_DEFINE_INSTANCED_PROP(float,_Rigidness)
    UNITY_DEFINE_INSTANCED_PROP(float4,_UVOffset)
    UNITY_DEFINE_INSTANCED_PROP(float,_FragmentAOOn)
    UNITY_DEFINE_INSTANCED_PROP(float,_VertexAOOn)

    UNITY_DEFINE_INSTANCED_PROP(float,_FlowMapOn)
    UNITY_DEFINE_INSTANCED_PROP(float4,_FlowMap_ST)
    UNITY_DEFINE_INSTANCED_PROP(float,_FlowMapIntensity)
    UNITY_DEFINE_INSTANCED_PROP(float,_WindOn)
    UNITY_DEFINE_INSTANCED_PROP(float,_WindScale)

    UNITY_DEFINE_INSTANCED_PROP(float3,_WindDir)
    UNITY_DEFINE_INSTANCED_PROP(float4,_Color1)
    UNITY_DEFINE_INSTANCED_PROP(float4,_Color2)
    UNITY_DEFINE_INSTANCED_PROP(float,_ThicknessMax)
    UNITY_DEFINE_INSTANCED_PROP(float,_ThicknessMin)

    UNITY_DEFINE_INSTANCED_PROP(float,_LightOn)
    UNITY_DEFINE_INSTANCED_PROP(float,_Roughness)
    UNITY_DEFINE_INSTANCED_PROP(float,_Metallic)
    UNITY_DEFINE_INSTANCED_PROP(float,_FurOffset)
UNITY_INSTANCING_BUFFER_END(PropBuffer)

#define _MainTex_ST UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_MainTex_ST)
#define _Color UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_Color)
#define _FurMaskMap_ST UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_FurMaskMap_ST)
#define _VertexOffsetAttenUseFurMaskY UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_VertexOffsetAttenUseFurMaskY)
#define _Density UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_Density)

#define _Length UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_Length)
#define _Rigidness UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_Rigidness)
#define _UVOffset UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_UVOffset)
#define _FragmentAOOn UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_FragmentAOOn)
#define _VertexAOOn UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_VertexAOOn)

#define _FlowMapOn UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_FlowMapOn)
#define _FlowMap_ST UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_FlowMap_ST)
#define _FlowMapIntensity UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_FlowMapIntensity)
#define _WindOn UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_WindOn)
#define _WindScale UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_WindScale)

#define _WindDir UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_WindDir)
#define _Color1 UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_Color1)
#define _Color2 UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_Color2)
#define _ThicknessMax UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_ThicknessMax)
#define _ThicknessMin UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_ThicknessMin)

#define _LightOn UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_LightOn)
#define _Roughness UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_Roughness)
#define _Metallic UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_Metallic)
#define _FurOffset UNITY_ACCESS_INSTANCED_PROP(PropBuffer,_FurOffset)
#endif 
#endif //POWER_FUR_INPUT_CGINC