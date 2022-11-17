namespace PowerUtilities {
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

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

    [Serializable]
    public class DrawInfo
    {
        public int subMeshId;
        [Min(0)]public int drawCount = 11;

        [HideInInspector]public List<Matrix4x4> transformList = new List<Matrix4x4>();
        [HideInInspector]public List<float> offsets = new List<float>();

        public void Clear()
        {
            transformList.Clear();
            offsets.Clear();
        }

        public bool IsValid() => transformList.Count > 0 && offsets.Count == transformList.Count;
    }
    [ExecuteInEditMode]
    public class DrawFurObjectInstanced : MonoBehaviour
    {
        readonly int _FurOffset = Shader.PropertyToID(nameof(_FurOffset));

        [Header("Offset Prop")]
        [Min(0)]
        [Tooltip("vertex base scale factor")]
        public float baseScale = 0.07f;

        [Tooltip("vertex scale factor every time")]
        public float stepScale = 0.03f;

        [Min(0)] public int drawCount = 11;

        [Header("Sub Meshes")]
        DrawInfo[] drawinfos;

        Mesh mesh;
        Renderer render;
        Material[] mats;
        static MaterialPropertyBlock block;
        RenderParams renderParams;
        // Start is called before the first frame update
        public void OnEnable()
        {
            if (block == null)
                block = new MaterialPropertyBlock();

            if (!TryGetComponent<MeshFilter>(out var mf))
                return;

            if (!TryGetComponent(out render))
                return;

            mesh = mf.sharedMesh;
            mats = render.sharedMaterials;
            //render.enabled = false;

            SetupDrawinfos();

            UpdateTransformList();
        }

        private void SetupDrawinfos()
        {
            drawinfos = new DrawInfo[mesh.subMeshCount];
            for (int i = 0; i < drawinfos.Length; i++)
            {
                drawinfos[i] = new DrawInfo { subMeshId = i, drawCount = drawCount };
            }

        }

        private void UpdateTransformList()
        {
            foreach (var item in drawinfos)
            {
                item.Clear();
                for (int i = 0; i < item.drawCount; i++)
                {
                    item.transformList.Add(transform.localToWorldMatrix);
                    item.offsets.Add(baseScale + i * stepScale);
                }
            }

        }

        bool IsRendererValid() => render && 
            render.isVisible &&
            render.gameObject.activeInHierarchy && 
            mesh;

        // Update is called once per frame
        void Update()
        {
            if (!IsRendererValid())
                return;

            if (transform.hasChanged)
            {
                UpdateTransformList();
            }

            for (int i = 0; i < drawinfos.Length; i++)
            {
                if (i > mats.Length || i >= drawinfos.Length)
                    break;

                var info = drawinfos[i];
                DrawInstanced(info, i, mats[i]);
            }

        }

        void DrawInstanced(DrawInfo info,int subMeshId,Material mat)
        {
            if (!info.IsValid())
                return;

            if (!mat.enableInstancing)
            {
                //renderParams.layer = gameObject.layer;
                //renderParams.material = mat;
                //renderParams.renderingLayerMask = GraphicsSettings.defaultRenderingLayerMask;
                //Graphics.RenderMesh(renderParams, mesh, subMeshId, transform.localToWorldMatrix);
                return;
            }

            block.SetFloatArray(_FurOffset, info.offsets);
            Graphics.DrawMeshInstanced(mesh, subMeshId, mat, info.transformList, block);
        }
    }
}