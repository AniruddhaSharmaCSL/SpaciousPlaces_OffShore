using UnityEngine;
using UnityEditor;

public class SimpleParticleCMI : CustomBlendModeCMI
{
   private const float _MIX_RANGE = 4.0f;

   private float _windowWidth = 250.0f;
   private float _halfWidth;

   public bool showKeywords = false;
   public bool showDebug = false;

   public bool showSampleOne = false;
   public bool showSampleTwo = false;
   public bool showSampleThree = false;

   public bool showRamp = false;
   public bool showColor = false;
   public bool showAlpha = false;
   public bool showSprite = false;

   override public void DrawCustomGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
   {
      _windowWidth = EditorGUIUtility.currentViewWidth - 80.0f;
      _halfWidth = _windowWidth * 0.5f;

      MaterialProperty sampleCount = ShaderGUI.FindProperty("_SampleCount", properties);
      MaterialProperty sampleOneWorldPos = ShaderGUI.FindProperty("_SampleOneWorldPos", properties);
      MaterialProperty sampleTwoWorldPos = ShaderGUI.FindProperty("_SampleTwoWorldPos", properties);

      Material m = materialEditor.target as Material;

      bool sampleTwoOn = m.IsKeywordEnabled("_SAMPLECOUNT_TWO") || m.IsKeywordEnabled("_SAMPLECOUNT_TWOTEX");

      EditorGUI.BeginChangeCheck();

      using (new EditorGUILayout.VerticalScope(boxStyle))
      {
         materialEditor.ShaderProperty(ShaderGUI.FindProperty("_ZWrite", properties), new GUIContent("Z Write"));
      }

      using (new EditorGUILayout.VerticalScope(boxStyle))
      {
         materialEditor.ShaderProperty(ShaderGUI.FindProperty("_ZTest", properties), new GUIContent("Z Test"));
      }

      if(m.HasProperty("_Cull"))
      {
         using (new EditorGUILayout.VerticalScope(boxStyle))
         {
            materialEditor.ShaderProperty(ShaderGUI.FindProperty("_Cull", properties), new GUIContent("Cull Mode"));
         }
      }

      bool usingWorlPos = sampleOneWorldPos.floatValue == 1.0f || (sampleTwoWorldPos.floatValue == 1.0f && sampleCount.floatValue >= 1.0f);

      EditorGUILayout.HelpBox("The Simple Particle Shader combines samples of a packed Texture to create a gradient ramp that is used to lerp between Colors.", MessageType.Info,true);

      using (new EditorGUILayout.VerticalScope(boxStyle, GUILayout.ExpandWidth(true)))
      {
         materialEditor.ShaderProperty(ShaderGUI.FindProperty("_MainTex", properties), "");

         EditorGUILayout.Space();
         EditorGUILayout.HelpBox("Sample Count dramatically impacts shader performance!  Use the smallest number of samples possible to achieve your effect!", MessageType.Warning,true);
         materialEditor.ShaderProperty(ShaderGUI.FindProperty("_SampleCount", properties), new GUIContent("Sample Count", "The number of times to sample the texture."));

         if (usingWorlPos)
            materialEditor.ShaderProperty(ShaderGUI.FindProperty("_Phase", properties), new GUIContent("World Pos Scale", "Modifies UVs by World Position times this value."));

         EditorGUILayout.Space();

         DrawSampleSet("One", materialEditor, properties, ref showSampleOne);

         if (sampleCount.floatValue >= 1.0f)
         {
            string sampler = m.IsKeywordEnabled("_SAMPLECOUNT_TWOTEX") ? "_SampleTwoTex" : "";
            DrawSampleSet("Two", materialEditor, properties, ref showSampleTwo, sampler);
         }
      }

      EditorGUILayout.Space();

      //Gradient Mods
      using (new EditorGUILayout.VerticalScope(boxStyle))
      {
         showRamp = EditorGUILayout.Foldout(showRamp, "Gradient Ramp");

         EditorGUILayout.HelpBox("Gradient Ramp Values are also controlled by Vertex Color so they can be animated in Particle Systems.  These settings are highlighted by their corresponding Vertex Channel Color.", MessageType.Info, true);

         if (showRamp)
         {
            EditorGUI.indentLevel += 1;

            MaterialProperty colorCount = ShaderGUI.FindProperty("_ColorCount", properties);
            MaterialProperty useVertex = ShaderGUI.FindProperty("_UseVertexColor", properties);
            Vector4 useVertexVector = useVertex.vectorValue;

            Color old = GUI.backgroundColor;
            GUI.backgroundColor = Color.red;

            bool rampOff = colorCount.floatValue == 0.0f || colorCount.floatValue == 4.0f ? true : false;

            if(rampOff)
               EditorGUILayout.HelpBox("Color Count is set such that Gradient Ramp will be used to modify Alpha (derived from averaged R,G,B texture channels).", MessageType.Info, true);

            using (new EditorGUILayout.HorizontalScope(boxStyle))
            {
               useVertexVector.x = DrawUseVertex(useVertexVector.x);
               EditorGUIUtility.labelWidth = 115.0f;
               materialEditor.ShaderProperty(ShaderGUI.FindProperty("_RampUV", properties), new GUIContent("Ramp Offset", "Add this value to the ramp to select color. Also driven by Vertex Color R"));
            }
            GUI.backgroundColor = Color.green;
            using (new EditorGUILayout.HorizontalScope(boxStyle))
            {
               useVertexVector.y = DrawUseVertex(useVertexVector.y);
               materialEditor.ShaderProperty(ShaderGUI.FindProperty("_CutoffWidth", properties), new GUIContent("Outer Cutoff", "Erode the outside of the ramp. Also driven by Vertex G"));
            }
            GUI.backgroundColor = Color.blue;
            using (new EditorGUILayout.HorizontalScope(boxStyle))
            {
               useVertexVector.z = DrawUseVertex(useVertexVector.z);
               materialEditor.ShaderProperty(ShaderGUI.FindProperty("_InnerWidth", properties), new GUIContent("Inner Cutoff", "Dissolve the middle of the ramp.  Also driven by Vertex B"));
            }
            EditorGUILayout.Space();

            GUI.backgroundColor = old;
            using (new EditorGUILayout.VerticalScope(boxStyle))
               materialEditor.ShaderProperty(ShaderGUI.FindProperty("_RampPow", properties), new GUIContent("Ramp Power", "Raise the ramp to this exponent, Also driven by Vertex Color B"));

            EditorGUI.indentLevel -= 1;

            useVertex.vectorValue = useVertexVector;
         }
      }

      EditorGUILayout.Space();

      //Colors
      using (new EditorGUILayout.VerticalScope(boxStyle))
      {
         showColor = EditorGUILayout.Foldout(showColor, "Color Values");

         MaterialProperty colorCount = ShaderGUI.FindProperty("_ColorCount", properties);

         if (colorCount.floatValue > 0.0f && colorCount.floatValue < 4.0f)
            EditorGUILayout.HelpBox("Final Colors are determined by lerping between these values and the Gradient Ramp.", MessageType.Info, true);
         else if (colorCount.floatValue == 4.0f)
            EditorGUILayout.HelpBox("Final Colors are determined by Vertex Color.", MessageType.Info, true);
         else
            EditorGUILayout.HelpBox("Final Colors are determined by input texture only.", MessageType.Info, true);

         if (showColor)
         {
            EditorGUI.indentLevel += 1;

            materialEditor.ShaderProperty(colorCount, new GUIContent("Color Count", "How many Colors to lerp between?"));

            EditorGUILayout.Space();

            float width = colorCount.floatValue == 0.0f ? 0.5f : 0.3f;
            EditorGUIUtility.labelWidth = 100.0f;
            if (colorCount.floatValue > 0.0f)
            {
               using (new EditorGUILayout.HorizontalScope(boxStyle, GUILayout.ExpandWidth(true)))
               {
                  if (colorCount.floatValue >= 1.0f && colorCount.floatValue != 4.0f)
                  {
                     using (new EditorGUILayout.HorizontalScope(GUILayout.Width(width)))
                        materialEditor.ShaderProperty(ShaderGUI.FindProperty("_ColorZero", properties), new GUIContent("Black Color", "This Color will appear where the Gradient Ramp is BLACK"));
                  }
                  if (colorCount.floatValue == 3.0f)
                  {
                     using (new EditorGUILayout.HorizontalScope(GUILayout.Width(width)))
                        materialEditor.ShaderProperty(ShaderGUI.FindProperty("_ColorMiddle", properties), new GUIContent("Grey Color", "This Color will appear where the Gradient Ramp is GREY"));
                  }
                  if (colorCount.floatValue >= 2.0f && colorCount.floatValue != 4.0f)
                  {
                     using (new EditorGUILayout.HorizontalScope(GUILayout.Width(width)))
                        materialEditor.ShaderProperty(ShaderGUI.FindProperty("_ColorOne", properties), new GUIContent("White Color", "This Color will appear where the Gradient Ramp is WHITE"));
                  }
               }
            }
            EditorGUIUtility.labelWidth = 0.0f;

            EditorGUILayout.Space();

            materialEditor.ShaderProperty(ShaderGUI.FindProperty("_ColorBoost", properties), new GUIContent("Color Contrast", "A fast Contrast approximation"));

            EditorGUI.indentLevel -= 1;
         }
      }

      EditorGUILayout.Space();

      //Alpha
      using (new EditorGUILayout.VerticalScope(boxStyle))
      {
         showAlpha = EditorGUILayout.Foldout(showAlpha, "Alpha Settings");

         EditorGUILayout.HelpBox("The final Alpha value is multiplied by the Vertex Color Alpha so it can be animated in Particle Systems.", MessageType.Info, true);

         if (showAlpha)
         {
            MaterialProperty useVertex = ShaderGUI.FindProperty("_UseVertexColor", properties);
            Vector4 useVertexVector = useVertex.vectorValue;

            EditorGUI.indentLevel += 1;

            useVertexVector.w = DrawUseVertex(useVertexVector.w);

            materialEditor.ShaderProperty(ShaderGUI.FindProperty("_AlphaBoost", properties), new GUIContent("Alpha Mul", "Multiply the Alpha by this value"));
            materialEditor.ShaderProperty(ShaderGUI.FindProperty("_RimAlpha", properties), new GUIContent("Rim Alpha", "Modify Alpha based on Dot of Normal and View Direction"));

            EditorGUILayout.Space();

            materialEditor.ShaderProperty(ShaderGUI.FindProperty("_FloorHeight", properties), new GUIContent("Floor Height", "World Pos Y value that this particle will not appear below"));
            materialEditor.ShaderProperty(ShaderGUI.FindProperty("_FloorContrast", properties), new GUIContent("Floor Contrast", "Contrast of the Floor Height Fade"));

            useVertex.vectorValue = useVertexVector;

            EditorGUI.indentLevel -= 1;
         }
      }

      if (EditorGUI.EndChangeCheck())
      {
         bool sampleTwoEnable = m.IsKeywordEnabled("_SAMPLECOUNT_TWO");
         bool sampleTwoTexEnable = m.IsKeywordEnabled("_SAMPLECOUNT_TWOTEX");
         bool updatedSampleTwo = sampleTwoEnable || sampleTwoTexEnable;

         if (updatedSampleTwo != sampleTwoOn)
         {
            SetSampleKeywords("Two", m, materialEditor, properties, updatedSampleTwo);
         }
         EditorUtility.SetDirty(materialEditor.target as Material);
      }

      EditorGUILayout.Space();

      using (new EditorGUILayout.VerticalScope(boxStyle))
      {
         showDebug = EditorGUILayout.ToggleLeft(new GUIContent("Display Debug Options"), showDebug);

         if(showDebug)
         {
            EditorGUI.indentLevel += 1;
            materialEditor.ShaderProperty(ShaderGUI.FindProperty("_Debug", properties), new GUIContent("Set Debug Shader Output Mode"));
            EditorGUI.indentLevel -= 1;
         }
      }

      EditorGUILayout.Space();

      using (new EditorGUILayout.VerticalScope(boxStyle))
      {
         showKeywords = EditorGUILayout.ToggleLeft(new GUIContent("Display Shader Keywords"), showKeywords);
         //EditorGUILayout.LabelField("Shader Keywords", EditorStyles.miniBoldLabel);

         if (showKeywords)
         {
            EditorGUI.indentLevel += 1;
            int count = m.shaderKeywords.Length;
            for (int a = 0; a < count; a++)
            {
               EditorGUILayout.LabelField(m.shaderKeywords[a], EditorStyles.miniLabel);
            }
            EditorGUI.indentLevel -= 1;
         }
      }

      //check if we are a sprite shader and then draw sprite controls
      if(m.HasProperty("PixelSnap"))
      {
         using(new EditorGUILayout.VerticalScope(boxStyle))
         {
            showSprite = EditorGUILayout.Foldout(showSprite, "Sprite Settings");

            if(showSprite)
            {
               EditorGUI.indentLevel += 1;
               materialEditor.ShaderProperty(ShaderGUI.FindProperty("PixelSnap", properties), new GUIContent("Pixel Snap"));
               MaterialProperty enableAlpha = ShaderGUI.FindProperty("_EnableExternalAlpha", properties);
               materialEditor.ShaderProperty(enableAlpha, new GUIContent("Enable External Alpha"));
               if (enableAlpha.floatValue > 0.0f)
                  materialEditor.ShaderProperty(ShaderGUI.FindProperty("_AlphaTex", properties), new GUIContent("External Alpha"));
               EditorGUI.indentLevel -= 1;
            }
         }
      }
   }

