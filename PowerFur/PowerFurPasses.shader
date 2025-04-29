Shader "Character/Fur/PowerFurPasses"
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
        [GroupItem(Rim)]_RimIntensity("_RimIntensity",range(0,3)) = 1

        [Group(Edge)]
        [GroupEnum(Edge,Normal 0 Soft 1)]_FurEdgeMode("_FurEdgeMode",float) = 0
// ================================================== StateSettings
        [Group(StateSettings)]

        [GroupEnum(StateSettings,UnityEngine.Rendering.CullMode)]_CullMode("_CullMode",int) = 2
		[GroupToggle(StateSettings)]_ZWriteMode("ZWriteMode",int) = 0
        /*
		Disabled,Never,Less,Equal,LessEqual,Greater,NotEqual,GreaterEqual,Always
		*/
		[GroupEnum(StateSettings,UnityEngine.Rendering.CompareFunction)]_ZTestMode("_ZTestMode",float) = 4        
// ================================================== alpha        
        [Group(Alpha)]
        [GroupHeader(Alpha,AlphaTest)]
        [GroupToggle(Alpha,ALPHA_TEST)]_AlphaTestOn("_AlphaTestOn",int) = 0
        [GroupSlider(Alpha)]_Cutoff("_Cutoff",range(0,1)) = 0.5

        [GroupHeader(Alpha,BlendMode)]
        [GroupPresetBlendMode(Alpha,,_SrcMode,_DstMode)]_PresetBlendMode("_PresetBlendMode",int)=0
        [HideInInspector]_SrcMode("_SrcMode",int) = 1
        [HideInInspector]_DstMode("_DstMode",int) = 0        
// ================================================== stencil settings
        [Group(Stencil)]
		[GroupEnum(Stencil,UnityEngine.Rendering.CompareFunction)]_StencilComp ("Stencil Comparison", Float) = 0
        [GroupStencil(Stencil)] _Stencil ("Stencil ID", int) = 0
        [GroupEnum(Stencil,UnityEngine.Rendering.StencilOp)]_StencilOp ("Stencil Operation", Float) = 0
        [HideInInspector] _StencilWriteMask ("Stencil Write Mask", Float) = 255
        [HideInInspector] _StencilReadMask ("Stencil Read Mask", Float) = 255

        // [HideInInspector]_FurOffset("_FurOffset",Float) = 0
    }

    SubShader
    {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
		Blend [_SrcMode] [_DstMode]
        zwrite [_ZWrite]
        cull [_CullMode]

        pass{
            Tags{"LightMode"="FurPass0"}
            zwrite on
            HLSLPROGRAM
            #define _FurOffset 0.05
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature ALPHA_TEST
            #define MULTI_PASS  
            #include "Lib/PowerFurPass.hlsl"
            ENDHLSL
        }
        
        pass{
            Tags{"LightMode"="FurPass1"}
            HLSLPROGRAM
            #define _FurOffset 0.1
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature ALPHA_TEST
            #define MULTI_PASS  
            #include "Lib/PowerFurPass.hlsl"
            ENDHLSL
        }

        pass{
            Tags{"LightMode"="FurPass2"}
            HLSLPROGRAM
            #define _FurOffset 0.13
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature ALPHA_TEST
            #define MULTI_PASS  
            #include "Lib/PowerFurPass.hlsl"            
            ENDHLSL
        }
        pass{
            Tags{"LightMode"="FurPass3"}
            HLSLPROGRAM
            #define _FurOffset 0.16
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature ALPHA_TEST
            #define MULTI_PASS  
            #include "Lib/PowerFurPass.hlsl"            
            ENDHLSL
        }

         pass{
            Tags{"LightMode"="FurPass4"}
            HLSLPROGRAM
            #define _FurOffset 0.19
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature ALPHA_TEST
            #define MULTI_PASS  
            #include "Lib/PowerFurPass.hlsl"            
            ENDHLSL
        }

        pass{
            Tags{"LightMode"="FurPass5"}
            HLSLPROGRAM
            #define _FurOffset 0.22
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature ALPHA_TEST
            #define MULTI_PASS  
            #include "Lib/PowerFurPass.hlsl"            
            ENDHLSL
        }
        pass{
            Tags{"LightMode"="FurPass6"}
            HLSLPROGRAM
            #define _FurOffset 0.25
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature ALPHA_TEST
            #define MULTI_PASS  
            #include "Lib/PowerFurPass.hlsl"            
            ENDHLSL
        }
        pass{
            Tags{"LightMode"="FurPass7"}
            HLSLPROGRAM
            #define _FurOffset 0.28
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature ALPHA_TEST
            #define MULTI_PASS  
            #include "Lib/PowerFurPass.hlsl"            
            ENDHLSL
        }
        pass{
            Tags{"LightMode"="FurPass8"}
            HLSLPROGRAM
            #define _FurOffset 0.31
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature ALPHA_TEST
            #define MULTI_PASS  
            #include "Lib/PowerFurPass.hlsl"            
            ENDHLSL
        }
        pass{
            Tags{"LightMode"="FurPass9"}
            HLSLPROGRAM
            #define _FurOffset 0.34
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature ALPHA_TEST
            #define MULTI_PASS  
            #include "Lib/PowerFurPass.hlsl"            
            ENDHLSL
        }
        pass{
            Tags{"LightMode"="FurPass10"}
            HLSLPROGRAM
            #define _FurOffset 0.37
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature ALPHA_TEST
            #define MULTI_PASS 
            #include "Lib/PowerFurPass.hlsl"            
            ENDHLSL
        }

		Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite [_ZWriteMode]
            ColorMask 0
            Cull[_CullMode]

            HLSLPROGRAM
            //--------------------------------------
            // GPU Instancing
            // #pragma multi_compile_instancing

            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature ALPHA_TEST

            // -------------------------------------
            // This is used during shadow map generation to differentiate between directional and punctual light shadows, as they use different formulas to apply Normal Bias
            #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW			
            // Material Keywords
            #pragma shader_feature_local_fragment ALPHA_TEST

			#include "../../PowerShaderLib/Lib/UnityLib.hlsl"
            #define _FurOffset 0.37
            #define MULTI_PASS 
			#include "Lib/PowerFurPass.hlsl"
			#define SHADOW_PASS
			#define USE_SAMPLER2D
			// #define _MainTex _DissolveTex

			// #undef _MainTexChannel
			// #define _MainTexChannel _DissolveTexChannel
			#include "../../PowerShaderLib/UrpLib/ShadowCasterPass.hlsl"

            ENDHLSL
        }
    }
}
