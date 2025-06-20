using UnityEngine;
using UnityEditor;
using System.Reflection;
using System.Linq;

namespace SpaciousPlaces.Editor
{
    [CustomPropertyDrawer(typeof(ShowIfAttribute))]
    public class ShowIfDrawer : PropertyDrawer
    {
        private bool ShouldShow(SerializedProperty property)
        {
            ShowIfAttribute showIf = attribute as ShowIfAttribute;
            object parent = property.serializedObject.targetObject;

            bool[] results = showIf.ConditionMethods.Select(methodName =>
            {
                MethodInfo methodInfo = parent.GetType().GetMethod(methodName,
                    BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public);

                if (methodInfo == null)
                {
                    Debug.LogError($"ShowIf: Method {methodName} not found in {parent.GetType()}");
                    return true;
                }

                return (bool)methodInfo.Invoke(parent, null);
            }).ToArray();

            return showIf.LogicOp == LogicOperator.Or ?
                results.Any(x => x) : results.All(x => x);
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            if (!ShouldShow(property))
                return 0f;

            return EditorGUI.GetPropertyHeight(property, label, true);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            if (!ShouldShow(property))
                return;

            EditorGUI.PropertyField(position, property, label, true);
        }
    }
}