   private float DrawUseVertex(float input)
   {
      EditorGUIUtility.labelWidth = 50.0f;
      bool value = input == 1.0 ? true : false;
      value = EditorGUILayout.Toggle(new GUIContent("VC?", "Use Vertex Color?"), value, GUILayout.ExpandWidth(false));
      EditorGUIUtility.labelWidth = 0.0f;
      return value == true ? 1.0f : 0.0f;
   }

   private void SetSampleKeywords(string idString, Material m, MaterialEditor materialEditor, MaterialProperty[] properties, bool enable)
   {
      if(enable == false)
      {
         idString = idString.ToUpper();
         m.DisableKeyword("_SAMPLE" + idString + "WORLDPOS_ON");
         m.DisableKeyword("_SAMPLE" + idString + "WORLDPOS_OFF");
         m.DisableKeyword("_SAMPLE" + idString + "UV_FIXED");
         m.DisableKeyword("_SAMPLE" + idString + "UV_LINEAR");
         m.DisableKeyword("_SAMPLE" + idString + "UV_SINWAVE");
         m.DisableKeyword("_SAMPLE" + idString + "UV_SPIN");
         m.DisableKeyword("_SAMPLE" + idString + "BLEND_AVERAGE");
         m.DisableKeyword("_SAMPLE" + idString + "BLEND_ADD");
         m.DisableKeyword("_SAMPLE" + idString + "BLEND_SUBTRACT");
         m.DisableKeyword("_SAMPLE" + idString + "BLEND_MUL");
         m.DisableKeyword("_SAMPLE" + idString + "BLEND_DOUBLEMUL");
         m.DisableKeyword("_SAMPLE" + idString + "BLEND_MIN");
         m.DisableKeyword("_SAMPLE" + idString + "BLEND_MAX");
      }
      else
      {
         MaterialProperty world = ShaderGUI.FindProperty("_Sample" + idString + "WorldPos", properties);
         MaterialProperty uv = ShaderGUI.FindProperty("_Sample" + idString + "UV", properties);
         MaterialProperty blend = ShaderGUI.FindProperty("_Sample" + idString + "Blend", properties);

         idString = idString.ToUpper();

         if (world.floatValue == 1.0f)
            m.EnableKeyword("_SAMPLE" + idString + "WORLDPOS_ON");

         m.DisableKeyword("_SAMPLE" + idString + "WORLDPOS_OFF");

         if (uv.floatValue == 0.0f)
            m.EnableKeyword("_SAMPLE" + idString + "UV_FIXED");
         else if (uv.floatValue == 1.0f)
            m.EnableKeyword("_SAMPLE" + idString + "UV_LINEAR");
         else if (uv.floatValue == 2.0f)
            m.EnableKeyword("_SAMPLE" + idString + "UV_SINWAVE");
         else if (uv.floatValue == 3.0f)
            m.EnableKeyword("_SAMPLE" + idString + "UV_SPIN");
         else if (uv.floatValue == 4.0f)
            m.EnableKeyword("_SAMPLE" + idString + "UV_RADIAL");

         if(blend.floatValue == 0.0f)
            m.EnableKeyword("_SAMPLE" + idString + "BLEND_AVERAGE");
         else if (blend.floatValue == 1.0f)
            m.EnableKeyword("_SAMPLE" + idString + "BLEND_ADD");
         else if (blend.floatValue == 2.0f)
            m.EnableKeyword("_SAMPLE" + idString + "BLEND_SUBTRACT");
         else if (blend.floatValue == 3.0f)
            m.EnableKeyword("_SAMPLE" + idString + "BLEND_MUL");
         else if (blend.floatValue == 4.0f)
            m.EnableKeyword("_SAMPLE" + idString + "BLEND_DOUBLEMUL");
         else if (blend.floatValue == 5.0f)
            m.EnableKeyword("_SAMPLE" + idString + "BLEND_MIN");
         else if (blend.floatValue == 6.0f)
            m.EnableKeyword("_SAMPLE" + idString + "BLEND_MAX");
      }
   }

