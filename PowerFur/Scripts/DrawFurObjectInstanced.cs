using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class DrawFurObjectInstanced : MonoBehaviour
{
    private Mesh mesh;
    [Header("Offset Prop")]
    public float baseScale  = 0.07f;
    public float stepScale = 0.03f;
    public int drawCount = 11;

    MeshFilter mf;
    
    Material[] mats;
    List<Matrix4x4> transformList = new List<Matrix4x4>();
    static MaterialPropertyBlock block;
    // Start is called before the first frame update
    void OnEnable()
    {
        if (block == null)
            block = new MaterialPropertyBlock();

        mf = GetComponent<MeshFilter>();
        mesh = mf.sharedMesh;

        var r = GetComponent<Renderer>();
        mats = r.sharedMaterials;
        r.enabled = false;


        transformList.Clear();
        var offsetList = new List<float>();
        for (int i = 0; i < drawCount; i++)
        {
            transformList.Add(mf.transform.localToWorldMatrix);
            offsetList.Add(baseScale + i * stepScale);
        }

        block.SetFloatArray("_FurOffset", offsetList);
    }

    // Update is called once per frame
    void Update()
    {
        if (!mesh)
        {
            enabled = false;
            return;
        }

        for (int i = 0; i < mesh.subMeshCount; i++)
        {
            if (i > mats.Length)
                break;

            Graphics.DrawMeshInstanced(mesh, i, mats[i], transformList, block);
        }

#if UNITY_EDITOR
        if (transform.hasChanged)
        {
            OnEnable();
        }
#endif
    }
}
