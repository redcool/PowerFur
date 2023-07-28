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

        [Group(Settings)]
        [GroupToggle(Settings)]_ZWrite("_ZWrite",int) = 1
        [GroupEnum(Settings,UnityEngine.Rendering.CullMode)]_CullMode("_CullMode",float) = 2
        [GroupEnum(Settings,Normal 0 Soft 1)]_FurEdgeMode("_FurEdgeMode",float) = 0
    }


    SubShader
    {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
        zwrite [_ZWrite]
        cull [_CullMode]
        // blend srcAlpha one
        pass{
            Tags{"LightMode"="FurPass0"}
            HLSLPROGRAM
            #define _FurOffset 0.05
            #pragma vertex vert
            #pragma fragment frag
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
            #pragma multi_compile_instancing

            #pragma vertex vert
            #pragma fragment frag

            // -------------------------------------
            // This is used during shadow map generation to differentiate between directional and punctual light shadows, as they use different formulas to apply Normal Bias
            #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW			
            // Material Keywords
            #pragma shader_feature_local_fragment ALPHA_TEST

			#include "../../PowerShaderLib/Lib/UnityLib.hlsl"
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