   private void DrawSampleSet(
      string idString, 
      MaterialEditor materialEditor, 
      MaterialProperty[] properties, 
      ref bool foldout, 
      string optionalSample = "")
   {

      string channel = "_Sample" + idString + "Channel";
      string offset = "_Sample" + idString + "ScaleOffset";
      string world = "_Sample" + idString + "WorldPos";
      string uv = "_Sample" + idString + "UV";
      string scroll = "_Sample" + idString + "Scroll";

      using (new EditorGUILayout.VerticalScope(boxStyle))
      {
         string label = "Sample " + idString + " Properties";
         foldout = EditorGUILayout.Foldout(foldout, label);
       
         if(idString == "Two" || idString == "Three")
         {
            EditorGUI.indentLevel += 1;
            materialEditor.ShaderProperty(ShaderGUI.FindProperty("_Sample" + idString + "Blend", properties), new GUIContent("Blend Mode", "How this sample will blend with prior samples."));
            EditorGUI.indentLevel = 1;
         }

         if (foldout)
         {
            if(!string.IsNullOrEmpty(optionalSample))
            {
               materialEditor.ShaderProperty(ShaderGUI.FindProperty(optionalSample, properties), optionalSample);
            }

            DrawChannelMixer(idString, materialEditor, properties);

            MaterialProperty scale = ShaderGUI.FindProperty(offset, properties);
            MaterialProperty uvMode = ShaderGUI.FindProperty(uv, properties);
            MaterialProperty scrollProp = ShaderGUI.FindProperty(scroll, properties);

            using (new EditorGUILayout.VerticalScope(boxStyle))
            {
               EditorGUILayout.LabelField("UV Controls", EditorStyles.miniLabel);
               EditorGUI.indentLevel += 1;

               DrawScaleOffset(scale);

               using (new EditorGUILayout.HorizontalScope(GUILayout.Width(_windowWidth)))
               {
                  EditorGUIUtility.labelWidth = 130.0f;
                  MaterialProperty worldUV = ShaderGUI.FindProperty(world, properties);
                  materialEditor.ShaderProperty(worldUV, new GUIContent("Apply World Pos", "Which Channel of the Texture this Sample will utilize"));
                  if (worldUV.floatValue == 0.0f)
                  {
                     Material m = materialEditor.target as Material;
                     m.DisableKeyword("_SAMPLEONEWORLDPOS_ON");
                  }
                  else
                  {
                     Material m = materialEditor.target as Material;
                     m.EnableKeyword("_SAMPLEONEWORLDPOS_ON");
                  }
                  materialEditor.ShaderProperty(uvMode, new GUIContent("UV Mode", "How do you want this Sample's UVs to behave over time"));
                  EditorGUIUtility.labelWidth = 0.0f;
               }
               DrawUVScrollControls(uvMode, scrollProp);
            }

            EditorGUI.indentLevel -= 1;
         }
      }
   }

