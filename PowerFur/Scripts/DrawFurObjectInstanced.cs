namespace PowerUtilities
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using UnityEngine;
    using UnityEngine.Rendering;
    using System.Linq;

#if UNITY_EDITOR
    using UnityEditor;

    [CustomEditor(typeof(DrawFurObjectInstanced))]
    public class DrawFurObjectInstancedEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            EditorGUI.BeginChangeCheck();
            base.OnInspectorGUI();

            if (EditorGUI.EndChangeCheck())
            {
                var inst = target as DrawFurObjectInstanced;
                inst.OnEnable();
            }
        }
    }
#endif

    [ExecuteInEditMode]
    public class DrawFurObjectInstanced : MonoBehaviour
    {
        [Serializable]
        public class DrawInfo
        {
            public Renderer renderer;
            public Mesh mesh;
            public List<Matrix4x4> transformList = new List<Matrix4x4>();
            public List<float> offsetList = new List<float>();

            public void Clear()
            {
                transformList.Clear(); offsetList.Clear();
            }
            public bool IsValid() => renderer;// && renderer.isVisible;
        }

        [Header("Visible")]
        public bool isHiddenRenderer = false;
        [Tooltip("2 materials for alpha sort")]
        public Material[] furMaterials;

        [Header("Shader Variables")]
        public string _FurOffset = nameof(_FurOffset);

        [Header("Offset Prop")]
        [Min(0)]
        [Tooltip("vertex base scale factor")]
        public float baseScale = 0.07f;

        [Tooltip("vertex scale factor every time")]
        public float stepScale = 0.03f;

        [Min(0)] public int drawCount = 11;


        [Header("Debug Info")]
        public List<DrawInfo> drawInfoList = new List<DrawInfo>();
        public bool hasSkinned;

        static MaterialPropertyBlock block;
        // Start is called before the first frame update
        public void OnEnable()
        {
            if (block == null)
                block = new MaterialPropertyBlock();

            hasSkinned = SetupDrawInfos();
        }

        public void OnDisable()
        {
            drawInfoList.Clear();
        }

        public bool SetupDrawInfos()
        {
            var hasSkinned = false;
            drawInfoList.Clear();
            var renders = GetComponentsInChildren<Renderer>(false);
            foreach (Renderer r in renders)
            {
                r.enabled = !isHiddenRenderer;

                var info = new DrawInfo
                {
                    renderer = r,
                };
                drawInfoList.Add(info);

                if (r.TryGetComponent<MeshFilter>(out var filter))
                    info.mesh = filter.sharedMesh;
                else
                    info.mesh = new Mesh();

                hasSkinned = hasSkinned || (r is SkinnedMeshRenderer);
            }
            return hasSkinned;
        }


        private void UpdateDrawInfoList()
        {
            foreach (var drawInfo in drawInfoList)
            {
                if (!drawInfo.IsValid())
                    continue;

                if(drawInfo.renderer is SkinnedMeshRenderer skinned)
                {
                    skinned.BakeMesh(drawInfo.mesh, true);
                }

                drawInfo.transformList.Clear();
                drawInfo.offsetList.Clear();

                for (int i = 0; i < drawCount; i++)
                {
                    drawInfo.transformList.Add(drawInfo.renderer.transform.localToWorldMatrix);
                    drawInfo.offsetList.Add(baseScale + i * stepScale);
                }
            }
        }

        void LateUpdate()
        {
            if (transform.hasChanged || hasSkinned)
            {
                UpdateDrawInfoList();
            }

            DrawInstancedObjects(_FurOffset, drawInfoList, furMaterials);
        }

        public static void DrawInstancedObjects(string furOffsetName, List<DrawInfo> drawInfoList, Material[] furMaterials)
        {
            if (furMaterials == null || furMaterials.Length==0 || !furMaterials[0])
                return;

            for (int i = 0; i < drawInfoList.Count; i++)
            {
                var drawInfo = drawInfoList[i];

                if (!drawInfo.IsValid())
                    continue;

                for (int j = 0; j<drawInfo.mesh.subMeshCount; j++)
                {
                    //if (j >= drawInfo.materials.Length)
                    //    break;

                    if (drawInfo.mesh)
                    {
                        for (int k = 0; k < furMaterials.Length; k++)
                            DrawInstanced(furOffsetName, drawInfo.mesh, j, furMaterials[k], drawInfo.transformList, drawInfo.offsetList);
                    }
                }
            }
        }

        public static void DrawInstanced(string furOffsetName,Mesh mesh, int subMeshId, Material mat, List<Matrix4x4> transformList, List<float> offsets)
        {
            if (!mat.enableInstancing)
            {
                //renderParams.layer = gameObject.layer;
                //renderParams.material = mat;
                //renderParams.renderingLayerMask = GraphicsSettings.defaultRenderingLayerMask;
                //Graphics.RenderMesh(renderParams, mesh, subMeshId, transform.localToWorldMatrix);
                return;
            }

            block.SetFloatArray(furOffsetName, offsets);
            Graphics.DrawMeshInstanced(mesh, subMeshId, mat, transformList, block);
        }
    }
}