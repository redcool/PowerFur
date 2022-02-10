# PowerFur
a shader render fur , for drp,urp

urp : need multipass feature,
     get MultiPassRenderObjects.cs from https://github.com/redcool/PowerURP/tree/main/PowerURP/Scripts/Features/UrpMultiPassRender

1 mesh render can use instanced
     1 attach DrawFurObjectInstanced.cs to gameobject
     2 gameobject's shader use PowerFurInstanced.shader
2 skinned mesh use PowerFurPasses.shader