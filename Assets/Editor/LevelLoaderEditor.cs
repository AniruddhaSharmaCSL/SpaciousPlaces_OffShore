using UnityEngine;
using UnityEditor;
using System.IO;
using System.Linq;
using System.Collections.Generic;

namespace SpaciousPlaces
{
    [CustomEditor(typeof(LevelLoader))]
    public class LevelLoaderEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();
            LevelLoader levelLoader = (LevelLoader)target;

            EditorGUILayout.Space();

            using (new EditorGUI.DisabledScope(!Application.isPlaying))
            {
                if (GUILayout.Button("Save Current Level Instrument Positions"))
                {
                    SaveInstrumentPositions(levelLoader);
                }
            }

            if (!Application.isPlaying)
            {
                EditorGUILayout.HelpBox("Enter Play Mode to save instrument positions", MessageType.Info);
            }
        }

        private void SaveInstrumentPositions(LevelLoader levelLoader)
        {
            if (!Application.isPlaying)
            {
                Debug.LogWarning("Can only save positions in Play Mode");
                return;
            }

            SerializedObject serializedObject = new SerializedObject(levelLoader);
            SerializedProperty currentLevelProp = serializedObject.FindProperty("level");

            SPLevel currentLevel = currentLevelProp?.objectReferenceValue as SPLevel;
            if (currentLevel == null)
            {
                EditorUtility.DisplayDialog("Error", "No level currently loaded", "OK");
                return;
            }

            var instrumentData = new List<InstrumentData>();
            SerializedProperty instrumentInfosProp = serializedObject.FindProperty("instrumentInfos");

            for (int i = 0; i < instrumentInfosProp.arraySize; i++)
            {
                SerializedProperty infoProp = instrumentInfosProp.GetArrayElementAtIndex(i);
                SerializedProperty instrumentProp = infoProp.FindPropertyRelative("instrument");
                SerializedProperty objProp = infoProp.FindPropertyRelative("instrumentObject");

                GameObject instrumentObj = objProp.objectReferenceValue as GameObject;
                if (instrumentObj != null)
                {
                    var rb = instrumentObj.GetComponent<Rigidbody>();
                    Vector3 localPos;
                    Vector3 localRot;

                    if (rb != null)
                    {
                        // Convert rigidbody world position/rotation to local
                        if (instrumentObj.transform.parent != null)
                        {
                            localPos = instrumentObj.transform.parent.InverseTransformPoint(rb.position);
                            localRot = (Quaternion.Inverse(instrumentObj.transform.parent.rotation) * rb.rotation).eulerAngles;
                        }
                        else
                        {
                            localPos = rb.position;
                            localRot = rb.rotation.eulerAngles;
                        }
                    }
                    else
                    {
                        localPos = instrumentObj.transform.localPosition;
                        localRot = instrumentObj.transform.localRotation.eulerAngles;
                    }

                    Debug.Log($"Saving {instrumentObj.name} - LocalPos: {localPos}, LocalRot: {localRot}");
                    if (rb != null)
                    {
                        Debug.Log($"RB position: {rb.position}, rotation: {rb.rotation.eulerAngles}");
                    }

                    instrumentData.Add(new InstrumentData
                    {
                        instrument = (Instrument)instrumentProp.intValue,
                        localPosition = localPos,
                        localRotation = localRot
                    });
                }
            }

            string json = JsonUtility.ToJson(new InstrumentDataWrapper { instruments = instrumentData }, true);

            string directory = Path.Combine(Application.dataPath, "Level Data", "InstrumentPositions");
            if (!Directory.Exists(directory))
            {
                Directory.CreateDirectory(directory);
            }

            string path = Path.Combine(directory, $"{currentLevel.name}.json");
            File.WriteAllText(path, json);

            Debug.Log($"Saved instrument positions to: {path}");

            AssetDatabase.Refresh();
        }

        [System.Serializable]
        private class InstrumentData
        {
            public Instrument instrument;
            public Vector3 localPosition;
            public Vector3 localRotation;
        }

        [System.Serializable]
        private class InstrumentDataWrapper
        {
            public List<InstrumentData> instruments;
        }
    }
}