//© Dicewrench Designs LLC 2022-2023
//All Rights Reserved
//Last Owned by: Allen White (allen@dicewrenchdesigns.com)

using UnityEngine;
using UnityEditor;

namespace DWD.Editor
{
   public abstract class HideMaterialPropertyDrawerBase : MaterialPropertyDrawer
   {
      protected string[] _keywords = new string[0];

      protected abstract bool EvaluateShouldShow(MaterialEditor editor);

      protected bool MaterialHasKeyword(MaterialEditor editor)
      {
         Material mat = editor.target as Material;
         if (mat != null)
         {
            string[] keywords = mat.shaderKeywords;
            bool shouldHide = false;
            int count = keywords.Length;
            int checkCount = _keywords.Length;
            for (int a = 0; a < count; a++)
            {
               string key = keywords[a];
               for (int b = 0; b < checkCount; b++)
               {
                  if (key == _keywords[b])
                  {
                     shouldHide = true;
                     break;
                  }
               }
            }
            return shouldHide;
         }
         else
            return false;
      }

      public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
      {
         if (EvaluateShouldShow(editor))
            editor.DefaultShaderProperty(position, prop, label);
      }

      public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
      {
         if (EvaluateShouldShow(editor))
         {
            if (prop.type == MaterialProperty.PropType.Texture)
               return 4.0f * EditorGUIUtility.singleLineHeight;
            else
               return base.GetPropertyHeight(prop, label, editor);
         }
         else
            return 0.0f;
      }

      protected void SetKeyword(MaterialProperty prop, bool on, string defaultKeywordSuffix)
      {
         string text = prop.name.ToUpperInvariant() + defaultKeywordSuffix;
         Object[] targets = prop.targets;
         for (int i = 0; i < targets.Length; i++)
         {
            Material material = (Material)targets[i];
            if (on)
            {
               material.EnableKeyword(text);
            }
            else
            {
               material.DisableKeyword(text);
            }
         }
      }

      protected void ApplyKeywordFromArray(MaterialProperty prop, string[] keywords, int index)
      {
         for (int i = 0; i < keywords.Length; i++)
         {
            string text = prop.name + "_" + keywords[i];
            text = text.Replace(' ', '_').ToUpperInvariant();
            Object[] targets = prop.targets;
            for (int j = 0; j < targets.Length; j++)
            {
               Material material = (Material)targets[j];
               if (index == i)
               {
                  material.EnableKeyword(text);
               }
               else
               {
                  material.DisableKeyword(text);
               }
            }
         }
      }
   }
}