using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEditor;

namespace SpaciousPlaces.Editor
{
    [CustomPropertyDrawer(typeof(RequireShaderAttribute))]
    public class RequireShaderDrawer : PropertyDrawer
    {
        private const float ErrorHeight = 30f;

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            float propertyHeight = EditorGUI.GetPropertyHeight(property, label, true);

            if (property.objectReferenceValue is Material material)
            {
                RequireShaderAttribute requireShader = attribute as RequireShaderAttribute;
                if (material.shader.name != requireShader.ShaderName)
                {
                    return propertyHeight + ErrorHeight;
                }
            }

            return propertyHeight;
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            RequireShaderAttribute requireShader = attribute as RequireShaderAttribute;

            // Draw the default material field
            EditorGUI.PropertyField(position, property, label, true);

            // Get the current material
            if (property.objectReferenceValue is Material material)
            {
                // Check if the shader matches the requirement
                if (material.shader.name != requireShader.ShaderName)
                {
                    // Calculate rect for error message
                    Rect errorRect = new Rect(position.x,
                        position.y + EditorGUI.GetPropertyHeight(property, label, true),
                        position.width,
                        ErrorHeight);

                    // Draw error message box
                    EditorGUI.HelpBox(errorRect,
                        $"This material must use the '{requireShader.ShaderName}' shader",
                        MessageType.Error);
                }
            }
        }
    }
}