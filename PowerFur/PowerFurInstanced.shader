Shader "Character/Fur/PowerFurInstanced"
{
    Properties
    {
        [GroupHeader(v0.0.2)]
        [Group(Main)]
        [GroupItem(Main)]_MainTex ("Texture", 2D) = "white" {}
        [GroupItem(Main)][hdr]_Color("_Color",color) = (1,1,1,1)
        [GroupItem(Main)]_FurMaskMap("_FurMaskMap (R:Alpha Culling,G:Vertex Offset Atten,B: AO)",2d)=""{}

        [Group(Vertex Offset)]
        [GroupToggle(Vertex Offset)]_VertexOffsetAttenUseFurMaskY("_VertexOffsetAttenUseFurMaskY",int) = 0
        [GroupItem(Vertex Offset)]_Length("_Length( offset along normal)",float) =1
        [GroupItem(Vertex Offset)]_Rigidness("_Rigidness(y offset)",float)=1

        [Group(AO)]
        [GroupToggle(AO)]_VertexAOOn("_VertexAOOn",int) = 1
        [GroupToggle(AO)]_FragmentAOOn("_FragmentAOOn",int) = 1

        // [Group(UV Offset)]
        // _UVOffset("_UVOffset(XY:uv tiling,ZW: offset)",vector) = (0,0,0,0)
        
        [Group(FlowMap)]
        [GroupToggle(FlowMap)]_FlowMapOn("_FlowMapOn",int) = 0
        [GroupItem(FlowMap)]_FlowMap("_FlowMap(xy: offset uv,z : offset intensity mask)",2d) = ""{}
        [GroupItem(FlowMap)]_FlowMapIntensity("_FlowMapIntensity",float) = 1

        [Group(Wind)]
        [GroupToggle(Wind)]_WindOn("_WindOn",int) = 0
        [GroupItem(Wind)]_WindScale("_WindScale",float) = 0
        [GroupItem(Wind)]_WindDir("_WindDir",vector) = (1,0,0,0)

        [Group(Color)]
        [GroupItem(Color)][hdr]_Color1("Dark Color",color) = (0.5,.5,.5,1)
        [GroupItem(Color)][hdr]_Color2("Bright Color",color) = (1,1,1,1)
        
        [Group(Thickness)]
        [GroupItem(Thickness)]_ThicknessMin("_ThicknessMin",float) = 0.1
        [GroupItem(Thickness)]_ThicknessMax("_ThicknessMax",float) = 0.7

        [Group(Light)]
        [GroupToggle(Light)]_LightOn("_LightOn",int) = 0
        [GroupItem(Light)]_Metallic("_Metallic",range(0,1)) = 0
        [GroupItem(Light)]_Roughness("_Roughness",range(0,1)) = 0.5

        [Group(Rim)]
        [GroupItem]_RimIntensity("_RimIntensity",range(0,3)) = 1

        [Group(Settings)]
        [GroupToggle(Settings)]_ZWrite("_ZWrite",int) = 1
        [GroupEnum(Settings,UnityEngine.Rendering.CullMode)]_CullMode("_CullMode",float) = 2
        [GroupEnum(Settings,Normal 0 Soft 1)]_FurEdgeMode("_FurEdgeMode",float) = 0
        
        // [Group(Alpha)]
        // [GroupToggle(Alpha,_ALPHA_TEST)]_CutoffOn("_CutoffOn",int) = 0
        // [GroupItem(Alpha)]_Cutoff("_Cutoff",range(0,1)) = 0.5

        [HideInInspector]_FurOffset("_FurOffset",Float) = 0
    }

    SubShader
    {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
        // blend srcAlpha one
        zwrite[_ZWrite]
        cull [_CullMode]
        pass{
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            // #pragma shader_feature _ALPHA_TEST
            #define UnityPerMaterial _UnityPerMaterial
            // #define USE_URP
            #include "Lib/PowerFurPass.hlsl"
            ENDHLSL
        }
    }
}
