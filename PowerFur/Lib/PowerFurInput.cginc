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

UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
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
    // UNITY_DEFINE_INSTANCED_PROP(float,_Cutoff)
    UNITY_DEFINE_INSTANCED_PROP(float,_FurEdgeMode)
    #if !defined(MULTI_PASS)
    UNITY_DEFINE_INSTANCED_PROP(float,_FurOffset)
    #endif
UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)

#define _MainTex_ST UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_MainTex_ST)
#define _Color UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Color)
#define _FurMaskMap_ST UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_FurMaskMap_ST)
#define _VertexOffsetAttenUseFurMaskY UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_VertexOffsetAttenUseFurMaskY)
#define _Density UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Density)

#define _Length UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Length)
#define _Rigidness UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Rigidness)
#define _UVOffset UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_UVOffset)
#define _FragmentAOOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_FragmentAOOn)
#define _VertexAOOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_VertexAOOn)

#define _FlowMapOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_FlowMapOn)
#define _FlowMap_ST UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_FlowMap_ST)
#define _FlowMapIntensity UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_FlowMapIntensity)
#define _WindOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_WindOn)
#define _WindScale UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_WindScale)

#define _WindDir UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_WindDir)
#define _Color1 UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Color1)
#define _Color2 UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Color2)
#define _ThicknessMax UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_ThicknessMax)
#define _ThicknessMin UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_ThicknessMin)

#define _LightOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_LightOn)
#define _Roughness UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Roughness)
#define _Metallic UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Metallic)
// #define _Cutoff UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Cutoff)
#define _FurEdgeMode UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_FurEdgeMode)

// instance version vs multipass
#if !defined(MULTI_PASS)
#define _FurOffset UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_FurOffset)
#endif
#endif //POWER_FUR_INPUT_CGINC