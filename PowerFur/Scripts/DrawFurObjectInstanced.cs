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
            public Material[] materials;
            public Mesh mesh;
            public List<Matrix4x4> transformList = new List<Matrix4x4>();
            public List<float> offsetList = new List<float>();

            public void Clear()
            {
                transformList.Clear(); offsetList.Clear();
            }
            public bool IsValid() => renderer;
        }

        [Header("Shader Variables")]
        public string _FurOffset = nameof(_FurOffset);

        [Header("Offset Prop")]
        [Min(0)]
        [Tooltip("vertex base scale factor")]
        public float baseScale = 0.07f;

        [Tooltip("vertex scale factor every time")]
        public float stepScale = 0.03f;

        [Min(0)] public int drawCount = 11;

        static MaterialPropertyBlock block;

        [Header("Debug Info")]
        public List<DrawInfo> drawInfoList = new List<DrawInfo>();

        // Start is called before the first frame update
        public void OnEnable()
        {
            if (block == null)
                block = new MaterialPropertyBlock();

            SetupDrawInfos();
        }

        public void OnDisable()
        {
            drawInfoList.Clear();
        }

        public void SetupDrawInfos()
        {
            drawInfoList.Clear();
            var renders = GetComponentsInChildren<Renderer>();
            drawInfoList = renders.Select(r => new DrawInfo
            {
                renderer = r,
                materials = r.sharedMaterials,
                mesh = r.GetComponent<MeshFilter>()?.sharedMesh,
            }
            ).ToList();
        }


        private void UpdateTransformList()
        {
            drawInfoList = drawInfoList.Where(info => info.IsValid()).ToList();

            foreach (var drawInfo in drawInfoList)
            {
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
            if (transform.hasChanged)
            {
                UpdateTransformList();
            }

            DrawInstancedObjects();
        }

        public void DrawInstancedObjects()
        {
            for (int i = 0; i < drawInfoList.Count; i++)
            {
                var drawInfo = drawInfoList[i];
                for (int j = 0; j<drawInfo.mesh.subMeshCount; j++)
                {
                    if (j >= drawInfo.materials.Length)
                        break;

                    if (drawInfo.mesh)
                        DrawInstanced(drawInfo.mesh, j, drawInfo.materials[j], drawInfo.transformList, drawInfo.offsetList);
                }
            }
        }

        void DrawInstanced(Mesh mesh, int subMeshId, Material mat, List<Matrix4x4> transformList, List<float> offsets)
        {
            if (!mat.enableInstancing)
            {
                //renderParams.layer = gameObject.layer;
                //renderParams.material = mat;
                //renderParams.renderingLayerMask = GraphicsSettings.defaultRenderingLayerMask;
                //Graphics.RenderMesh(renderParams, mesh, subMeshId, transform.localToWorldMatrix);
                return;
            }

            block.SetFloatArray(_FurOffset, offsets);
            Graphics.DrawMeshInstanced(mesh, subMeshId, mat, transformList, block);
        }
    }
}