#if !defined(POWER_FUR_CORE_CGINC)
#define POWER_FUR_CORE_CGINC

    float3 CalcWind(float3 worldPos,float3 windDir,float windScale){
        float2 uv = worldPos.xz * _Time.y;
        float noise = Unity_GradientNoise(uv,windScale);
        float3 p = noise * 0.02 * windDir;
        return worldPos + p;
    }

    float MinimalistCookTorrance(float nh,float lh,float rough,float rough2){
        float d = nh * nh * (rough2-1) + 1.00001f;
        float lh2 = lh * lh;
        float spec = rough2/((d*d) * max(0.1,lh2) * (rough*4+2)); // approach sqrt(rough2)
        
        #if defined (SHADER_API_MOBILE) || defined (SHADER_API_SWITCH)
            spec = clamp(spec,0,100);
        #endif
        return spec;
    }

    float3 CalcSpec(float3 l,float3 v,float3 n,float a,float a2){
        float3 h = normalize(l + v);
        float nh = saturate(dot(n,h));
        float lh = saturate(dot(l,h));
    
        float3 specColor = MinimalistCookTorrance(nh,lh,a,a*a);
        return specColor;
    }
    void CalcLight(float3 worldPos,float3 normal,float3 albedo,float roughness,float metallic,out float3 diffColor/**/,out float3 specColor/**/,out float nl){
        float3 l = UnityWorldSpaceLightDir(worldPos);
        float3 v = UnityWorldSpaceViewDir(worldPos);
        float a  =roughness * roughness;
        float a2 = a*a;
        nl = saturate(dot(normal,l));

        float specTerm = CalcSpec(l,v,normal,a,a2) ;
        specColor = specTerm * lerp(0.04, albedo,metallic)* nl;
        diffColor = albedo * saturate(1 - metallic)* nl;
    }
#endif //POWER_FUR_CORE_CGINC