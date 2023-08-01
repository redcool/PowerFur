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

    [ExecuteInEditMode]
    public class DrawFurObjectInstanced : MonoBehaviour
    {
        [Header("Shader Variables")]
        public string _FurOffset = nameof(_FurOffset);

        [Header("Offset Prop")]
        [Min(0)]
        [Tooltip("vertex base scale factor")]
        public float baseScale = 0.07f;

        [Tooltip("vertex scale factor every time")]
        public float stepScale = 0.03f;

        [Min(0)] public int drawCount = 11;

        [Header("Sub Meshes")]
        List<Matrix4x4> transformList = new List<Matrix4x4>();
        List<float> offsets = new List<float>();

        Mesh mesh;
        Renderer render;
        Material[] mats;
        static MaterialPropertyBlock block;

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


            UpdateTransformList();
        }

        public void Clear()
        {
            transformList.Clear();
            offsets.Clear();
        }


        private void UpdateTransformList()
        {
            Clear();
            for (int i = 0; i < drawCount; i++)
            {
                transformList.Add(transform.localToWorldMatrix);
                offsets.Add(baseScale + i * stepScale);
            }

        }

        bool IsRendererValid() => render && 
            render.gameObject.activeInHierarchy && 
            mesh;

        void LateUpdate()
        {
            if (!IsRendererValid())
                return;

            if (transform.hasChanged)
            {
                UpdateTransformList();
            }

            for (int i = 0; i < mesh.subMeshCount; i++)
            {
                if (i > mats.Length)
                    break;

                DrawInstanced(mesh,i, mats[i]);
            }

        }

        void DrawInstanced(Mesh mesh,int subMeshId, Material mat)
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