   private void DrawScaleOffset(MaterialProperty scaleProp)
   {
      float x = scaleProp.vectorValue.x;
      float y = scaleProp.vectorValue.y;
      float z = scaleProp.vectorValue.z;
      float w = scaleProp.vectorValue.w;

      using (new EditorGUILayout.HorizontalScope())
      {
         EditorGUILayout.LabelField("Scale Offset", GUILayout.Width(_windowWidth * 0.35f));

         using (new EditorGUILayout.VerticalScope(GUILayout.Width(_windowWidth * 0.65f)))
         {
            using (new EditorGUILayout.HorizontalScope())
            {
               EditorGUIUtility.labelWidth = 100.0f;
               x = EditorGUILayout.FloatField(new GUIContent("Tiling   X"), x);
               EditorGUIUtility.labelWidth = 40.0f;
               y = EditorGUILayout.FloatField(new GUIContent("Y"), y);
            }
            using (new EditorGUILayout.HorizontalScope())
            {
               EditorGUIUtility.labelWidth = 100.0f;
               z = EditorGUILayout.FloatField(new GUIContent("Offset  X"), z);
               EditorGUIUtility.labelWidth = 40.0f;
               w = EditorGUILayout.FloatField(new GUIContent("Y"), w);
            }
         }
      }
      EditorGUIUtility.labelWidth = 0.0f;

      scaleProp.vectorValue = new Vector4(x, y, z, w);
   }

