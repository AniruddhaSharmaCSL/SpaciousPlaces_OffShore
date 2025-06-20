//� Dicewrench Designs LLC 2025

//All Rights Reserved
//Last Owned by: Allen White (allen@dicewrenchdesigns.com)

using UnityEngine;
using UnityEditor;


namespace SpaciousPlaces
{
    public class InstantiateAndAssignEditorWindow : EditorWindow
    {
        public GameObject[] prefabsToInstantiate;
        public bool tryAlignToCollider = true;

        [MenuItem("DWD/Instantiate and Assign Instrument VFX")]
        public static void ShowWindow()
        {
            GetWindow<InstantiateAndAssignEditorWindow>("Instantiate and Assign");
        }

        private void OnGUI()
        {
            GUILayout.Label("Instantiate and Assign Components", EditorStyles.boldLabel);

            SerializedObject windowObj = new SerializedObject(this);
            windowObj.Update();
            SerializedProperty align = windowObj.FindProperty(nameof(tryAlignToCollider));
            EditorGUILayout.PropertyField(align, true);
            SerializedProperty fabs = windowObj.FindProperty(nameof(prefabsToInstantiate));
            EditorGUILayout.PropertyField(fabs, true);
            windowObj.ApplyModifiedProperties();

            if (GUILayout.Button("Process Selected GameObject"))
            {
                ProcessSelectedGameObject();
            }
        }

        private void ProcessSelectedGameObject()
        {
            if (Selection.activeGameObject == null)
            {
                Debug.LogError("No GameObject selected.");
                return;
            }

            if (prefabsToInstantiate == null || prefabsToInstantiate.Length == 0)
            {
                Debug.LogError("No prefabs selected to instantiate.");
                return;
            }

            GameObject selectedGameObject = Selection.activeGameObject;
            InstrumentCollision[] instrumentCollisions = selectedGameObject.GetComponentsInChildren<InstrumentCollision>();

            if (instrumentCollisions.Length == 0)
            {
                Debug.LogWarning("No InstrumentCollision components found.");
                return;
            }

            foreach (InstrumentCollision collision in instrumentCollisions)
            {
                foreach (GameObject prefab in prefabsToInstantiate)
                {
                    if (prefab != null)
                    {
                        GameObject instantiatedObject = PrefabUtility.InstantiatePrefab(prefab, collision.transform) as GameObject;
                        if (tryAlignToCollider)
                        {
                            Collider col = collision.gameObject.GetComponent<Collider>();
                            if (col != null)
                            {
                                instantiatedObject.transform.localPosition = col.bounds.center;
                            }
                            else
                            {
                                col = collision.gameObject.GetComponentInChildren<Collider>();
                                if (col != null)
                                    instantiatedObject.transform.position = col.bounds.center;                                   
                                else
                                    instantiatedObject.transform.localPosition = Vector3.zero;
                                instantiatedObject.transform.localRotation = Quaternion.identity;
                            }
                        }
                        else
                        {
                            instantiatedObject.transform.localPosition = Vector3.zero;
                            //instantiatedObject.transform.localRotation = Quaternion.identity;
                        }
                        TriggerParticleEmitter particleEmitter = instantiatedObject.GetComponent<TriggerParticleEmitter>();
                        if (particleEmitter != null)
                        {
                            SerializedObject soEmitter = new SerializedObject(particleEmitter);
                            SerializedProperty propEmitter = soEmitter.FindProperty("_collisionSource");
                            if (propEmitter != null)
                            {
                                propEmitter.objectReferenceValue = collision;
                                soEmitter.ApplyModifiedProperties();
                            }
                        }

                        TriggerParticlePlayer particlePlayer = instantiatedObject.GetComponent<TriggerParticlePlayer>();
                        if (particlePlayer != null)
                        {
                            SerializedObject soPlayer = new SerializedObject(particlePlayer);
                            SerializedProperty propPlayer = soPlayer.FindProperty("_collisionSource");
                            if (propPlayer != null)
                            {
                                propPlayer.objectReferenceValue = collision;
                                soPlayer.ApplyModifiedProperties();
                            }
                        }
                    }
                }
            }

            AssetDatabase.Refresh();
        }
    }
}