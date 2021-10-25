#if !defined(POWER_FUR_PASS)
#define POWER_FUR_PASS
    #include "UnityCG.cginc"
    #include "Lib/NodeLib.cginc"
    #include "Lib/PowerFurInput.cginc"
    #include "Lib/PowerFurCore.cginc"

    v2f vert (appdata v)
    {
        v2f o = (v2f)0;
        UNITY_SETUP_INSTANCE_ID(v);
        UNITY_TRANSFER_INSTANCE_ID(v, o); 

        float2 mainUV = TRANSFORM_TEX(v.uv, _MainTex);
        float2 maskUV = TRANSFORM_TEX(v.uv, _FurMaskMap);
        float4 furMask = tex2Dlod(_FurMaskMap,float4(maskUV,0,0)); // r alpha noise, g position offset atten ,b ao

        // vertex offset atten
        float vertexOffsetAtten = 1;
        if(_VertexOffsetAttenUseFurMaskY){
            vertexOffsetAtten = furMask.y;
        }

        // vertex offset
        float3 pos = v.vertex + v.normal * _FurOffset * _Length * vertexOffsetAtten * 0.2;
        // add gravity
        pos.y += clamp(_Rigidness,-3,3) * pow(_FurOffset,3) * _Length * vertexOffsetAtten;
        
        // apply wind in world space
        float3 worldPos = mul(unity_ObjectToWorld,float4(pos,1));
        if(_WindOn){
            worldPos = CalcWind(worldPos,_WindDir,_WindScale);
        }

        o.vertex = mul(UNITY_MATRIX_VP,float4(worldPos,1));
        o.uv.xy = mainUV;

        // _FurMaskMap_ST uv offset
        // o.uv.zw = v.uv * _UVOffset.xy + _UVOffset.zw * _FurOffset;
        // float2 uvOffset = _FurOffset * _UVOffset.xy * 0.1;
        o.uv.zw = v.uv * _FurMaskMap_ST.xy + _FurMaskMap_ST.zw;

        UNITY_TRANSFER_FOG(o,o.vertex);

        // diffuse color
        float3 normal = UnityObjectToWorldNormal(v.normal);        
        float3 lightDir = UnityWorldSpaceLightDir(worldPos);
        float3 viewDir = UnityWorldSpaceViewDir(worldPos);
        float nl = saturate(dot(lightDir,normal));
        // float nv = saturate(dot(viewDir,normal));

        o.diffColor = lerp(_Color1,_Color2,nl);
        if(_VertexAOOn){
            o.diffColor *= furMask.b * (1 - _FurOffset);
        }
        o.worldPos = worldPos;
        o.worldNormal = normal;
        return o;
    }

    float Pow4(float a){
        return a*a*a*a;
    }

    float4 frag (v2f i) : SV_Target
    {
        UNITY_SETUP_INSTANCE_ID(i);
        
        // sample the texture
        float4 albedo = tex2D(_MainTex, i.uv.xy) * _Color;
        float4 col = float4(0,0,0,1);

        // flow map
        float2 uvOffset = 0;
        if(_FlowMapOn){
            float2 flowUV = i.uv.xy * _FlowMap_ST.xy + _FlowMap_ST.zw;
            float4 flowMap = tex2D(_FlowMap,flowUV);

            uvOffset = (flowMap.xy * 2-1) * _FlowMapIntensity * flowMap.z;
        }
        // sample fur mask
        float2 furMaskUV = i.uv.zw + uvOffset * 0.1 * _FurOffset;
        float4 furMask = tex2D(_FurMaskMap,furMaskUV); // r alpha noise, g position offset atten ,b ao

        if(_LightOn){
            float3 diffColor = 0,specColor = 0;
            float nl = 0;
            CalcLight(i.worldPos,i.worldNormal,albedo,_Roughness,_Metallic,diffColor/**/,specColor/**/,nl);
            float3 brdfColor = (diffColor + specColor);
            col.xyz = lerp(albedo ,brdfColor,nl) * i.diffColor;
        }else{
            col.xyz = albedo * i.diffColor;
        }

        if(_FragmentAOOn){
            col.xyz *= furMask.b;
        }

        float alphaNoise = furMask.x;
        float alphaLayered = Pow4(1 - _FurOffset);
        float a = smoothstep(_ThicknessMin,_ThicknessMax, alphaLayered + alphaNoise);
        if(_FurOffset < 0.1)
            a = 1;
        
        // apply fog
        UNITY_APPLY_FOG(i.fogCoord, col);
        return float4(col.xyz,saturate(a));
    }
#endif //POWER_FUR_PASS