   private void DrawChannelMixer(string idString, MaterialEditor materialEditor, MaterialProperty[] properties)
   {
      MaterialProperty mixProp = ShaderGUI.FindProperty("_Sample" + idString + "ChannelMix", properties);

      float r = mixProp.vectorValue.x;
      float g = mixProp.vectorValue.y;
      float b = mixProp.vectorValue.z;
      float a = mixProp.vectorValue.w;

      using (new EditorGUILayout.VerticalScope(boxStyle))
      {
         EditorGUILayout.LabelField(new GUIContent("Channel Mix Controls", "How much does each channel of the texture add to this sample?  R/G noise, B mask"), EditorStyles.miniLabel);

         using (new EditorGUILayout.HorizontalScope())
         {
            Color old = GUI.backgroundColor;
            GUI.backgroundColor = Color.red;
            using(new EditorGUILayout.HorizontalScope(boxStyle))
               r = EditorGUILayout.Slider(r, -_MIX_RANGE, _MIX_RANGE);
            GUI.backgroundColor = Color.green;
            using (new EditorGUILayout.HorizontalScope(boxStyle))
               g = EditorGUILayout.Slider(g, -_MIX_RANGE, _MIX_RANGE);
            GUI.backgroundColor = Color.blue;
            using (new EditorGUILayout.HorizontalScope(boxStyle))
               b = EditorGUILayout.Slider(b, -_MIX_RANGE, _MIX_RANGE);
            GUI.backgroundColor = Color.grey;
            using (new EditorGUILayout.HorizontalScope(boxStyle))
               a = EditorGUILayout.Slider(a, -_MIX_RANGE, _MIX_RANGE);
            GUI.backgroundColor = old;
         }
      }

      mixProp.vectorValue = new Vector4(r, g, b, a);
   }

