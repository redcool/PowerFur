Shader "Character/Fur/PowerFurInstanced"
{
    Properties
    {
        [Header(Main)]
        _MainTex ("Texture", 2D) = "white" {}
        [hdr]_Color("_Color",color) = (1,1,1,1)
        _FurMaskMap("_FurMaskMap (R:Alpha Culling,G:Vertex Offset Atten,B: AO)",2d)=""{}

        [Header(Vertex Offset)]
        [Toggle]_VertexOffsetAttenUseFurMaskY("_VertexOffsetAttenUseFurMaskY",int) = 0
        _Length("_Length( offset along normal)",float) =1
        _Rigidness("_Rigidness(y offset)",float)=1

        [Header(AO)]
        [Toggle]_VertexAOOn("_VertexAOOn",int) = 1
        [Toggle]_FragmentAOOn("_FragmentAOOn",int) = 1

        // [Header(UV Offset)]
        // _UVOffset("_UVOffset(XY:uv tiling,ZW: offset)",vector) = (0,0,0,0)
        
        [Header(FlowMap)]
        [Toggle]_FlowMapOn("_FlowMapOn",int) = 0
        _FlowMap("_FlowMap(xy: offset uv,z : offset intensity mask)",2d) = ""{}
        _FlowMapIntensity("_FlowMapIntensity",float) = 1

        [Header(Wind)]
        [Toggle]_WindOn("_WindOn",int) = 0
        _WindScale("_WindScale",float) = 0
        _WindDir("_WindDir",vector) = (1,0,0,0)

        [Header(Color)]
        [hdr]_Color1("Dark Color",color) = (0.5,.5,.5,1)
        [hdr]_Color2("Bright Color",color) = (1,1,1,1)
        
        [Header(Thickness)]
        _ThicknessMin("_ThicknessMin",float) = 0.1
        _ThicknessMax("_ThicknessMax",float) = 0.7

        [Header(Light)]
        [Toggle]_LightOn("_LightOn",int) = 0
        _Metallic("_Metallic",range(0,1)) = 0
        _Roughness("_Roughness",range(0,1)) = 0.5

    }


    SubShader
    {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
        // blend srcAlpha one
        pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "Lib/PowerFurPass.cginc"
            ENDCG
        }
    }
}
