//© Dicewrench Designs LLC 2024

//All Rights Reserved
//Last Owned by: Allen White (allen@dicewrenchdesigns.com)

using UnityEngine;
using UnityEditor;
using SpaciousPlaces;

public class PrefabInstantiatorWindow : EditorWindow
{
    private SerializedObject _instance;

    public GameObject targetObject;
    public GameObject[] prefabsToInstantiate;
    public System.Type componentType;
    public string componentName = "YourComponentName";

    [MenuItem("DWD/Prefab Instantiator")]
    public static void ShowWindow()
    {
        GetWindow<PrefabInstantiatorWindow>("Prefab Instantiator");
    }

    private void OnGUI()
    {
        GUILayout.Label("Prefab Instantiator", EditorStyles.boldLabel);

        if (_instance == null)
            _instance = new SerializedObject(this);

        _instance.Update();

        SerializedProperty targetObj = _instance.FindProperty(nameof(targetObject));
        SerializedProperty component = _instance.FindProperty(nameof(componentName));
        SerializedProperty array = _instance.FindProperty(nameof(prefabsToInstantiate));

        EditorGUI.BeginChangeCheck();
        EditorGUILayout.PropertyField(targetObj, true);
        EditorGUILayout.PropertyField(component, true);
        if (EditorGUI.EndChangeCheck())
        {
            componentType = FindComponentType(component.stringValue);
        }

        if (componentType != null)
            GUILayout.Label($"Found Component: {componentType.Name}", EditorStyles.label);
        else
            GUILayout.Label("Component not found.", EditorStyles.label);

        EditorGUILayout.PropertyField(array, true);

        _instance.ApplyModifiedProperties();

        if (GUILayout.Button("Instantiate Prefabs"))
        {
            if(componentType == null)
                componentType = FindComponentType(component.stringValue);
            InstantiatePrefabs();
        }
    }

    private System.Type FindComponentType(string componentName)
    {
        var assemblies = System.AppDomain.CurrentDomain.GetAssemblies();
        foreach (var assembly in assemblies)
        {
            var types = assembly.GetTypes();
            foreach (var type in types)
            {
                if (type.Name == componentName)
                {
                    return type;
                }
            }
        }
        return null;
    }

    private void InstantiatePrefabs()
    {
        if (componentType == null || 
            targetObject == null || 
            prefabsToInstantiate == null || 
            prefabsToInstantiate.Length == 0)
        {
            Debug.LogWarning("Component type or prefabs not set.");
            return;
        }

        RecursivelyFindAndInstantiate(targetObject.transform);
    }

    private void RecursivelyFindAndInstantiate(Transform parentTransform)
    {
        if (parentTransform.GetComponent(componentType) != null)
        {
            foreach (var prefab in prefabsToInstantiate)
            {
                if (prefab != null)
                {
                    var instantiatedObject = PrefabUtility.InstantiatePrefab(prefab, parentTransform) as GameObject;
                    PostInstantiate(instantiatedObject);
                }
            }
        }

        foreach (Transform child in parentTransform)
        {
            RecursivelyFindAndInstantiate(child);
        }
    }

    private void PostInstantiate(GameObject instantiatedObject)
    {
        // Decorate this function with additional code if needed

        Transform temp = instantiatedObject.transform;
        temp.localPosition = Vector3.zero;
        temp.localRotation = Quaternion.identity;
                
        //TriggerParticlePlayer Hookup
        TriggerParticlePlayer[] tpp = instantiatedObject.GetComponentsInChildren<TriggerParticlePlayer>();
        if (tpp.Length > 0)
        {
            Transform parent = instantiatedObject.transform.parent;
            InstrumentCollision coll = parent.GetComponent<InstrumentCollision>();
            if (coll != null)
            {
                foreach (var t in tpp)
                {
                    t.CollisionSource = coll;
                }
            }
        }

        //TriggerParticleEmitter Hookup
        TriggerParticleEmitter[] tpe = instantiatedObject.GetComponentsInChildren<TriggerParticleEmitter>();
        if (tpe.Length > 0)
        {
            Transform parent = instantiatedObject.transform.parent;
            InstrumentCollision coll = parent.GetComponent<InstrumentCollision>();
            if (coll != null)
            {
                foreach (var t in tpe)
                {
                    t.CollisionSource = coll;
                }
            }
        }
    }
}