   private void DrawUVScrollControls(MaterialProperty uvMode, MaterialProperty scrollVector)
   {
      float uv = uvMode.floatValue;

      if (uv == 0.0f)//Fixed UVs, we don't need controls
         return;

      float x = scrollVector.vectorValue.x;
      float y = scrollVector.vectorValue.y;
      float z = scrollVector.vectorValue.z;
      float w = scrollVector.vectorValue.w;

      EditorGUILayout.Space();

      if (uv == 1.0f) //Linear
      {
         using (new EditorGUILayout.HorizontalScope())
         {
            EditorGUIUtility.labelWidth = 120.0f;
            x = EditorGUILayout.FloatField(new GUIContent("X Scroll Rate"), x, GUILayout.Width(_halfWidth));
            y = EditorGUILayout.FloatField(new GUIContent("Y Scroll Rate"), y, GUILayout.Width(_halfWidth));
            EditorGUIUtility.labelWidth = 0.0f;
         }
      }
      else if (uv == 2.0f) //SinWave
      {
         using (new EditorGUILayout.HorizontalScope())
         {
            EditorGUIUtility.labelWidth = 60.0f;
            x = EditorGUILayout.FloatField(new GUIContent("X Amp", "X Wave Amplitude"), x, GUILayout.Width(_windowWidth * 0.25f));
            y = EditorGUILayout.FloatField(new GUIContent("Y Amp", "Y Wave Amplitude"), y, GUILayout.Width(_windowWidth * 0.25f));
            z = EditorGUILayout.FloatField(new GUIContent("Freq", "Frequency of the Waves"), z, GUILayout.Width(_windowWidth * 0.25f));
            w = EditorGUILayout.FloatField(new GUIContent("Offset", "Offset of the Waves"), w, GUILayout.Width(_windowWidth * 0.25f));
            EditorGUIUtility.labelWidth = 0.0f;
         }
      }
      else if (uv == 3.0f) //Spin
      {
         using (new EditorGUILayout.HorizontalScope())
         {
            EditorGUIUtility.labelWidth = 120.0f;
            x = EditorGUILayout.Slider(new GUIContent("Pivot X"), x, 0.0f, 1.0f, GUILayout.Width(_halfWidth));
            y = EditorGUILayout.Slider(new GUIContent("Pivot Y"), y, 0.0f, 1.0f, GUILayout.Width(_halfWidth));
            EditorGUIUtility.labelWidth = 0.0f;
         }
         using (new EditorGUILayout.HorizontalScope())
         {
            EditorGUIUtility.labelWidth = 120.0f;
            z = EditorGUILayout.FloatField(new GUIContent("Spin Rate"), z, GUILayout.Width(_halfWidth));
            w = EditorGUILayout.FloatField(new GUIContent("Start Angle"), w, GUILayout.Width(_halfWidth));
            EditorGUIUtility.labelWidth = 0.0f;
         }
      }
      else if (uv == 4.0f) //Radial
      {
         using (new EditorGUILayout.HorizontalScope())
         {
            EditorGUIUtility.labelWidth = 120.0f;
            x = EditorGUILayout.FloatField(new GUIContent("X Scroll Rate"), x, GUILayout.Width(_halfWidth));
            y = EditorGUILayout.FloatField(new GUIContent("Y Scroll Rate"), y, GUILayout.Width(_halfWidth));
            EditorGUIUtility.labelWidth = 0.0f;
         }
      }

      scrollVector.vectorValue = new Vector4(x, y, z, w);
   }

}
