using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class CustomBlendModeCMI : ShaderGUI
{
   protected GUIStyle boxStyle;

   protected void TryStyles()
   {
      if (boxStyle == null)
      {
         boxStyle = new GUIStyle(GUI.skin.box);
      }
   }

   protected void CacheIfNull(MaterialProperty prop, string name, MaterialProperty[] properties)
   {
      if (prop == null)
         prop = ShaderGUI.FindProperty(name, properties);
   }

   protected void Cache(MaterialProperty prop, string name, MaterialProperty[] properties)
   {
      prop = ShaderGUI.FindProperty(name, properties);
   }

   private void CompareAndSet(Material mat, float src, float dst, float currSrc, float currDst)
   {
      if (currSrc != src)
         mat.SetFloat("_SrcBlend", src);
      if (currDst != dst)
         mat.SetFloat("_DstBlend", dst);
   }

   protected bool SetBlend(Material mat, string test)
   {
      float currSrc = mat.GetFloat("_SrcBlend");
      float currDst = mat.GetFloat("_DstBlend");

      switch (test)
      {
         case "_BLEND_ALPHA":
            CompareAndSet(mat, 5.0f, 10.0f, currSrc, currDst);
            return true;
         case "_BLEND_PREMULALPHA":
            CompareAndSet(mat, 1.0f, 10.0f, currSrc, currDst);
            return true;
         case "_BLEND_ADD":
            CompareAndSet(mat, 1.0f, 1.0f, currSrc, currDst);
            return true;
         case "_BLEND_SOFTADD":
            CompareAndSet(mat, 4.0f, 1.0f, currSrc, currDst);
            return true;
         case "_BLEND_MUL":
            CompareAndSet(mat, 2.0f, 0.0f, currSrc, currDst);
            return true;
         case "_BLEND_DOUBLEMUL":
            CompareAndSet(mat, 2.0f, 3.0f, currSrc, currDst);
            return true;
         case "_BLEND_SOLID":
            CompareAndSet(mat, 1.0f, 2.0f, currSrc, currDst);
            return true;
         default:
            return false;
      }
   }

   override public void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
   {
      TryStyles();

      Material mat = materialEditor.target as Material;

      EditorGUI.BeginChangeCheck();

      using (new EditorGUILayout.VerticalScope(boxStyle))
      {
         materialEditor.ShaderProperty(ShaderGUI.FindProperty("_Blend", properties), "Blend Mode");
      }

      using (new EditorGUILayout.VerticalScope())
      {
         DrawCustomGUI(materialEditor, properties);
      }

      EditorGUILayout.Space();

      //materialEditor.ShaderProperty(ShaderGUI.FindProperty("_UseUIAlphaClip", properties), "Use Alpha Clip");
      materialEditor.RenderQueueField();

      string[] keywords = mat.shaderKeywords;

      int count = keywords.Length;
      for (int a = 0; a < count; a++)
      {
         SetBlend(mat, keywords[a]);
      }

      if (EditorGUI.EndChangeCheck())
      {
         EditorUtility.SetDirty(mat);
      }
   }

   public virtual void DrawCustomGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
   {
      // render the shader properties using the default GUI
      base.OnGUI(materialEditor, properties);
   }
}
