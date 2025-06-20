Shader "NatureManufacture/URP/Ice/Ice Metallic Transparent"
{
    Properties
    {
        _WaterAlphaMultiply("Water Alpha Multiply", Float) = 0.66
        _WaterAlphaPower("Water Alpha Power", Float) = 1.39
        _CleanFalloffMultiply("Clean Falloff Multiply", Float) = 1.6
        _CleanFalloffPower("Clean Falloff Power", Float) = 0.34
        _ShalowFalloffMultiply("Shalow Falloff Multiply", Float) = 1.43
        _ShalowFalloffPower("Shalow Falloff Power", Float) = 3.3
        _CleanColorPower("Clean Color Power", Range(0, 1)) = 0.7
        _ShalowColor("Shalow Color", Color) = (0.7529412, 0.9215686, 0.9803922, 0)
        _DeepColor("Deep Color", Color) = (0, 0, 0, 0)
        _BaseColor("Ice Base Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_BaseColorMap("Ice Base Map", 2D) = "white" {}
        [ToggleUI]_BaseUsePlanarUV("Ice Base Use Planar UV", Float) = 0
        _BaseTilingOffset("Ice Base Tiling and Offset", Vector) = (1, 1, 0, 0)
        _IceNoiseScale("Ice Noise Scale", Float) = 3
        _IceNoiseContrast("Ice Noise Contrast", Float) = 1
        _IceNoisePower("Ice Noise Power", Float) = 1
        [Normal][NoScaleOffset]_BaseNormalMap("Ice Normal Map", 2D) = "bump" {}
        _BaseNormalScale("Ice Base Normal Scale", Range(0, 8)) = 0.3
        [NoScaleOffset]_IceNoiseNormal("Ice Noise Normal", 2D) = "white" {}
        _NoiseNormalScale("Ice Noise Normal Scale", Range(0, 8)) = 0.05
        _BaseMetallic("Ice Base Metallic", Range(0, 1)) = 1
        _BaseAO("Ice Base AO", Range(0, 1)) = 1
        _IceSmoothness("Ice Smoothness", Range(0, 1)) = 0.9
        _IceCrackSmoothness("Ice Crack Smoothness", Range(0, 1)) = 0.2
        _IceNoiseSmoothness("Ice Noise Smoothness", Range(0, 1)) = 0.9
        [NoScaleOffset]_ParalaxMap("Ice Parallax Map", 2D) = "black" {}
        _ParalaxOffset("Ice Parallax Offset", Float) = 0
        _IceParallaxSteps("Ice Parallax Steps", Float) = 40
        _IceDepth("Ice Parallax Depth", Float) = -0.1
        _ParallaxFalloff("Ice Parallax Falloff", Range(0, 1)) = 0.6
        _IceParallaxNoiseScale("Ice Parallax Noise Scale", Float) = 3
        _IceParallaxNoiseMin("Ice Parallax Noise Remap Min", Range(0, 1)) = 0
        _IceParallaxNoiseMax("Ice Parallax Noise Remap Max", Range(0, 1)) = 1
        _IceDistortion("Ice Distortion", Range(0, 10)) = 0.1
        _Ice_Noise_Distortion("Ice Noise Distortion", Range(0, 10)) = 0.1
        [NoScaleOffset]_DetailMap("Detail Map Base (R) Ny(G) Sm(B) Nx(A)", 2D) = "white" {}
        _DetailTilingOffset("Detail Tiling Offset", Vector) = (1, 1, 0, 0)
        _DetailAlbedoScale("Detail Albedo Scale", Range(0, 2)) = 0
        _DetailNormalScale("Detail Normal Scale", Range(0, 2)) = 0
        _DetailSmoothnessScale("Detail Smoothness Scale", Range(0, 2)) = 0
        _WetColor("Wet Color Vertex(R)", Color) = (0.7735849, 0.7735849, 0.7735849, 0)
        _WetSmoothness("Wet Smoothness Vertex(R)", Range(0, 1)) = 1
        [HideInInspector]_WorkflowMode("_WorkflowMode", Float) = 1
        [HideInInspector]_CastShadows("_CastShadows", Float) = 1
        [HideInInspector]_ReceiveShadows("_ReceiveShadows", Float) = 1
        [HideInInspector]_Surface("_Surface", Float) = 1
        [HideInInspector]_Blend("_Blend", Float) = 0
        [HideInInspector]_AlphaClip("_AlphaClip", Float) = 0
        [HideInInspector]_BlendModePreserveSpecular("_BlendModePreserveSpecular", Float) = 0
        [HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
        [HideInInspector]_DstBlend("_DstBlend", Float) = 0
        [HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 0
        [HideInInspector]_ZWriteControl("_ZWriteControl", Float) = 0
        [HideInInspector]_ZTest("_ZTest", Float) = 4
        [HideInInspector]_Cull("_Cull", Float) = 2
        [HideInInspector]_AlphaToMask("_AlphaToMask", Float) = 0
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _FORWARD_PLUS
        #pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        #pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define USE_UNITY_CROSSFADE 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float3 AbsoluteWorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        #include "./NMParallaxLayers.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
        Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
        UnitySamplerState _Property_46d5a097541149fe957f85c1365643be_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_46d5a097541149fe957f85c1365643be_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, tangentTransform, true);
        }
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
        Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }
        
        float Unity_SimpleNoise_ValueNoise_LegacySine_float (float2 uv)
        {
        float2 i = floor(uv);
        float2 f = frac(uv);
        f = f * f * (3.0 - 2.0 * f);
        uv = abs(frac(uv) - 0.5);
        float2 c0 = i + float2(0.0, 0.0);
        float2 c1 = i + float2(1.0, 0.0);
        float2 c2 = i + float2(0.0, 1.0);
        float2 c3 = i + float2(1.0, 1.0);
        float r0; Hash_LegacySine_2_1_float(c0, r0);
        float r1; Hash_LegacySine_2_1_float(c1, r1);
        float r2; Hash_LegacySine_2_1_float(c2, r2);
        float r3; Hash_LegacySine_2_1_float(c3, r3);
        float bottomOfGrid = lerp(r0, r1, f.x);
        float topOfGrid = lerp(r2, r3, f.x);
        float t = lerp(bottomOfGrid, topOfGrid, f.y);
        return t;
        }
        
        void Unity_SimpleNoise_LegacySine_float(float2 UV, float Scale, out float Out)
        {
        float freq, amp;
        Out = 0.0f;
        freq = pow(2.0, float(0));
        amp = pow(0.5, float(3-0));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(1));
        amp = pow(0.5, float(3-1));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(2));
        amp = pow(0.5, float(3-2));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float
        {
        float3 WorldSpaceNormal;
        float3 AbsoluteWorldSpacePosition;
        };
        
        void SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(float Vector1_E4D1C13A, float Vector1_CBF4C304, Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float IN, out float XYZ_1)
        {
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float3 _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1);
        float _Split_742547a7039de986a646d04c157ae549_R_1 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[0];
        float _Split_742547a7039de986a646d04c157ae549_G_2 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[1];
        float _Split_742547a7039de986a646d04c157ae549_B_3 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[2];
        float _Split_742547a7039de986a646d04c157ae549_A_4 = 0;
        float2 _Vector2_40a8919e571ec18499de72022c155b38_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_G_2, 1);
        float2 _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2;
        Unity_Multiply_float2_float2((_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4.xy), _Vector2_40a8919e571ec18499de72022c155b38_Out_0, _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2);
        float _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0 = Vector1_CBF4C304;
        float _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_5fa32af59cdca88389832336b2268bd5_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2);
        float3 _Absolute_644b798714827680b39bf5d34f70385f_Out_1;
        Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_644b798714827680b39bf5d34f70385f_Out_1);
        float _Property_adc4c59482221c8aad681c6558728ac9_Out_0 = Vector1_E4D1C13A;
        float3 _Power_ee478822a04529849ae8df1636c29fe2_Out_2;
        Unity_Power_float3(_Absolute_644b798714827680b39bf5d34f70385f_Out_1, (_Property_adc4c59482221c8aad681c6558728ac9_Out_0.xxx), _Power_ee478822a04529849ae8df1636c29fe2_Out_2);
        float3 _Multiply_b386a937554d73828e437d126d69608b_Out_2;
        Unity_Multiply_float3_float3(_Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Multiply_b386a937554d73828e437d126d69608b_Out_2);
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[0];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[1];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[2];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_A_4 = 0;
        float _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2);
        float4 _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4;
        float3 _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5;
        float2 _Combine_192c2c4a69be588b90ca005a32e22552_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4, _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5, _Combine_192c2c4a69be588b90ca005a32e22552_RG_6);
        float _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2;
        Unity_Multiply_float_float(_Split_742547a7039de986a646d04c157ae549_B_3, -1, _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2);
        float2 _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0 = float2(_Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2, 1);
        float2 _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2;
        Unity_Multiply_float2_float2((_Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4.xy), _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0, _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2);
        float _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2);
        float _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2);
        float4 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4;
        float3 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5;
        float2 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_B_3, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6);
        float2 _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_R_1, 1);
        float2 _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2;
        Unity_Multiply_float2_float2((_Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4.xy), _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0, _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2);
        float _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2);
        float _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2);
        float _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2;
        Unity_Add_float(_Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2);
        float _Add_14295f72880e4b87a1baf1ced943ac40_Out_2;
        Unity_Add_float(_Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2, _Add_14295f72880e4b87a1baf1ced943ac40_Out_2);
        float _Add_e59af300bba2498db32eac1412123447_Out_2;
        Unity_Add_float(_Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Add_e59af300bba2498db32eac1412123447_Out_2);
        float _Add_e855069f047fae8ea9027d56acb61e56_Out_2;
        Unity_Add_float(_Add_e59af300bba2498db32eac1412123447_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Add_e855069f047fae8ea9027d56acb61e56_Out_2);
        float _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        Unity_Divide_float(_Add_14295f72880e4b87a1baf1ced943ac40_Out_2, _Add_e855069f047fae8ea9027d56acb61e56_Out_2, _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2);
        XYZ_1 = _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Contrast_float(float3 In, float Contrast, out float3 Out)
        {
            float midpoint = pow(0.5, 2.2);
            Out =  (In - midpoint) * Contrast + midpoint;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float2(float2 A, float2 B, float2 T, out float2 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        UnitySamplerState _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }
        
        struct Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float IN, out float4 XZ_2)
        {
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        XZ_2 = (float4(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3, 0.0, 1.0));
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float
        {
        };
        
        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float IN, out float3 OutVector4_1)
        {
        float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
        float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
        Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
        float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
        Unity_Multiply_float_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
        float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
        float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
        Unity_Multiply_float4_float4(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
        OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        struct Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float
        {
        };
        
        void SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(float Vector1_32317166, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float IN, out float SmoothnessOverlay_1)
        {
        float _Property_728cc50521e9e988ac9cbff4872d5139_Out_0 = Vector1_32317166;
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
        float _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        Unity_Lerp_float(_Property_728cc50521e9e988ac9cbff4872d5139_Out_0, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
        SmoothnessOverlay_1 = _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _Property_e5176656505ae98292b155cb230ab233_Out_0 = _IceDistortion;
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0 = _BaseUsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_11506852e45cbb8f9732aebed8bbb210;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.uv0 = IN.uv0;
            float4 _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_11506852e45cbb8f9732aebed8bbb210, _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2);
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_R_1 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[0];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[1];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_B_3 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[2];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_A_4 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[3];
            float4 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4;
            float3 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5;
            float2 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6;
            Unity_Combine_float(_Split_a108e1720257bf83ba61786c1ab1a0ca_R_1, _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2, 0, 0, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6);
            float2 _Multiply_9bed13a6994a89889288447a9152078b_Out_2;
            Unity_Multiply_float2_float2((_Property_e5176656505ae98292b155cb230ab233_Out_0.xx), _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6, _Multiply_9bed13a6994a89889288447a9152078b_Out_2);
            float _Property_8644e31610e05a84bfa06afd61d23967_Out_0 = _Ice_Noise_Distortion;
            UnityTexture2D _Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0 = UnityBuildTexture2DStructNoScale(_IceNoiseNormal);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.uv0 = IN.uv0;
            float4 _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc, _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2);
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_R_1 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[0];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[1];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_B_3 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[2];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_A_4 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[3];
            float4 _Combine_0980c1220518a788beef3792138b09bc_RGBA_4;
            float3 _Combine_0980c1220518a788beef3792138b09bc_RGB_5;
            float2 _Combine_0980c1220518a788beef3792138b09bc_RG_6;
            Unity_Combine_float(_Split_aea7e8f011b37b85bd67111f2c0722a7_R_1, _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2, 0, 0, _Combine_0980c1220518a788beef3792138b09bc_RGBA_4, _Combine_0980c1220518a788beef3792138b09bc_RGB_5, _Combine_0980c1220518a788beef3792138b09bc_RG_6);
            float2 _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2;
            Unity_Multiply_float2_float2((_Property_8644e31610e05a84bfa06afd61d23967_Out_0.xx), _Combine_0980c1220518a788beef3792138b09bc_RG_6, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2);
            float _Property_852d221028b884858f029fedb8de47d1_Out_0 = _IceNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_852d221028b884858f029fedb8de47d1_Out_0, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1);
            float _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1;
            Unity_Absolute_float(_TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1, _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1);
            float _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0 = _IceNoisePower;
            float _Power_1497f6299359e780a9aa8dde441d98cf_Out_2;
            Unity_Power_float(_Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1, _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0, _Power_1497f6299359e780a9aa8dde441d98cf_Out_2);
            float _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0 = _IceNoiseContrast;
            float3 _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2;
            Unity_Contrast_float((_Power_1497f6299359e780a9aa8dde441d98cf_Out_2.xxx), _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0, _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2);
            float _Split_f399eb1f3ad77580a75b6122d38451b5_R_1 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[0];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_G_2 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[1];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_B_3 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[2];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_A_4 = 0;
            float _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3;
            Unity_Clamp_float(_Split_f399eb1f3ad77580a75b6122d38451b5_R_1, 0, 1, _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3);
            float2 _Lerp_701142594e6c5786a700edb533ed6de3_Out_3;
            Unity_Lerp_float2(_Multiply_9bed13a6994a89889288447a9152078b_Out_2, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xx), _Lerp_701142594e6c5786a700edb533ed6de3_Out_3);
            float2 _Multiply_be4736503512af8d91df02fa276dcd77_Out_2;
            Unity_Multiply_float2_float2(_Lerp_701142594e6c5786a700edb533ed6de3_Out_3, (_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2);
            float2 _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2;
            Unity_Add_float2((_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2, _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2);
            float3 _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1;
            Unity_SceneColor_float((float4(_Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2, 0.0, 1.0)), _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1);
            float _Property_49f84d0718855d86902de5bbf5925223_Out_0 = _CleanColorPower;
            float3 _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2;
            Unity_Multiply_float3_float3(_SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1, (_Property_49f84d0718855d86902de5bbf5925223_Out_0.xxx), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2);
            float4 _Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0 = _DeepColor;
            float4 _Property_7094041d89afbd878cb83460f4ab68b8_Out_0 = _ShalowColor;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0 = _ShalowFalloffMultiply;
            float _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0, _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2);
            float _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1;
            Unity_Absolute_float(_Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2, _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1);
            float _Property_e6dd087698d3e984bd5eb642347af797_Out_0 = _ShalowFalloffPower;
            float _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2;
            Unity_Multiply_float_float(_Property_e6dd087698d3e984bd5eb642347af797_Out_0, -1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2);
            float _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2;
            Unity_Power_float(_Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2, _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2);
            float _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1;
            Unity_Saturate_float(_Power_aaf82c5db3291a8bb2095cce38670a92_Out_2, _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1);
            float _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3;
            Unity_Clamp_float(_Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1, 0, 1, _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3);
            float4 _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3;
            Unity_Lerp_float4(_Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0, _Property_7094041d89afbd878cb83460f4ab68b8_Out_0, (_Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3.xxxx), _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3);
            float3 _Multiply_175272476246508a97ee024c2aec0469_Out_2;
            Unity_Multiply_float3_float3((_Lerp_bff7238223fec786b08d9cf92a09754c_Out_3.xyz), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2);
            float _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0 = _CleanFalloffMultiply;
            float _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0, _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2);
            float _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3;
            Unity_Clamp_float(_Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2, 0, 1, _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3);
            float _Absolute_2efac825a986e28190f26200795ca9ec_Out_1;
            Unity_Absolute_float(_Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3, _Absolute_2efac825a986e28190f26200795ca9ec_Out_1);
            float _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0 = _CleanFalloffPower;
            float _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2;
            Unity_Power_float(_Absolute_2efac825a986e28190f26200795ca9ec_Out_1, _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0, _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2);
            float _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3;
            Unity_Clamp_float(_Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2, 0, 1, _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3);
            float3 _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3;
            Unity_Lerp_float3(_Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2, (_Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3.xxx), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3);
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_893a7c3932a452849a5239a91f337a35;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.uv0 = IN.uv0;
            float4 _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNM_893a7c3932a452849a5239a91f337a35, _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2);
            float _Property_771911a99405a780908dd542012af7b8_Out_0 = _IceParallaxSteps;
            Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.uv0 = IN.uv0;
            float4 _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2;
            SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(_Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2);
            float _Property_efee416de222038a93fa523171fb9f0d_Out_0 = _ParalaxOffset;
            float _Property_720bc7e00a412889a10ca999204543f8_Out_0 = _IceParallaxNoiseMin;
            float _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0 = _IceParallaxNoiseMax;
            float _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0 = _IceParallaxNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1);
            float _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3;
            Unity_Clamp_float(_TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1, 0, 1, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3);
            float _Lerp_87de925175c62a8986309dc80655ce2f_Out_3;
            Unity_Lerp_float(_Property_720bc7e00a412889a10ca999204543f8_Out_0, _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3);
            float _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3;
            Unity_Lerp_float(_Property_efee416de222038a93fa523171fb9f0d_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3);
            float _Property_acfd17e181f6108ba7921d3e04df886d_Out_0 = _IceDepth;
            float3 _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1 = TransformWorldToTangentDir(IN.WorldSpaceViewDirection.xyz, tangentTransform, true);
            }
            float _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0 = _ParallaxFalloff;
            float _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3;
            Unity_Lerp_float(_Property_eede9dad69eea580b2a3fdc05280f02f_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3);
            float4 _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2;
            ParallaxLayers_float(_Property_771911a99405a780908dd542012af7b8_Out_0, (_PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2.xy), _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3, _Property_acfd17e181f6108ba7921d3e04df886d_Out_0, _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1, IN.WorldSpaceViewDirection, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2);
            float4 _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2;
            Unity_Blend_Lighten_float4(_PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2, _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2;
            Unity_Multiply_float4_float4(_Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_41859d117584758eb8002ecc938f9bce_Out_0, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2);
            float3 _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3;
            Unity_Lerp_float3((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2.xyz), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xxx), _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1 = _Property_256e5676e1089881ae3214634430b140_Out_0[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2 = _Property_256e5676e1089881ae3214634430b140_Out_0[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3 = _Property_256e5676e1089881ae3214634430b140_Out_0[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4 = _Property_256e5676e1089881ae3214634430b140_Out_0[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.tex, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.a;
            float _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4, 2, _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2);
            float _Add_fd3efcae64779e848ef39919335cd44d_Out_2;
            Unity_Add_float(_Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2, -1, _Add_fd3efcae64779e848ef39919335cd44d_Out_2);
            float _Property_605f29777330a58ba88ac032e905433b_Out_0 = _DetailAlbedoScale;
            float _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2;
            Unity_Multiply_float_float(_Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Property_605f29777330a58ba88ac032e905433b_Out_0, _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2);
            float _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1;
            Unity_Saturate_float(_Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2, _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1);
            float _Absolute_8acef423205118879e75274a48969d34_Out_1;
            Unity_Absolute_float(_Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1, _Absolute_8acef423205118879e75274a48969d34_Out_1);
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185;
            float3 _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float((float4(_Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3, 1.0)), _Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Absolute_8acef423205118879e75274a48969d34_Out_1, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float3 _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3;
            Unity_Lerp_float3(_Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, (_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3.xxx), _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3);
            float4 _Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0 = _WetColor;
            float3 _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2;
            Unity_Multiply_float3_float3((_Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0.xyz), _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3;
            Unity_Clamp_float(_Split_5b2299b48b10138ea40c141b79bfe90e_R_1, 0, 1, _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3);
            float _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1;
            Unity_OneMinus_float(_Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1);
            float3 _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            Unity_Lerp_float3(_Lerp_7b0da7568070568992f16c8217ad84e6_Out_3, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2, (_OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1.xxx), _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3);
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0 = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1 = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2 = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3 = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4 = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1, _Split_c4822b8eaff9b185be7c059792345712_G_2, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0 = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2);
            float _Property_345c364a9e67bd878b47cfd40d450e2f_Out_0 = _NoiseNormalScale;
            float3 _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2.xyz), _Property_345c364a9e67bd878b47cfd40d450e2f_Out_0, _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2);
            float3 _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3;
            Unity_Lerp_float3(_NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2, _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xxx), _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2;
            Unity_NormalBlend_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0, _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2);
            float _Property_bbb7f63dc018f9828732f80495a95444_Out_0 = _BaseMetallic;
            float _Property_48e1c5285b48c78e8af19e38f4bd77f9_Out_0 = _BaseAO;
            float _Property_0edea7916ed7a189a62b0faf2c274601_Out_0 = _IceSmoothness;
            float _Property_1a0bf713a75e068aacef13a95a7ea011_Out_0 = _IceCrackSmoothness;
            UnityTexture2D _Property_be61fb085f680285bb171ac957c1d150_Out_0 = UnityBuildTexture2DStructNoScale(_ParalaxMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c;
            _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c.uv0 = IN.uv0;
            float4 _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_be61fb085f680285bb171ac957c1d150_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c, _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2);
            float _Split_e8121381f96e2f80a65ed1fb8ebd6974_R_1 = _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2[0];
            float _Split_e8121381f96e2f80a65ed1fb8ebd6974_G_2 = _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2[1];
            float _Split_e8121381f96e2f80a65ed1fb8ebd6974_B_3 = _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2[2];
            float _Split_e8121381f96e2f80a65ed1fb8ebd6974_A_4 = _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2[3];
            float _Lerp_99e1105aeec5c981bdda0260115c2cfa_Out_3;
            Unity_Lerp_float(_Property_0edea7916ed7a189a62b0faf2c274601_Out_0, _Property_1a0bf713a75e068aacef13a95a7ea011_Out_0, _Split_e8121381f96e2f80a65ed1fb8ebd6974_R_1, _Lerp_99e1105aeec5c981bdda0260115c2cfa_Out_3);
            float _Property_04fa33e60ce3e38aa158980eac5a1bba_Out_0 = _IceNoiseSmoothness;
            float _Lerp_0f76c7b660a9f98c931ff1c5f1662281_Out_3;
            Unity_Lerp_float(_Lerp_99e1105aeec5c981bdda0260115c2cfa_Out_3, _Property_04fa33e60ce3e38aa158980eac5a1bba_Out_0, _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3, _Lerp_0f76c7b660a9f98c931ff1c5f1662281_Out_3);
            float _Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6, 2, _Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2);
            float _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2;
            Unity_Add_float(_Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2, -1, _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2);
            float _Property_cea4e47b293a988a83643b43f76c92ba_Out_0 = _DetailSmoothnessScale;
            float _Multiply_2008466558f0e4819e60b3c41d94487c_Out_2;
            Unity_Multiply_float_float(_Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2, _Property_cea4e47b293a988a83643b43f76c92ba_Out_0, _Multiply_2008466558f0e4819e60b3c41d94487c_Out_2);
            float _Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1;
            Unity_Saturate_float(_Multiply_2008466558f0e4819e60b3c41d94487c_Out_2, _Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1);
            float _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1;
            Unity_Absolute_float(_Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1, _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1);
            Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43;
            float _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1;
            SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(_Lerp_0f76c7b660a9f98c931ff1c5f1662281_Out_3, _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2, _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1, _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43, _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1);
            float _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1;
            Unity_Saturate_float(_BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1, _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1);
            float3 _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0 = float3(_Property_bbb7f63dc018f9828732f80495a95444_Out_0, _Property_48e1c5285b48c78e8af19e38f4bd77f9_Out_0, _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1);
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_R_1 = _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0[0];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_G_2 = _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0[1];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_B_3 = _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0[2];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_A_4 = 0;
            float _Property_006bb9304a39f5808cf13865f8c36ad4_Out_0 = _WetSmoothness;
            float _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3;
            Unity_Lerp_float(_Split_645358fc1f0e278fbfc2ccb5594c95e3_B_3, _Property_006bb9304a39f5808cf13865f8c36ad4_Out_0, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1, _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3);
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.BaseColor = _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            surface.NormalTS = _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Split_645358fc1f0e278fbfc2ccb5594c95e3_R_1;
            surface.Specular = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.Smoothness = _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3;
            surface.Occlusion = _Split_645358fc1f0e278fbfc2ccb5594c95e3_G_2;
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        #pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define USE_UNITY_CROSSFADE 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float3 AbsoluteWorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        #include "./NMParallaxLayers.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
        Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
        UnitySamplerState _Property_46d5a097541149fe957f85c1365643be_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_46d5a097541149fe957f85c1365643be_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, tangentTransform, true);
        }
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
        Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }
        
        float Unity_SimpleNoise_ValueNoise_LegacySine_float (float2 uv)
        {
        float2 i = floor(uv);
        float2 f = frac(uv);
        f = f * f * (3.0 - 2.0 * f);
        uv = abs(frac(uv) - 0.5);
        float2 c0 = i + float2(0.0, 0.0);
        float2 c1 = i + float2(1.0, 0.0);
        float2 c2 = i + float2(0.0, 1.0);
        float2 c3 = i + float2(1.0, 1.0);
        float r0; Hash_LegacySine_2_1_float(c0, r0);
        float r1; Hash_LegacySine_2_1_float(c1, r1);
        float r2; Hash_LegacySine_2_1_float(c2, r2);
        float r3; Hash_LegacySine_2_1_float(c3, r3);
        float bottomOfGrid = lerp(r0, r1, f.x);
        float topOfGrid = lerp(r2, r3, f.x);
        float t = lerp(bottomOfGrid, topOfGrid, f.y);
        return t;
        }
        
        void Unity_SimpleNoise_LegacySine_float(float2 UV, float Scale, out float Out)
        {
        float freq, amp;
        Out = 0.0f;
        freq = pow(2.0, float(0));
        amp = pow(0.5, float(3-0));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(1));
        amp = pow(0.5, float(3-1));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(2));
        amp = pow(0.5, float(3-2));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float
        {
        float3 WorldSpaceNormal;
        float3 AbsoluteWorldSpacePosition;
        };
        
        void SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(float Vector1_E4D1C13A, float Vector1_CBF4C304, Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float IN, out float XYZ_1)
        {
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float3 _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1);
        float _Split_742547a7039de986a646d04c157ae549_R_1 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[0];
        float _Split_742547a7039de986a646d04c157ae549_G_2 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[1];
        float _Split_742547a7039de986a646d04c157ae549_B_3 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[2];
        float _Split_742547a7039de986a646d04c157ae549_A_4 = 0;
        float2 _Vector2_40a8919e571ec18499de72022c155b38_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_G_2, 1);
        float2 _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2;
        Unity_Multiply_float2_float2((_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4.xy), _Vector2_40a8919e571ec18499de72022c155b38_Out_0, _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2);
        float _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0 = Vector1_CBF4C304;
        float _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_5fa32af59cdca88389832336b2268bd5_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2);
        float3 _Absolute_644b798714827680b39bf5d34f70385f_Out_1;
        Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_644b798714827680b39bf5d34f70385f_Out_1);
        float _Property_adc4c59482221c8aad681c6558728ac9_Out_0 = Vector1_E4D1C13A;
        float3 _Power_ee478822a04529849ae8df1636c29fe2_Out_2;
        Unity_Power_float3(_Absolute_644b798714827680b39bf5d34f70385f_Out_1, (_Property_adc4c59482221c8aad681c6558728ac9_Out_0.xxx), _Power_ee478822a04529849ae8df1636c29fe2_Out_2);
        float3 _Multiply_b386a937554d73828e437d126d69608b_Out_2;
        Unity_Multiply_float3_float3(_Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Multiply_b386a937554d73828e437d126d69608b_Out_2);
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[0];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[1];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[2];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_A_4 = 0;
        float _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2);
        float4 _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4;
        float3 _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5;
        float2 _Combine_192c2c4a69be588b90ca005a32e22552_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4, _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5, _Combine_192c2c4a69be588b90ca005a32e22552_RG_6);
        float _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2;
        Unity_Multiply_float_float(_Split_742547a7039de986a646d04c157ae549_B_3, -1, _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2);
        float2 _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0 = float2(_Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2, 1);
        float2 _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2;
        Unity_Multiply_float2_float2((_Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4.xy), _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0, _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2);
        float _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2);
        float _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2);
        float4 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4;
        float3 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5;
        float2 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_B_3, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6);
        float2 _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_R_1, 1);
        float2 _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2;
        Unity_Multiply_float2_float2((_Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4.xy), _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0, _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2);
        float _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2);
        float _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2);
        float _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2;
        Unity_Add_float(_Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2);
        float _Add_14295f72880e4b87a1baf1ced943ac40_Out_2;
        Unity_Add_float(_Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2, _Add_14295f72880e4b87a1baf1ced943ac40_Out_2);
        float _Add_e59af300bba2498db32eac1412123447_Out_2;
        Unity_Add_float(_Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Add_e59af300bba2498db32eac1412123447_Out_2);
        float _Add_e855069f047fae8ea9027d56acb61e56_Out_2;
        Unity_Add_float(_Add_e59af300bba2498db32eac1412123447_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Add_e855069f047fae8ea9027d56acb61e56_Out_2);
        float _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        Unity_Divide_float(_Add_14295f72880e4b87a1baf1ced943ac40_Out_2, _Add_e855069f047fae8ea9027d56acb61e56_Out_2, _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2);
        XYZ_1 = _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Contrast_float(float3 In, float Contrast, out float3 Out)
        {
            float midpoint = pow(0.5, 2.2);
            Out =  (In - midpoint) * Contrast + midpoint;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float2(float2 A, float2 B, float2 T, out float2 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        UnitySamplerState _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }
        
        struct Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float IN, out float4 XZ_2)
        {
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        XZ_2 = (float4(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3, 0.0, 1.0));
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float
        {
        };
        
        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float IN, out float3 OutVector4_1)
        {
        float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
        float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
        Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
        float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
        Unity_Multiply_float_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
        float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
        float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
        Unity_Multiply_float4_float4(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
        OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        struct Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float
        {
        };
        
        void SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(float Vector1_32317166, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float IN, out float SmoothnessOverlay_1)
        {
        float _Property_728cc50521e9e988ac9cbff4872d5139_Out_0 = Vector1_32317166;
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
        float _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        Unity_Lerp_float(_Property_728cc50521e9e988ac9cbff4872d5139_Out_0, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
        SmoothnessOverlay_1 = _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _Property_e5176656505ae98292b155cb230ab233_Out_0 = _IceDistortion;
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0 = _BaseUsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_11506852e45cbb8f9732aebed8bbb210;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.uv0 = IN.uv0;
            float4 _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_11506852e45cbb8f9732aebed8bbb210, _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2);
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_R_1 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[0];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[1];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_B_3 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[2];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_A_4 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[3];
            float4 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4;
            float3 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5;
            float2 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6;
            Unity_Combine_float(_Split_a108e1720257bf83ba61786c1ab1a0ca_R_1, _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2, 0, 0, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6);
            float2 _Multiply_9bed13a6994a89889288447a9152078b_Out_2;
            Unity_Multiply_float2_float2((_Property_e5176656505ae98292b155cb230ab233_Out_0.xx), _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6, _Multiply_9bed13a6994a89889288447a9152078b_Out_2);
            float _Property_8644e31610e05a84bfa06afd61d23967_Out_0 = _Ice_Noise_Distortion;
            UnityTexture2D _Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0 = UnityBuildTexture2DStructNoScale(_IceNoiseNormal);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.uv0 = IN.uv0;
            float4 _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc, _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2);
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_R_1 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[0];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[1];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_B_3 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[2];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_A_4 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[3];
            float4 _Combine_0980c1220518a788beef3792138b09bc_RGBA_4;
            float3 _Combine_0980c1220518a788beef3792138b09bc_RGB_5;
            float2 _Combine_0980c1220518a788beef3792138b09bc_RG_6;
            Unity_Combine_float(_Split_aea7e8f011b37b85bd67111f2c0722a7_R_1, _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2, 0, 0, _Combine_0980c1220518a788beef3792138b09bc_RGBA_4, _Combine_0980c1220518a788beef3792138b09bc_RGB_5, _Combine_0980c1220518a788beef3792138b09bc_RG_6);
            float2 _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2;
            Unity_Multiply_float2_float2((_Property_8644e31610e05a84bfa06afd61d23967_Out_0.xx), _Combine_0980c1220518a788beef3792138b09bc_RG_6, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2);
            float _Property_852d221028b884858f029fedb8de47d1_Out_0 = _IceNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_852d221028b884858f029fedb8de47d1_Out_0, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1);
            float _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1;
            Unity_Absolute_float(_TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1, _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1);
            float _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0 = _IceNoisePower;
            float _Power_1497f6299359e780a9aa8dde441d98cf_Out_2;
            Unity_Power_float(_Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1, _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0, _Power_1497f6299359e780a9aa8dde441d98cf_Out_2);
            float _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0 = _IceNoiseContrast;
            float3 _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2;
            Unity_Contrast_float((_Power_1497f6299359e780a9aa8dde441d98cf_Out_2.xxx), _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0, _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2);
            float _Split_f399eb1f3ad77580a75b6122d38451b5_R_1 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[0];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_G_2 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[1];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_B_3 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[2];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_A_4 = 0;
            float _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3;
            Unity_Clamp_float(_Split_f399eb1f3ad77580a75b6122d38451b5_R_1, 0, 1, _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3);
            float2 _Lerp_701142594e6c5786a700edb533ed6de3_Out_3;
            Unity_Lerp_float2(_Multiply_9bed13a6994a89889288447a9152078b_Out_2, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xx), _Lerp_701142594e6c5786a700edb533ed6de3_Out_3);
            float2 _Multiply_be4736503512af8d91df02fa276dcd77_Out_2;
            Unity_Multiply_float2_float2(_Lerp_701142594e6c5786a700edb533ed6de3_Out_3, (_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2);
            float2 _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2;
            Unity_Add_float2((_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2, _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2);
            float3 _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1;
            Unity_SceneColor_float((float4(_Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2, 0.0, 1.0)), _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1);
            float _Property_49f84d0718855d86902de5bbf5925223_Out_0 = _CleanColorPower;
            float3 _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2;
            Unity_Multiply_float3_float3(_SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1, (_Property_49f84d0718855d86902de5bbf5925223_Out_0.xxx), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2);
            float4 _Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0 = _DeepColor;
            float4 _Property_7094041d89afbd878cb83460f4ab68b8_Out_0 = _ShalowColor;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0 = _ShalowFalloffMultiply;
            float _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0, _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2);
            float _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1;
            Unity_Absolute_float(_Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2, _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1);
            float _Property_e6dd087698d3e984bd5eb642347af797_Out_0 = _ShalowFalloffPower;
            float _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2;
            Unity_Multiply_float_float(_Property_e6dd087698d3e984bd5eb642347af797_Out_0, -1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2);
            float _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2;
            Unity_Power_float(_Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2, _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2);
            float _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1;
            Unity_Saturate_float(_Power_aaf82c5db3291a8bb2095cce38670a92_Out_2, _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1);
            float _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3;
            Unity_Clamp_float(_Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1, 0, 1, _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3);
            float4 _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3;
            Unity_Lerp_float4(_Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0, _Property_7094041d89afbd878cb83460f4ab68b8_Out_0, (_Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3.xxxx), _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3);
            float3 _Multiply_175272476246508a97ee024c2aec0469_Out_2;
            Unity_Multiply_float3_float3((_Lerp_bff7238223fec786b08d9cf92a09754c_Out_3.xyz), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2);
            float _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0 = _CleanFalloffMultiply;
            float _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0, _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2);
            float _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3;
            Unity_Clamp_float(_Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2, 0, 1, _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3);
            float _Absolute_2efac825a986e28190f26200795ca9ec_Out_1;
            Unity_Absolute_float(_Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3, _Absolute_2efac825a986e28190f26200795ca9ec_Out_1);
            float _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0 = _CleanFalloffPower;
            float _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2;
            Unity_Power_float(_Absolute_2efac825a986e28190f26200795ca9ec_Out_1, _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0, _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2);
            float _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3;
            Unity_Clamp_float(_Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2, 0, 1, _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3);
            float3 _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3;
            Unity_Lerp_float3(_Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2, (_Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3.xxx), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3);
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_893a7c3932a452849a5239a91f337a35;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.uv0 = IN.uv0;
            float4 _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNM_893a7c3932a452849a5239a91f337a35, _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2);
            float _Property_771911a99405a780908dd542012af7b8_Out_0 = _IceParallaxSteps;
            Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.uv0 = IN.uv0;
            float4 _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2;
            SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(_Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2);
            float _Property_efee416de222038a93fa523171fb9f0d_Out_0 = _ParalaxOffset;
            float _Property_720bc7e00a412889a10ca999204543f8_Out_0 = _IceParallaxNoiseMin;
            float _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0 = _IceParallaxNoiseMax;
            float _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0 = _IceParallaxNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1);
            float _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3;
            Unity_Clamp_float(_TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1, 0, 1, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3);
            float _Lerp_87de925175c62a8986309dc80655ce2f_Out_3;
            Unity_Lerp_float(_Property_720bc7e00a412889a10ca999204543f8_Out_0, _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3);
            float _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3;
            Unity_Lerp_float(_Property_efee416de222038a93fa523171fb9f0d_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3);
            float _Property_acfd17e181f6108ba7921d3e04df886d_Out_0 = _IceDepth;
            float3 _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1 = TransformWorldToTangentDir(IN.WorldSpaceViewDirection.xyz, tangentTransform, true);
            }
            float _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0 = _ParallaxFalloff;
            float _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3;
            Unity_Lerp_float(_Property_eede9dad69eea580b2a3fdc05280f02f_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3);
            float4 _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2;
            ParallaxLayers_float(_Property_771911a99405a780908dd542012af7b8_Out_0, (_PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2.xy), _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3, _Property_acfd17e181f6108ba7921d3e04df886d_Out_0, _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1, IN.WorldSpaceViewDirection, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2);
            float4 _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2;
            Unity_Blend_Lighten_float4(_PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2, _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2;
            Unity_Multiply_float4_float4(_Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_41859d117584758eb8002ecc938f9bce_Out_0, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2);
            float3 _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3;
            Unity_Lerp_float3((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2.xyz), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xxx), _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1 = _Property_256e5676e1089881ae3214634430b140_Out_0[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2 = _Property_256e5676e1089881ae3214634430b140_Out_0[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3 = _Property_256e5676e1089881ae3214634430b140_Out_0[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4 = _Property_256e5676e1089881ae3214634430b140_Out_0[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.tex, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.a;
            float _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4, 2, _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2);
            float _Add_fd3efcae64779e848ef39919335cd44d_Out_2;
            Unity_Add_float(_Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2, -1, _Add_fd3efcae64779e848ef39919335cd44d_Out_2);
            float _Property_605f29777330a58ba88ac032e905433b_Out_0 = _DetailAlbedoScale;
            float _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2;
            Unity_Multiply_float_float(_Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Property_605f29777330a58ba88ac032e905433b_Out_0, _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2);
            float _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1;
            Unity_Saturate_float(_Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2, _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1);
            float _Absolute_8acef423205118879e75274a48969d34_Out_1;
            Unity_Absolute_float(_Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1, _Absolute_8acef423205118879e75274a48969d34_Out_1);
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185;
            float3 _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float((float4(_Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3, 1.0)), _Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Absolute_8acef423205118879e75274a48969d34_Out_1, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float3 _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3;
            Unity_Lerp_float3(_Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, (_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3.xxx), _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3);
            float4 _Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0 = _WetColor;
            float3 _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2;
            Unity_Multiply_float3_float3((_Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0.xyz), _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3;
            Unity_Clamp_float(_Split_5b2299b48b10138ea40c141b79bfe90e_R_1, 0, 1, _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3);
            float _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1;
            Unity_OneMinus_float(_Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1);
            float3 _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            Unity_Lerp_float3(_Lerp_7b0da7568070568992f16c8217ad84e6_Out_3, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2, (_OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1.xxx), _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3);
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0 = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1 = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2 = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3 = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4 = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1, _Split_c4822b8eaff9b185be7c059792345712_G_2, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0 = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2);
            float _Property_345c364a9e67bd878b47cfd40d450e2f_Out_0 = _NoiseNormalScale;
            float3 _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2.xyz), _Property_345c364a9e67bd878b47cfd40d450e2f_Out_0, _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2);
            float3 _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3;
            Unity_Lerp_float3(_NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2, _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xxx), _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2;
            Unity_NormalBlend_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0, _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2);
            float _Property_bbb7f63dc018f9828732f80495a95444_Out_0 = _BaseMetallic;
            float _Property_48e1c5285b48c78e8af19e38f4bd77f9_Out_0 = _BaseAO;
            float _Property_0edea7916ed7a189a62b0faf2c274601_Out_0 = _IceSmoothness;
            float _Property_1a0bf713a75e068aacef13a95a7ea011_Out_0 = _IceCrackSmoothness;
            UnityTexture2D _Property_be61fb085f680285bb171ac957c1d150_Out_0 = UnityBuildTexture2DStructNoScale(_ParalaxMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c;
            _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c.uv0 = IN.uv0;
            float4 _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_be61fb085f680285bb171ac957c1d150_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c, _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2);
            float _Split_e8121381f96e2f80a65ed1fb8ebd6974_R_1 = _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2[0];
            float _Split_e8121381f96e2f80a65ed1fb8ebd6974_G_2 = _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2[1];
            float _Split_e8121381f96e2f80a65ed1fb8ebd6974_B_3 = _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2[2];
            float _Split_e8121381f96e2f80a65ed1fb8ebd6974_A_4 = _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2[3];
            float _Lerp_99e1105aeec5c981bdda0260115c2cfa_Out_3;
            Unity_Lerp_float(_Property_0edea7916ed7a189a62b0faf2c274601_Out_0, _Property_1a0bf713a75e068aacef13a95a7ea011_Out_0, _Split_e8121381f96e2f80a65ed1fb8ebd6974_R_1, _Lerp_99e1105aeec5c981bdda0260115c2cfa_Out_3);
            float _Property_04fa33e60ce3e38aa158980eac5a1bba_Out_0 = _IceNoiseSmoothness;
            float _Lerp_0f76c7b660a9f98c931ff1c5f1662281_Out_3;
            Unity_Lerp_float(_Lerp_99e1105aeec5c981bdda0260115c2cfa_Out_3, _Property_04fa33e60ce3e38aa158980eac5a1bba_Out_0, _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3, _Lerp_0f76c7b660a9f98c931ff1c5f1662281_Out_3);
            float _Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6, 2, _Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2);
            float _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2;
            Unity_Add_float(_Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2, -1, _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2);
            float _Property_cea4e47b293a988a83643b43f76c92ba_Out_0 = _DetailSmoothnessScale;
            float _Multiply_2008466558f0e4819e60b3c41d94487c_Out_2;
            Unity_Multiply_float_float(_Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2, _Property_cea4e47b293a988a83643b43f76c92ba_Out_0, _Multiply_2008466558f0e4819e60b3c41d94487c_Out_2);
            float _Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1;
            Unity_Saturate_float(_Multiply_2008466558f0e4819e60b3c41d94487c_Out_2, _Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1);
            float _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1;
            Unity_Absolute_float(_Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1, _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1);
            Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43;
            float _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1;
            SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(_Lerp_0f76c7b660a9f98c931ff1c5f1662281_Out_3, _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2, _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1, _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43, _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1);
            float _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1;
            Unity_Saturate_float(_BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1, _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1);
            float3 _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0 = float3(_Property_bbb7f63dc018f9828732f80495a95444_Out_0, _Property_48e1c5285b48c78e8af19e38f4bd77f9_Out_0, _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1);
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_R_1 = _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0[0];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_G_2 = _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0[1];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_B_3 = _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0[2];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_A_4 = 0;
            float _Property_006bb9304a39f5808cf13865f8c36ad4_Out_0 = _WetSmoothness;
            float _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3;
            Unity_Lerp_float(_Split_645358fc1f0e278fbfc2ccb5594c95e3_B_3, _Property_006bb9304a39f5808cf13865f8c36ad4_Out_0, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1, _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3);
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.BaseColor = _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            surface.NormalTS = _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Split_645358fc1f0e278fbfc2ccb5594c95e3_R_1;
            surface.Specular = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.Smoothness = _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3;
            surface.Occlusion = _Split_645358fc1f0e278fbfc2ccb5594c95e3_G_2;
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define USE_UNITY_CROSSFADE 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.color = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define USE_UNITY_CROSSFADE 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.color = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define USE_UNITY_CROSSFADE 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float3 AbsoluteWorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
        Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
        UnitySamplerState _Property_46d5a097541149fe957f85c1365643be_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_46d5a097541149fe957f85c1365643be_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, tangentTransform, true);
        }
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
        Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        float Unity_SimpleNoise_ValueNoise_LegacySine_float (float2 uv)
        {
        float2 i = floor(uv);
        float2 f = frac(uv);
        f = f * f * (3.0 - 2.0 * f);
        uv = abs(frac(uv) - 0.5);
        float2 c0 = i + float2(0.0, 0.0);
        float2 c1 = i + float2(1.0, 0.0);
        float2 c2 = i + float2(0.0, 1.0);
        float2 c3 = i + float2(1.0, 1.0);
        float r0; Hash_LegacySine_2_1_float(c0, r0);
        float r1; Hash_LegacySine_2_1_float(c1, r1);
        float r2; Hash_LegacySine_2_1_float(c2, r2);
        float r3; Hash_LegacySine_2_1_float(c3, r3);
        float bottomOfGrid = lerp(r0, r1, f.x);
        float topOfGrid = lerp(r2, r3, f.x);
        float t = lerp(bottomOfGrid, topOfGrid, f.y);
        return t;
        }
        
        void Unity_SimpleNoise_LegacySine_float(float2 UV, float Scale, out float Out)
        {
        float freq, amp;
        Out = 0.0f;
        freq = pow(2.0, float(0));
        amp = pow(0.5, float(3-0));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(1));
        amp = pow(0.5, float(3-1));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(2));
        amp = pow(0.5, float(3-2));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float
        {
        float3 WorldSpaceNormal;
        float3 AbsoluteWorldSpacePosition;
        };
        
        void SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(float Vector1_E4D1C13A, float Vector1_CBF4C304, Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float IN, out float XYZ_1)
        {
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float3 _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1);
        float _Split_742547a7039de986a646d04c157ae549_R_1 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[0];
        float _Split_742547a7039de986a646d04c157ae549_G_2 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[1];
        float _Split_742547a7039de986a646d04c157ae549_B_3 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[2];
        float _Split_742547a7039de986a646d04c157ae549_A_4 = 0;
        float2 _Vector2_40a8919e571ec18499de72022c155b38_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_G_2, 1);
        float2 _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2;
        Unity_Multiply_float2_float2((_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4.xy), _Vector2_40a8919e571ec18499de72022c155b38_Out_0, _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2);
        float _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0 = Vector1_CBF4C304;
        float _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_5fa32af59cdca88389832336b2268bd5_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2);
        float3 _Absolute_644b798714827680b39bf5d34f70385f_Out_1;
        Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_644b798714827680b39bf5d34f70385f_Out_1);
        float _Property_adc4c59482221c8aad681c6558728ac9_Out_0 = Vector1_E4D1C13A;
        float3 _Power_ee478822a04529849ae8df1636c29fe2_Out_2;
        Unity_Power_float3(_Absolute_644b798714827680b39bf5d34f70385f_Out_1, (_Property_adc4c59482221c8aad681c6558728ac9_Out_0.xxx), _Power_ee478822a04529849ae8df1636c29fe2_Out_2);
        float3 _Multiply_b386a937554d73828e437d126d69608b_Out_2;
        Unity_Multiply_float3_float3(_Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Multiply_b386a937554d73828e437d126d69608b_Out_2);
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[0];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[1];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[2];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_A_4 = 0;
        float _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2);
        float4 _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4;
        float3 _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5;
        float2 _Combine_192c2c4a69be588b90ca005a32e22552_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4, _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5, _Combine_192c2c4a69be588b90ca005a32e22552_RG_6);
        float _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2;
        Unity_Multiply_float_float(_Split_742547a7039de986a646d04c157ae549_B_3, -1, _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2);
        float2 _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0 = float2(_Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2, 1);
        float2 _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2;
        Unity_Multiply_float2_float2((_Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4.xy), _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0, _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2);
        float _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2);
        float _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2);
        float4 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4;
        float3 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5;
        float2 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_B_3, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6);
        float2 _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_R_1, 1);
        float2 _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2;
        Unity_Multiply_float2_float2((_Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4.xy), _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0, _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2);
        float _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2);
        float _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2);
        float _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2;
        Unity_Add_float(_Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2);
        float _Add_14295f72880e4b87a1baf1ced943ac40_Out_2;
        Unity_Add_float(_Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2, _Add_14295f72880e4b87a1baf1ced943ac40_Out_2);
        float _Add_e59af300bba2498db32eac1412123447_Out_2;
        Unity_Add_float(_Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Add_e59af300bba2498db32eac1412123447_Out_2);
        float _Add_e855069f047fae8ea9027d56acb61e56_Out_2;
        Unity_Add_float(_Add_e59af300bba2498db32eac1412123447_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Add_e855069f047fae8ea9027d56acb61e56_Out_2);
        float _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        Unity_Divide_float(_Add_14295f72880e4b87a1baf1ced943ac40_Out_2, _Add_e855069f047fae8ea9027d56acb61e56_Out_2, _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2);
        XYZ_1 = _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Contrast_float(float3 In, float Contrast, out float3 Out)
        {
            float midpoint = pow(0.5, 2.2);
            Out =  (In - midpoint) * Contrast + midpoint;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1 = _Property_256e5676e1089881ae3214634430b140_Out_0[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2 = _Property_256e5676e1089881ae3214634430b140_Out_0[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3 = _Property_256e5676e1089881ae3214634430b140_Out_0[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4 = _Property_256e5676e1089881ae3214634430b140_Out_0[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.tex, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.a;
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0 = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1 = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2 = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3 = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4 = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1, _Split_c4822b8eaff9b185be7c059792345712_G_2, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1);
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0 = _BaseUsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_11506852e45cbb8f9732aebed8bbb210;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.uv0 = IN.uv0;
            float4 _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_11506852e45cbb8f9732aebed8bbb210, _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0 = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2);
            UnityTexture2D _Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0 = UnityBuildTexture2DStructNoScale(_IceNoiseNormal);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.uv0 = IN.uv0;
            float4 _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc, _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2);
            float _Property_345c364a9e67bd878b47cfd40d450e2f_Out_0 = _NoiseNormalScale;
            float3 _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2.xyz), _Property_345c364a9e67bd878b47cfd40d450e2f_Out_0, _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2);
            float _Property_852d221028b884858f029fedb8de47d1_Out_0 = _IceNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_852d221028b884858f029fedb8de47d1_Out_0, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1);
            float _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1;
            Unity_Absolute_float(_TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1, _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1);
            float _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0 = _IceNoisePower;
            float _Power_1497f6299359e780a9aa8dde441d98cf_Out_2;
            Unity_Power_float(_Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1, _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0, _Power_1497f6299359e780a9aa8dde441d98cf_Out_2);
            float _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0 = _IceNoiseContrast;
            float3 _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2;
            Unity_Contrast_float((_Power_1497f6299359e780a9aa8dde441d98cf_Out_2.xxx), _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0, _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2);
            float _Split_f399eb1f3ad77580a75b6122d38451b5_R_1 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[0];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_G_2 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[1];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_B_3 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[2];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_A_4 = 0;
            float _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3;
            Unity_Clamp_float(_Split_f399eb1f3ad77580a75b6122d38451b5_R_1, 0, 1, _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3);
            float3 _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3;
            Unity_Lerp_float3(_NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2, _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xxx), _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2;
            Unity_NormalBlend_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0, _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2);
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.NormalTS = _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2;
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpacePosition = input.positionWS;
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float3 AbsoluteWorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
             float4 interp5 : INTERP5;
             float4 interp6 : INTERP6;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.texCoord1;
            output.interp5.xyzw =  input.texCoord2;
            output.interp6.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.texCoord1 = input.interp4.xyzw;
            output.texCoord2 = input.interp5.xyzw;
            output.color = input.interp6.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        #include "./NMParallaxLayers.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
        Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
        UnitySamplerState _Property_46d5a097541149fe957f85c1365643be_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_46d5a097541149fe957f85c1365643be_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, tangentTransform, true);
        }
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
        Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }
        
        float Unity_SimpleNoise_ValueNoise_LegacySine_float (float2 uv)
        {
        float2 i = floor(uv);
        float2 f = frac(uv);
        f = f * f * (3.0 - 2.0 * f);
        uv = abs(frac(uv) - 0.5);
        float2 c0 = i + float2(0.0, 0.0);
        float2 c1 = i + float2(1.0, 0.0);
        float2 c2 = i + float2(0.0, 1.0);
        float2 c3 = i + float2(1.0, 1.0);
        float r0; Hash_LegacySine_2_1_float(c0, r0);
        float r1; Hash_LegacySine_2_1_float(c1, r1);
        float r2; Hash_LegacySine_2_1_float(c2, r2);
        float r3; Hash_LegacySine_2_1_float(c3, r3);
        float bottomOfGrid = lerp(r0, r1, f.x);
        float topOfGrid = lerp(r2, r3, f.x);
        float t = lerp(bottomOfGrid, topOfGrid, f.y);
        return t;
        }
        
        void Unity_SimpleNoise_LegacySine_float(float2 UV, float Scale, out float Out)
        {
        float freq, amp;
        Out = 0.0f;
        freq = pow(2.0, float(0));
        amp = pow(0.5, float(3-0));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(1));
        amp = pow(0.5, float(3-1));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(2));
        amp = pow(0.5, float(3-2));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float
        {
        float3 WorldSpaceNormal;
        float3 AbsoluteWorldSpacePosition;
        };
        
        void SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(float Vector1_E4D1C13A, float Vector1_CBF4C304, Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float IN, out float XYZ_1)
        {
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float3 _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1);
        float _Split_742547a7039de986a646d04c157ae549_R_1 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[0];
        float _Split_742547a7039de986a646d04c157ae549_G_2 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[1];
        float _Split_742547a7039de986a646d04c157ae549_B_3 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[2];
        float _Split_742547a7039de986a646d04c157ae549_A_4 = 0;
        float2 _Vector2_40a8919e571ec18499de72022c155b38_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_G_2, 1);
        float2 _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2;
        Unity_Multiply_float2_float2((_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4.xy), _Vector2_40a8919e571ec18499de72022c155b38_Out_0, _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2);
        float _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0 = Vector1_CBF4C304;
        float _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_5fa32af59cdca88389832336b2268bd5_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2);
        float3 _Absolute_644b798714827680b39bf5d34f70385f_Out_1;
        Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_644b798714827680b39bf5d34f70385f_Out_1);
        float _Property_adc4c59482221c8aad681c6558728ac9_Out_0 = Vector1_E4D1C13A;
        float3 _Power_ee478822a04529849ae8df1636c29fe2_Out_2;
        Unity_Power_float3(_Absolute_644b798714827680b39bf5d34f70385f_Out_1, (_Property_adc4c59482221c8aad681c6558728ac9_Out_0.xxx), _Power_ee478822a04529849ae8df1636c29fe2_Out_2);
        float3 _Multiply_b386a937554d73828e437d126d69608b_Out_2;
        Unity_Multiply_float3_float3(_Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Multiply_b386a937554d73828e437d126d69608b_Out_2);
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[0];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[1];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[2];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_A_4 = 0;
        float _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2);
        float4 _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4;
        float3 _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5;
        float2 _Combine_192c2c4a69be588b90ca005a32e22552_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4, _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5, _Combine_192c2c4a69be588b90ca005a32e22552_RG_6);
        float _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2;
        Unity_Multiply_float_float(_Split_742547a7039de986a646d04c157ae549_B_3, -1, _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2);
        float2 _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0 = float2(_Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2, 1);
        float2 _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2;
        Unity_Multiply_float2_float2((_Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4.xy), _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0, _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2);
        float _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2);
        float _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2);
        float4 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4;
        float3 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5;
        float2 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_B_3, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6);
        float2 _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_R_1, 1);
        float2 _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2;
        Unity_Multiply_float2_float2((_Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4.xy), _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0, _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2);
        float _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2);
        float _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2);
        float _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2;
        Unity_Add_float(_Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2);
        float _Add_14295f72880e4b87a1baf1ced943ac40_Out_2;
        Unity_Add_float(_Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2, _Add_14295f72880e4b87a1baf1ced943ac40_Out_2);
        float _Add_e59af300bba2498db32eac1412123447_Out_2;
        Unity_Add_float(_Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Add_e59af300bba2498db32eac1412123447_Out_2);
        float _Add_e855069f047fae8ea9027d56acb61e56_Out_2;
        Unity_Add_float(_Add_e59af300bba2498db32eac1412123447_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Add_e855069f047fae8ea9027d56acb61e56_Out_2);
        float _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        Unity_Divide_float(_Add_14295f72880e4b87a1baf1ced943ac40_Out_2, _Add_e855069f047fae8ea9027d56acb61e56_Out_2, _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2);
        XYZ_1 = _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Contrast_float(float3 In, float Contrast, out float3 Out)
        {
            float midpoint = pow(0.5, 2.2);
            Out =  (In - midpoint) * Contrast + midpoint;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float2(float2 A, float2 B, float2 T, out float2 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        UnitySamplerState _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }
        
        struct Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float IN, out float4 XZ_2)
        {
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        XZ_2 = (float4(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3, 0.0, 1.0));
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float
        {
        };
        
        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float IN, out float3 OutVector4_1)
        {
        float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
        float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
        Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
        float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
        Unity_Multiply_float_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
        float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
        float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
        Unity_Multiply_float4_float4(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
        OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _Property_e5176656505ae98292b155cb230ab233_Out_0 = _IceDistortion;
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0 = _BaseUsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_11506852e45cbb8f9732aebed8bbb210;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.uv0 = IN.uv0;
            float4 _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_11506852e45cbb8f9732aebed8bbb210, _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2);
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_R_1 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[0];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[1];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_B_3 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[2];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_A_4 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[3];
            float4 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4;
            float3 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5;
            float2 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6;
            Unity_Combine_float(_Split_a108e1720257bf83ba61786c1ab1a0ca_R_1, _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2, 0, 0, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6);
            float2 _Multiply_9bed13a6994a89889288447a9152078b_Out_2;
            Unity_Multiply_float2_float2((_Property_e5176656505ae98292b155cb230ab233_Out_0.xx), _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6, _Multiply_9bed13a6994a89889288447a9152078b_Out_2);
            float _Property_8644e31610e05a84bfa06afd61d23967_Out_0 = _Ice_Noise_Distortion;
            UnityTexture2D _Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0 = UnityBuildTexture2DStructNoScale(_IceNoiseNormal);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.uv0 = IN.uv0;
            float4 _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc, _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2);
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_R_1 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[0];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[1];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_B_3 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[2];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_A_4 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[3];
            float4 _Combine_0980c1220518a788beef3792138b09bc_RGBA_4;
            float3 _Combine_0980c1220518a788beef3792138b09bc_RGB_5;
            float2 _Combine_0980c1220518a788beef3792138b09bc_RG_6;
            Unity_Combine_float(_Split_aea7e8f011b37b85bd67111f2c0722a7_R_1, _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2, 0, 0, _Combine_0980c1220518a788beef3792138b09bc_RGBA_4, _Combine_0980c1220518a788beef3792138b09bc_RGB_5, _Combine_0980c1220518a788beef3792138b09bc_RG_6);
            float2 _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2;
            Unity_Multiply_float2_float2((_Property_8644e31610e05a84bfa06afd61d23967_Out_0.xx), _Combine_0980c1220518a788beef3792138b09bc_RG_6, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2);
            float _Property_852d221028b884858f029fedb8de47d1_Out_0 = _IceNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_852d221028b884858f029fedb8de47d1_Out_0, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1);
            float _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1;
            Unity_Absolute_float(_TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1, _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1);
            float _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0 = _IceNoisePower;
            float _Power_1497f6299359e780a9aa8dde441d98cf_Out_2;
            Unity_Power_float(_Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1, _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0, _Power_1497f6299359e780a9aa8dde441d98cf_Out_2);
            float _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0 = _IceNoiseContrast;
            float3 _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2;
            Unity_Contrast_float((_Power_1497f6299359e780a9aa8dde441d98cf_Out_2.xxx), _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0, _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2);
            float _Split_f399eb1f3ad77580a75b6122d38451b5_R_1 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[0];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_G_2 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[1];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_B_3 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[2];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_A_4 = 0;
            float _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3;
            Unity_Clamp_float(_Split_f399eb1f3ad77580a75b6122d38451b5_R_1, 0, 1, _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3);
            float2 _Lerp_701142594e6c5786a700edb533ed6de3_Out_3;
            Unity_Lerp_float2(_Multiply_9bed13a6994a89889288447a9152078b_Out_2, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xx), _Lerp_701142594e6c5786a700edb533ed6de3_Out_3);
            float2 _Multiply_be4736503512af8d91df02fa276dcd77_Out_2;
            Unity_Multiply_float2_float2(_Lerp_701142594e6c5786a700edb533ed6de3_Out_3, (_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2);
            float2 _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2;
            Unity_Add_float2((_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2, _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2);
            float3 _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1;
            Unity_SceneColor_float((float4(_Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2, 0.0, 1.0)), _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1);
            float _Property_49f84d0718855d86902de5bbf5925223_Out_0 = _CleanColorPower;
            float3 _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2;
            Unity_Multiply_float3_float3(_SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1, (_Property_49f84d0718855d86902de5bbf5925223_Out_0.xxx), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2);
            float4 _Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0 = _DeepColor;
            float4 _Property_7094041d89afbd878cb83460f4ab68b8_Out_0 = _ShalowColor;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0 = _ShalowFalloffMultiply;
            float _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0, _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2);
            float _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1;
            Unity_Absolute_float(_Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2, _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1);
            float _Property_e6dd087698d3e984bd5eb642347af797_Out_0 = _ShalowFalloffPower;
            float _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2;
            Unity_Multiply_float_float(_Property_e6dd087698d3e984bd5eb642347af797_Out_0, -1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2);
            float _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2;
            Unity_Power_float(_Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2, _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2);
            float _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1;
            Unity_Saturate_float(_Power_aaf82c5db3291a8bb2095cce38670a92_Out_2, _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1);
            float _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3;
            Unity_Clamp_float(_Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1, 0, 1, _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3);
            float4 _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3;
            Unity_Lerp_float4(_Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0, _Property_7094041d89afbd878cb83460f4ab68b8_Out_0, (_Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3.xxxx), _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3);
            float3 _Multiply_175272476246508a97ee024c2aec0469_Out_2;
            Unity_Multiply_float3_float3((_Lerp_bff7238223fec786b08d9cf92a09754c_Out_3.xyz), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2);
            float _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0 = _CleanFalloffMultiply;
            float _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0, _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2);
            float _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3;
            Unity_Clamp_float(_Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2, 0, 1, _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3);
            float _Absolute_2efac825a986e28190f26200795ca9ec_Out_1;
            Unity_Absolute_float(_Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3, _Absolute_2efac825a986e28190f26200795ca9ec_Out_1);
            float _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0 = _CleanFalloffPower;
            float _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2;
            Unity_Power_float(_Absolute_2efac825a986e28190f26200795ca9ec_Out_1, _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0, _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2);
            float _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3;
            Unity_Clamp_float(_Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2, 0, 1, _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3);
            float3 _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3;
            Unity_Lerp_float3(_Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2, (_Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3.xxx), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3);
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_893a7c3932a452849a5239a91f337a35;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.uv0 = IN.uv0;
            float4 _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNM_893a7c3932a452849a5239a91f337a35, _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2);
            float _Property_771911a99405a780908dd542012af7b8_Out_0 = _IceParallaxSteps;
            Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.uv0 = IN.uv0;
            float4 _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2;
            SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(_Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2);
            float _Property_efee416de222038a93fa523171fb9f0d_Out_0 = _ParalaxOffset;
            float _Property_720bc7e00a412889a10ca999204543f8_Out_0 = _IceParallaxNoiseMin;
            float _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0 = _IceParallaxNoiseMax;
            float _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0 = _IceParallaxNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1);
            float _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3;
            Unity_Clamp_float(_TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1, 0, 1, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3);
            float _Lerp_87de925175c62a8986309dc80655ce2f_Out_3;
            Unity_Lerp_float(_Property_720bc7e00a412889a10ca999204543f8_Out_0, _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3);
            float _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3;
            Unity_Lerp_float(_Property_efee416de222038a93fa523171fb9f0d_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3);
            float _Property_acfd17e181f6108ba7921d3e04df886d_Out_0 = _IceDepth;
            float3 _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1 = TransformWorldToTangentDir(IN.WorldSpaceViewDirection.xyz, tangentTransform, true);
            }
            float _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0 = _ParallaxFalloff;
            float _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3;
            Unity_Lerp_float(_Property_eede9dad69eea580b2a3fdc05280f02f_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3);
            float4 _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2;
            ParallaxLayers_float(_Property_771911a99405a780908dd542012af7b8_Out_0, (_PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2.xy), _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3, _Property_acfd17e181f6108ba7921d3e04df886d_Out_0, _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1, IN.WorldSpaceViewDirection, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2);
            float4 _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2;
            Unity_Blend_Lighten_float4(_PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2, _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2;
            Unity_Multiply_float4_float4(_Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_41859d117584758eb8002ecc938f9bce_Out_0, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2);
            float3 _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3;
            Unity_Lerp_float3((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2.xyz), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xxx), _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1 = _Property_256e5676e1089881ae3214634430b140_Out_0[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2 = _Property_256e5676e1089881ae3214634430b140_Out_0[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3 = _Property_256e5676e1089881ae3214634430b140_Out_0[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4 = _Property_256e5676e1089881ae3214634430b140_Out_0[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.tex, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.a;
            float _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4, 2, _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2);
            float _Add_fd3efcae64779e848ef39919335cd44d_Out_2;
            Unity_Add_float(_Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2, -1, _Add_fd3efcae64779e848ef39919335cd44d_Out_2);
            float _Property_605f29777330a58ba88ac032e905433b_Out_0 = _DetailAlbedoScale;
            float _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2;
            Unity_Multiply_float_float(_Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Property_605f29777330a58ba88ac032e905433b_Out_0, _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2);
            float _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1;
            Unity_Saturate_float(_Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2, _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1);
            float _Absolute_8acef423205118879e75274a48969d34_Out_1;
            Unity_Absolute_float(_Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1, _Absolute_8acef423205118879e75274a48969d34_Out_1);
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185;
            float3 _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float((float4(_Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3, 1.0)), _Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Absolute_8acef423205118879e75274a48969d34_Out_1, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float3 _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3;
            Unity_Lerp_float3(_Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, (_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3.xxx), _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3);
            float4 _Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0 = _WetColor;
            float3 _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2;
            Unity_Multiply_float3_float3((_Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0.xyz), _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3;
            Unity_Clamp_float(_Split_5b2299b48b10138ea40c141b79bfe90e_R_1, 0, 1, _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3);
            float _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1;
            Unity_OneMinus_float(_Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1);
            float3 _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            Unity_Lerp_float3(_Lerp_7b0da7568070568992f16c8217ad84e6_Out_3, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2, (_OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1.xxx), _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3);
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.BaseColor = _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.color = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull [_Cull]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.color = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float3 AbsoluteWorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        #include "./NMParallaxLayers.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
        Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
        UnitySamplerState _Property_46d5a097541149fe957f85c1365643be_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_46d5a097541149fe957f85c1365643be_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, tangentTransform, true);
        }
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
        Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }
        
        float Unity_SimpleNoise_ValueNoise_LegacySine_float (float2 uv)
        {
        float2 i = floor(uv);
        float2 f = frac(uv);
        f = f * f * (3.0 - 2.0 * f);
        uv = abs(frac(uv) - 0.5);
        float2 c0 = i + float2(0.0, 0.0);
        float2 c1 = i + float2(1.0, 0.0);
        float2 c2 = i + float2(0.0, 1.0);
        float2 c3 = i + float2(1.0, 1.0);
        float r0; Hash_LegacySine_2_1_float(c0, r0);
        float r1; Hash_LegacySine_2_1_float(c1, r1);
        float r2; Hash_LegacySine_2_1_float(c2, r2);
        float r3; Hash_LegacySine_2_1_float(c3, r3);
        float bottomOfGrid = lerp(r0, r1, f.x);
        float topOfGrid = lerp(r2, r3, f.x);
        float t = lerp(bottomOfGrid, topOfGrid, f.y);
        return t;
        }
        
        void Unity_SimpleNoise_LegacySine_float(float2 UV, float Scale, out float Out)
        {
        float freq, amp;
        Out = 0.0f;
        freq = pow(2.0, float(0));
        amp = pow(0.5, float(3-0));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(1));
        amp = pow(0.5, float(3-1));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(2));
        amp = pow(0.5, float(3-2));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float
        {
        float3 WorldSpaceNormal;
        float3 AbsoluteWorldSpacePosition;
        };
        
        void SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(float Vector1_E4D1C13A, float Vector1_CBF4C304, Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float IN, out float XYZ_1)
        {
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float3 _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1);
        float _Split_742547a7039de986a646d04c157ae549_R_1 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[0];
        float _Split_742547a7039de986a646d04c157ae549_G_2 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[1];
        float _Split_742547a7039de986a646d04c157ae549_B_3 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[2];
        float _Split_742547a7039de986a646d04c157ae549_A_4 = 0;
        float2 _Vector2_40a8919e571ec18499de72022c155b38_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_G_2, 1);
        float2 _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2;
        Unity_Multiply_float2_float2((_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4.xy), _Vector2_40a8919e571ec18499de72022c155b38_Out_0, _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2);
        float _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0 = Vector1_CBF4C304;
        float _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_5fa32af59cdca88389832336b2268bd5_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2);
        float3 _Absolute_644b798714827680b39bf5d34f70385f_Out_1;
        Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_644b798714827680b39bf5d34f70385f_Out_1);
        float _Property_adc4c59482221c8aad681c6558728ac9_Out_0 = Vector1_E4D1C13A;
        float3 _Power_ee478822a04529849ae8df1636c29fe2_Out_2;
        Unity_Power_float3(_Absolute_644b798714827680b39bf5d34f70385f_Out_1, (_Property_adc4c59482221c8aad681c6558728ac9_Out_0.xxx), _Power_ee478822a04529849ae8df1636c29fe2_Out_2);
        float3 _Multiply_b386a937554d73828e437d126d69608b_Out_2;
        Unity_Multiply_float3_float3(_Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Multiply_b386a937554d73828e437d126d69608b_Out_2);
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[0];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[1];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[2];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_A_4 = 0;
        float _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2);
        float4 _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4;
        float3 _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5;
        float2 _Combine_192c2c4a69be588b90ca005a32e22552_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4, _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5, _Combine_192c2c4a69be588b90ca005a32e22552_RG_6);
        float _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2;
        Unity_Multiply_float_float(_Split_742547a7039de986a646d04c157ae549_B_3, -1, _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2);
        float2 _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0 = float2(_Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2, 1);
        float2 _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2;
        Unity_Multiply_float2_float2((_Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4.xy), _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0, _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2);
        float _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2);
        float _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2);
        float4 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4;
        float3 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5;
        float2 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_B_3, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6);
        float2 _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_R_1, 1);
        float2 _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2;
        Unity_Multiply_float2_float2((_Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4.xy), _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0, _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2);
        float _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2);
        float _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2);
        float _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2;
        Unity_Add_float(_Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2);
        float _Add_14295f72880e4b87a1baf1ced943ac40_Out_2;
        Unity_Add_float(_Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2, _Add_14295f72880e4b87a1baf1ced943ac40_Out_2);
        float _Add_e59af300bba2498db32eac1412123447_Out_2;
        Unity_Add_float(_Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Add_e59af300bba2498db32eac1412123447_Out_2);
        float _Add_e855069f047fae8ea9027d56acb61e56_Out_2;
        Unity_Add_float(_Add_e59af300bba2498db32eac1412123447_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Add_e855069f047fae8ea9027d56acb61e56_Out_2);
        float _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        Unity_Divide_float(_Add_14295f72880e4b87a1baf1ced943ac40_Out_2, _Add_e855069f047fae8ea9027d56acb61e56_Out_2, _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2);
        XYZ_1 = _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Contrast_float(float3 In, float Contrast, out float3 Out)
        {
            float midpoint = pow(0.5, 2.2);
            Out =  (In - midpoint) * Contrast + midpoint;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float2(float2 A, float2 B, float2 T, out float2 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        UnitySamplerState _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }
        
        struct Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float IN, out float4 XZ_2)
        {
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        XZ_2 = (float4(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3, 0.0, 1.0));
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float
        {
        };
        
        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float IN, out float3 OutVector4_1)
        {
        float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
        float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
        Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
        float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
        Unity_Multiply_float_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
        float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
        float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
        Unity_Multiply_float4_float4(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
        OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _Property_e5176656505ae98292b155cb230ab233_Out_0 = _IceDistortion;
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0 = _BaseUsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_11506852e45cbb8f9732aebed8bbb210;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.uv0 = IN.uv0;
            float4 _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_11506852e45cbb8f9732aebed8bbb210, _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2);
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_R_1 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[0];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[1];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_B_3 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[2];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_A_4 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[3];
            float4 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4;
            float3 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5;
            float2 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6;
            Unity_Combine_float(_Split_a108e1720257bf83ba61786c1ab1a0ca_R_1, _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2, 0, 0, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6);
            float2 _Multiply_9bed13a6994a89889288447a9152078b_Out_2;
            Unity_Multiply_float2_float2((_Property_e5176656505ae98292b155cb230ab233_Out_0.xx), _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6, _Multiply_9bed13a6994a89889288447a9152078b_Out_2);
            float _Property_8644e31610e05a84bfa06afd61d23967_Out_0 = _Ice_Noise_Distortion;
            UnityTexture2D _Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0 = UnityBuildTexture2DStructNoScale(_IceNoiseNormal);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.uv0 = IN.uv0;
            float4 _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc, _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2);
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_R_1 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[0];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[1];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_B_3 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[2];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_A_4 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[3];
            float4 _Combine_0980c1220518a788beef3792138b09bc_RGBA_4;
            float3 _Combine_0980c1220518a788beef3792138b09bc_RGB_5;
            float2 _Combine_0980c1220518a788beef3792138b09bc_RG_6;
            Unity_Combine_float(_Split_aea7e8f011b37b85bd67111f2c0722a7_R_1, _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2, 0, 0, _Combine_0980c1220518a788beef3792138b09bc_RGBA_4, _Combine_0980c1220518a788beef3792138b09bc_RGB_5, _Combine_0980c1220518a788beef3792138b09bc_RG_6);
            float2 _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2;
            Unity_Multiply_float2_float2((_Property_8644e31610e05a84bfa06afd61d23967_Out_0.xx), _Combine_0980c1220518a788beef3792138b09bc_RG_6, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2);
            float _Property_852d221028b884858f029fedb8de47d1_Out_0 = _IceNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_852d221028b884858f029fedb8de47d1_Out_0, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1);
            float _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1;
            Unity_Absolute_float(_TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1, _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1);
            float _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0 = _IceNoisePower;
            float _Power_1497f6299359e780a9aa8dde441d98cf_Out_2;
            Unity_Power_float(_Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1, _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0, _Power_1497f6299359e780a9aa8dde441d98cf_Out_2);
            float _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0 = _IceNoiseContrast;
            float3 _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2;
            Unity_Contrast_float((_Power_1497f6299359e780a9aa8dde441d98cf_Out_2.xxx), _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0, _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2);
            float _Split_f399eb1f3ad77580a75b6122d38451b5_R_1 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[0];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_G_2 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[1];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_B_3 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[2];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_A_4 = 0;
            float _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3;
            Unity_Clamp_float(_Split_f399eb1f3ad77580a75b6122d38451b5_R_1, 0, 1, _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3);
            float2 _Lerp_701142594e6c5786a700edb533ed6de3_Out_3;
            Unity_Lerp_float2(_Multiply_9bed13a6994a89889288447a9152078b_Out_2, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xx), _Lerp_701142594e6c5786a700edb533ed6de3_Out_3);
            float2 _Multiply_be4736503512af8d91df02fa276dcd77_Out_2;
            Unity_Multiply_float2_float2(_Lerp_701142594e6c5786a700edb533ed6de3_Out_3, (_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2);
            float2 _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2;
            Unity_Add_float2((_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2, _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2);
            float3 _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1;
            Unity_SceneColor_float((float4(_Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2, 0.0, 1.0)), _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1);
            float _Property_49f84d0718855d86902de5bbf5925223_Out_0 = _CleanColorPower;
            float3 _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2;
            Unity_Multiply_float3_float3(_SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1, (_Property_49f84d0718855d86902de5bbf5925223_Out_0.xxx), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2);
            float4 _Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0 = _DeepColor;
            float4 _Property_7094041d89afbd878cb83460f4ab68b8_Out_0 = _ShalowColor;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0 = _ShalowFalloffMultiply;
            float _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0, _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2);
            float _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1;
            Unity_Absolute_float(_Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2, _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1);
            float _Property_e6dd087698d3e984bd5eb642347af797_Out_0 = _ShalowFalloffPower;
            float _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2;
            Unity_Multiply_float_float(_Property_e6dd087698d3e984bd5eb642347af797_Out_0, -1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2);
            float _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2;
            Unity_Power_float(_Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2, _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2);
            float _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1;
            Unity_Saturate_float(_Power_aaf82c5db3291a8bb2095cce38670a92_Out_2, _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1);
            float _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3;
            Unity_Clamp_float(_Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1, 0, 1, _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3);
            float4 _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3;
            Unity_Lerp_float4(_Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0, _Property_7094041d89afbd878cb83460f4ab68b8_Out_0, (_Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3.xxxx), _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3);
            float3 _Multiply_175272476246508a97ee024c2aec0469_Out_2;
            Unity_Multiply_float3_float3((_Lerp_bff7238223fec786b08d9cf92a09754c_Out_3.xyz), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2);
            float _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0 = _CleanFalloffMultiply;
            float _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0, _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2);
            float _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3;
            Unity_Clamp_float(_Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2, 0, 1, _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3);
            float _Absolute_2efac825a986e28190f26200795ca9ec_Out_1;
            Unity_Absolute_float(_Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3, _Absolute_2efac825a986e28190f26200795ca9ec_Out_1);
            float _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0 = _CleanFalloffPower;
            float _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2;
            Unity_Power_float(_Absolute_2efac825a986e28190f26200795ca9ec_Out_1, _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0, _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2);
            float _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3;
            Unity_Clamp_float(_Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2, 0, 1, _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3);
            float3 _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3;
            Unity_Lerp_float3(_Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2, (_Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3.xxx), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3);
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_893a7c3932a452849a5239a91f337a35;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.uv0 = IN.uv0;
            float4 _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNM_893a7c3932a452849a5239a91f337a35, _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2);
            float _Property_771911a99405a780908dd542012af7b8_Out_0 = _IceParallaxSteps;
            Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.uv0 = IN.uv0;
            float4 _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2;
            SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(_Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2);
            float _Property_efee416de222038a93fa523171fb9f0d_Out_0 = _ParalaxOffset;
            float _Property_720bc7e00a412889a10ca999204543f8_Out_0 = _IceParallaxNoiseMin;
            float _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0 = _IceParallaxNoiseMax;
            float _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0 = _IceParallaxNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1);
            float _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3;
            Unity_Clamp_float(_TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1, 0, 1, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3);
            float _Lerp_87de925175c62a8986309dc80655ce2f_Out_3;
            Unity_Lerp_float(_Property_720bc7e00a412889a10ca999204543f8_Out_0, _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3);
            float _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3;
            Unity_Lerp_float(_Property_efee416de222038a93fa523171fb9f0d_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3);
            float _Property_acfd17e181f6108ba7921d3e04df886d_Out_0 = _IceDepth;
            float3 _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1 = TransformWorldToTangentDir(IN.WorldSpaceViewDirection.xyz, tangentTransform, true);
            }
            float _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0 = _ParallaxFalloff;
            float _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3;
            Unity_Lerp_float(_Property_eede9dad69eea580b2a3fdc05280f02f_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3);
            float4 _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2;
            ParallaxLayers_float(_Property_771911a99405a780908dd542012af7b8_Out_0, (_PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2.xy), _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3, _Property_acfd17e181f6108ba7921d3e04df886d_Out_0, _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1, IN.WorldSpaceViewDirection, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2);
            float4 _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2;
            Unity_Blend_Lighten_float4(_PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2, _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2;
            Unity_Multiply_float4_float4(_Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_41859d117584758eb8002ecc938f9bce_Out_0, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2);
            float3 _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3;
            Unity_Lerp_float3((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2.xyz), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xxx), _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1 = _Property_256e5676e1089881ae3214634430b140_Out_0[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2 = _Property_256e5676e1089881ae3214634430b140_Out_0[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3 = _Property_256e5676e1089881ae3214634430b140_Out_0[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4 = _Property_256e5676e1089881ae3214634430b140_Out_0[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.tex, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.a;
            float _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4, 2, _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2);
            float _Add_fd3efcae64779e848ef39919335cd44d_Out_2;
            Unity_Add_float(_Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2, -1, _Add_fd3efcae64779e848ef39919335cd44d_Out_2);
            float _Property_605f29777330a58ba88ac032e905433b_Out_0 = _DetailAlbedoScale;
            float _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2;
            Unity_Multiply_float_float(_Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Property_605f29777330a58ba88ac032e905433b_Out_0, _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2);
            float _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1;
            Unity_Saturate_float(_Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2, _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1);
            float _Absolute_8acef423205118879e75274a48969d34_Out_1;
            Unity_Absolute_float(_Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1, _Absolute_8acef423205118879e75274a48969d34_Out_1);
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185;
            float3 _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float((float4(_Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3, 1.0)), _Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Absolute_8acef423205118879e75274a48969d34_Out_1, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float3 _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3;
            Unity_Lerp_float3(_Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, (_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3.xxx), _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3);
            float4 _Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0 = _WetColor;
            float3 _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2;
            Unity_Multiply_float3_float3((_Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0.xyz), _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3;
            Unity_Clamp_float(_Split_5b2299b48b10138ea40c141b79bfe90e_R_1, 0, 1, _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3);
            float _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1;
            Unity_OneMinus_float(_Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1);
            float3 _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            Unity_Lerp_float3(_Lerp_7b0da7568070568992f16c8217ad84e6_Out_3, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2, (_OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1.xxx), _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3);
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.BaseColor = _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        

        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma target 3.5 DOTS_INSTANCING_ON
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _FORWARD_PLUS
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        #pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define USE_UNITY_CROSSFADE 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float3 AbsoluteWorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        #include "./NMParallaxLayers.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
        Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
        UnitySamplerState _Property_46d5a097541149fe957f85c1365643be_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_46d5a097541149fe957f85c1365643be_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, tangentTransform, true);
        }
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
        Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }
        
        float Unity_SimpleNoise_ValueNoise_LegacySine_float (float2 uv)
        {
        float2 i = floor(uv);
        float2 f = frac(uv);
        f = f * f * (3.0 - 2.0 * f);
        uv = abs(frac(uv) - 0.5);
        float2 c0 = i + float2(0.0, 0.0);
        float2 c1 = i + float2(1.0, 0.0);
        float2 c2 = i + float2(0.0, 1.0);
        float2 c3 = i + float2(1.0, 1.0);
        float r0; Hash_LegacySine_2_1_float(c0, r0);
        float r1; Hash_LegacySine_2_1_float(c1, r1);
        float r2; Hash_LegacySine_2_1_float(c2, r2);
        float r3; Hash_LegacySine_2_1_float(c3, r3);
        float bottomOfGrid = lerp(r0, r1, f.x);
        float topOfGrid = lerp(r2, r3, f.x);
        float t = lerp(bottomOfGrid, topOfGrid, f.y);
        return t;
        }
        
        void Unity_SimpleNoise_LegacySine_float(float2 UV, float Scale, out float Out)
        {
        float freq, amp;
        Out = 0.0f;
        freq = pow(2.0, float(0));
        amp = pow(0.5, float(3-0));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(1));
        amp = pow(0.5, float(3-1));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(2));
        amp = pow(0.5, float(3-2));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float
        {
        float3 WorldSpaceNormal;
        float3 AbsoluteWorldSpacePosition;
        };
        
        void SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(float Vector1_E4D1C13A, float Vector1_CBF4C304, Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float IN, out float XYZ_1)
        {
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float3 _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1);
        float _Split_742547a7039de986a646d04c157ae549_R_1 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[0];
        float _Split_742547a7039de986a646d04c157ae549_G_2 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[1];
        float _Split_742547a7039de986a646d04c157ae549_B_3 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[2];
        float _Split_742547a7039de986a646d04c157ae549_A_4 = 0;
        float2 _Vector2_40a8919e571ec18499de72022c155b38_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_G_2, 1);
        float2 _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2;
        Unity_Multiply_float2_float2((_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4.xy), _Vector2_40a8919e571ec18499de72022c155b38_Out_0, _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2);
        float _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0 = Vector1_CBF4C304;
        float _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_5fa32af59cdca88389832336b2268bd5_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2);
        float3 _Absolute_644b798714827680b39bf5d34f70385f_Out_1;
        Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_644b798714827680b39bf5d34f70385f_Out_1);
        float _Property_adc4c59482221c8aad681c6558728ac9_Out_0 = Vector1_E4D1C13A;
        float3 _Power_ee478822a04529849ae8df1636c29fe2_Out_2;
        Unity_Power_float3(_Absolute_644b798714827680b39bf5d34f70385f_Out_1, (_Property_adc4c59482221c8aad681c6558728ac9_Out_0.xxx), _Power_ee478822a04529849ae8df1636c29fe2_Out_2);
        float3 _Multiply_b386a937554d73828e437d126d69608b_Out_2;
        Unity_Multiply_float3_float3(_Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Multiply_b386a937554d73828e437d126d69608b_Out_2);
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[0];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[1];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[2];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_A_4 = 0;
        float _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2);
        float4 _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4;
        float3 _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5;
        float2 _Combine_192c2c4a69be588b90ca005a32e22552_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4, _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5, _Combine_192c2c4a69be588b90ca005a32e22552_RG_6);
        float _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2;
        Unity_Multiply_float_float(_Split_742547a7039de986a646d04c157ae549_B_3, -1, _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2);
        float2 _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0 = float2(_Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2, 1);
        float2 _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2;
        Unity_Multiply_float2_float2((_Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4.xy), _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0, _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2);
        float _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2);
        float _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2);
        float4 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4;
        float3 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5;
        float2 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_B_3, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6);
        float2 _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_R_1, 1);
        float2 _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2;
        Unity_Multiply_float2_float2((_Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4.xy), _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0, _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2);
        float _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2);
        float _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2);
        float _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2;
        Unity_Add_float(_Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2);
        float _Add_14295f72880e4b87a1baf1ced943ac40_Out_2;
        Unity_Add_float(_Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2, _Add_14295f72880e4b87a1baf1ced943ac40_Out_2);
        float _Add_e59af300bba2498db32eac1412123447_Out_2;
        Unity_Add_float(_Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Add_e59af300bba2498db32eac1412123447_Out_2);
        float _Add_e855069f047fae8ea9027d56acb61e56_Out_2;
        Unity_Add_float(_Add_e59af300bba2498db32eac1412123447_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Add_e855069f047fae8ea9027d56acb61e56_Out_2);
        float _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        Unity_Divide_float(_Add_14295f72880e4b87a1baf1ced943ac40_Out_2, _Add_e855069f047fae8ea9027d56acb61e56_Out_2, _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2);
        XYZ_1 = _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Contrast_float(float3 In, float Contrast, out float3 Out)
        {
            float midpoint = pow(0.5, 2.2);
            Out =  (In - midpoint) * Contrast + midpoint;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float2(float2 A, float2 B, float2 T, out float2 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        UnitySamplerState _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }
        
        struct Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float IN, out float4 XZ_2)
        {
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        XZ_2 = (float4(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3, 0.0, 1.0));
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float
        {
        };
        
        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float IN, out float3 OutVector4_1)
        {
        float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
        float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
        Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
        float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
        Unity_Multiply_float_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
        float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
        float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
        Unity_Multiply_float4_float4(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
        OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        struct Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float
        {
        };
        
        void SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(float Vector1_32317166, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float IN, out float SmoothnessOverlay_1)
        {
        float _Property_728cc50521e9e988ac9cbff4872d5139_Out_0 = Vector1_32317166;
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
        float _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        Unity_Lerp_float(_Property_728cc50521e9e988ac9cbff4872d5139_Out_0, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
        SmoothnessOverlay_1 = _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _Property_e5176656505ae98292b155cb230ab233_Out_0 = _IceDistortion;
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0 = _BaseUsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_11506852e45cbb8f9732aebed8bbb210;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.uv0 = IN.uv0;
            float4 _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_11506852e45cbb8f9732aebed8bbb210, _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2);
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_R_1 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[0];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[1];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_B_3 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[2];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_A_4 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[3];
            float4 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4;
            float3 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5;
            float2 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6;
            Unity_Combine_float(_Split_a108e1720257bf83ba61786c1ab1a0ca_R_1, _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2, 0, 0, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6);
            float2 _Multiply_9bed13a6994a89889288447a9152078b_Out_2;
            Unity_Multiply_float2_float2((_Property_e5176656505ae98292b155cb230ab233_Out_0.xx), _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6, _Multiply_9bed13a6994a89889288447a9152078b_Out_2);
            float _Property_8644e31610e05a84bfa06afd61d23967_Out_0 = _Ice_Noise_Distortion;
            UnityTexture2D _Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0 = UnityBuildTexture2DStructNoScale(_IceNoiseNormal);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.uv0 = IN.uv0;
            float4 _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc, _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2);
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_R_1 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[0];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[1];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_B_3 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[2];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_A_4 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[3];
            float4 _Combine_0980c1220518a788beef3792138b09bc_RGBA_4;
            float3 _Combine_0980c1220518a788beef3792138b09bc_RGB_5;
            float2 _Combine_0980c1220518a788beef3792138b09bc_RG_6;
            Unity_Combine_float(_Split_aea7e8f011b37b85bd67111f2c0722a7_R_1, _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2, 0, 0, _Combine_0980c1220518a788beef3792138b09bc_RGBA_4, _Combine_0980c1220518a788beef3792138b09bc_RGB_5, _Combine_0980c1220518a788beef3792138b09bc_RG_6);
            float2 _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2;
            Unity_Multiply_float2_float2((_Property_8644e31610e05a84bfa06afd61d23967_Out_0.xx), _Combine_0980c1220518a788beef3792138b09bc_RG_6, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2);
            float _Property_852d221028b884858f029fedb8de47d1_Out_0 = _IceNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_852d221028b884858f029fedb8de47d1_Out_0, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1);
            float _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1;
            Unity_Absolute_float(_TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1, _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1);
            float _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0 = _IceNoisePower;
            float _Power_1497f6299359e780a9aa8dde441d98cf_Out_2;
            Unity_Power_float(_Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1, _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0, _Power_1497f6299359e780a9aa8dde441d98cf_Out_2);
            float _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0 = _IceNoiseContrast;
            float3 _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2;
            Unity_Contrast_float((_Power_1497f6299359e780a9aa8dde441d98cf_Out_2.xxx), _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0, _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2);
            float _Split_f399eb1f3ad77580a75b6122d38451b5_R_1 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[0];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_G_2 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[1];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_B_3 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[2];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_A_4 = 0;
            float _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3;
            Unity_Clamp_float(_Split_f399eb1f3ad77580a75b6122d38451b5_R_1, 0, 1, _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3);
            float2 _Lerp_701142594e6c5786a700edb533ed6de3_Out_3;
            Unity_Lerp_float2(_Multiply_9bed13a6994a89889288447a9152078b_Out_2, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xx), _Lerp_701142594e6c5786a700edb533ed6de3_Out_3);
            float2 _Multiply_be4736503512af8d91df02fa276dcd77_Out_2;
            Unity_Multiply_float2_float2(_Lerp_701142594e6c5786a700edb533ed6de3_Out_3, (_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2);
            float2 _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2;
            Unity_Add_float2((_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2, _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2);
            float3 _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1;
            Unity_SceneColor_float((float4(_Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2, 0.0, 1.0)), _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1);
            float _Property_49f84d0718855d86902de5bbf5925223_Out_0 = _CleanColorPower;
            float3 _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2;
            Unity_Multiply_float3_float3(_SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1, (_Property_49f84d0718855d86902de5bbf5925223_Out_0.xxx), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2);
            float4 _Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0 = _DeepColor;
            float4 _Property_7094041d89afbd878cb83460f4ab68b8_Out_0 = _ShalowColor;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0 = _ShalowFalloffMultiply;
            float _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0, _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2);
            float _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1;
            Unity_Absolute_float(_Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2, _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1);
            float _Property_e6dd087698d3e984bd5eb642347af797_Out_0 = _ShalowFalloffPower;
            float _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2;
            Unity_Multiply_float_float(_Property_e6dd087698d3e984bd5eb642347af797_Out_0, -1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2);
            float _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2;
            Unity_Power_float(_Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2, _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2);
            float _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1;
            Unity_Saturate_float(_Power_aaf82c5db3291a8bb2095cce38670a92_Out_2, _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1);
            float _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3;
            Unity_Clamp_float(_Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1, 0, 1, _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3);
            float4 _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3;
            Unity_Lerp_float4(_Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0, _Property_7094041d89afbd878cb83460f4ab68b8_Out_0, (_Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3.xxxx), _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3);
            float3 _Multiply_175272476246508a97ee024c2aec0469_Out_2;
            Unity_Multiply_float3_float3((_Lerp_bff7238223fec786b08d9cf92a09754c_Out_3.xyz), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2);
            float _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0 = _CleanFalloffMultiply;
            float _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0, _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2);
            float _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3;
            Unity_Clamp_float(_Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2, 0, 1, _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3);
            float _Absolute_2efac825a986e28190f26200795ca9ec_Out_1;
            Unity_Absolute_float(_Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3, _Absolute_2efac825a986e28190f26200795ca9ec_Out_1);
            float _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0 = _CleanFalloffPower;
            float _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2;
            Unity_Power_float(_Absolute_2efac825a986e28190f26200795ca9ec_Out_1, _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0, _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2);
            float _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3;
            Unity_Clamp_float(_Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2, 0, 1, _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3);
            float3 _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3;
            Unity_Lerp_float3(_Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2, (_Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3.xxx), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3);
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_893a7c3932a452849a5239a91f337a35;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.uv0 = IN.uv0;
            float4 _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNM_893a7c3932a452849a5239a91f337a35, _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2);
            float _Property_771911a99405a780908dd542012af7b8_Out_0 = _IceParallaxSteps;
            Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.uv0 = IN.uv0;
            float4 _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2;
            SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(_Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2);
            float _Property_efee416de222038a93fa523171fb9f0d_Out_0 = _ParalaxOffset;
            float _Property_720bc7e00a412889a10ca999204543f8_Out_0 = _IceParallaxNoiseMin;
            float _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0 = _IceParallaxNoiseMax;
            float _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0 = _IceParallaxNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1);
            float _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3;
            Unity_Clamp_float(_TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1, 0, 1, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3);
            float _Lerp_87de925175c62a8986309dc80655ce2f_Out_3;
            Unity_Lerp_float(_Property_720bc7e00a412889a10ca999204543f8_Out_0, _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3);
            float _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3;
            Unity_Lerp_float(_Property_efee416de222038a93fa523171fb9f0d_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3);
            float _Property_acfd17e181f6108ba7921d3e04df886d_Out_0 = _IceDepth;
            float3 _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1 = TransformWorldToTangentDir(IN.WorldSpaceViewDirection.xyz, tangentTransform, true);
            }
            float _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0 = _ParallaxFalloff;
            float _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3;
            Unity_Lerp_float(_Property_eede9dad69eea580b2a3fdc05280f02f_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3);
            float4 _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2;
            ParallaxLayers_float(_Property_771911a99405a780908dd542012af7b8_Out_0, (_PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2.xy), _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3, _Property_acfd17e181f6108ba7921d3e04df886d_Out_0, _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1, IN.WorldSpaceViewDirection, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2);
            float4 _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2;
            Unity_Blend_Lighten_float4(_PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2, _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2;
            Unity_Multiply_float4_float4(_Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_41859d117584758eb8002ecc938f9bce_Out_0, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2);
            float3 _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3;
            Unity_Lerp_float3((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2.xyz), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xxx), _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1 = _Property_256e5676e1089881ae3214634430b140_Out_0[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2 = _Property_256e5676e1089881ae3214634430b140_Out_0[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3 = _Property_256e5676e1089881ae3214634430b140_Out_0[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4 = _Property_256e5676e1089881ae3214634430b140_Out_0[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.tex, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.a;
            float _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4, 2, _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2);
            float _Add_fd3efcae64779e848ef39919335cd44d_Out_2;
            Unity_Add_float(_Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2, -1, _Add_fd3efcae64779e848ef39919335cd44d_Out_2);
            float _Property_605f29777330a58ba88ac032e905433b_Out_0 = _DetailAlbedoScale;
            float _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2;
            Unity_Multiply_float_float(_Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Property_605f29777330a58ba88ac032e905433b_Out_0, _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2);
            float _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1;
            Unity_Saturate_float(_Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2, _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1);
            float _Absolute_8acef423205118879e75274a48969d34_Out_1;
            Unity_Absolute_float(_Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1, _Absolute_8acef423205118879e75274a48969d34_Out_1);
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185;
            float3 _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float((float4(_Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3, 1.0)), _Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Absolute_8acef423205118879e75274a48969d34_Out_1, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float3 _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3;
            Unity_Lerp_float3(_Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, (_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3.xxx), _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3);
            float4 _Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0 = _WetColor;
            float3 _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2;
            Unity_Multiply_float3_float3((_Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0.xyz), _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3;
            Unity_Clamp_float(_Split_5b2299b48b10138ea40c141b79bfe90e_R_1, 0, 1, _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3);
            float _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1;
            Unity_OneMinus_float(_Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1);
            float3 _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            Unity_Lerp_float3(_Lerp_7b0da7568070568992f16c8217ad84e6_Out_3, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2, (_OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1.xxx), _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3);
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0 = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1 = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2 = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3 = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4 = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1, _Split_c4822b8eaff9b185be7c059792345712_G_2, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0 = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2);
            float _Property_345c364a9e67bd878b47cfd40d450e2f_Out_0 = _NoiseNormalScale;
            float3 _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2.xyz), _Property_345c364a9e67bd878b47cfd40d450e2f_Out_0, _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2);
            float3 _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3;
            Unity_Lerp_float3(_NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2, _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xxx), _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2;
            Unity_NormalBlend_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0, _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2);
            float _Property_bbb7f63dc018f9828732f80495a95444_Out_0 = _BaseMetallic;
            float _Property_48e1c5285b48c78e8af19e38f4bd77f9_Out_0 = _BaseAO;
            float _Property_0edea7916ed7a189a62b0faf2c274601_Out_0 = _IceSmoothness;
            float _Property_1a0bf713a75e068aacef13a95a7ea011_Out_0 = _IceCrackSmoothness;
            UnityTexture2D _Property_be61fb085f680285bb171ac957c1d150_Out_0 = UnityBuildTexture2DStructNoScale(_ParalaxMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c;
            _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c.uv0 = IN.uv0;
            float4 _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_be61fb085f680285bb171ac957c1d150_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c, _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2);
            float _Split_e8121381f96e2f80a65ed1fb8ebd6974_R_1 = _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2[0];
            float _Split_e8121381f96e2f80a65ed1fb8ebd6974_G_2 = _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2[1];
            float _Split_e8121381f96e2f80a65ed1fb8ebd6974_B_3 = _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2[2];
            float _Split_e8121381f96e2f80a65ed1fb8ebd6974_A_4 = _PlanarNM_8bdaac0074d41786b1f86fefb4295b3c_XZ_2[3];
            float _Lerp_99e1105aeec5c981bdda0260115c2cfa_Out_3;
            Unity_Lerp_float(_Property_0edea7916ed7a189a62b0faf2c274601_Out_0, _Property_1a0bf713a75e068aacef13a95a7ea011_Out_0, _Split_e8121381f96e2f80a65ed1fb8ebd6974_R_1, _Lerp_99e1105aeec5c981bdda0260115c2cfa_Out_3);
            float _Property_04fa33e60ce3e38aa158980eac5a1bba_Out_0 = _IceNoiseSmoothness;
            float _Lerp_0f76c7b660a9f98c931ff1c5f1662281_Out_3;
            Unity_Lerp_float(_Lerp_99e1105aeec5c981bdda0260115c2cfa_Out_3, _Property_04fa33e60ce3e38aa158980eac5a1bba_Out_0, _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3, _Lerp_0f76c7b660a9f98c931ff1c5f1662281_Out_3);
            float _Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6, 2, _Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2);
            float _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2;
            Unity_Add_float(_Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2, -1, _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2);
            float _Property_cea4e47b293a988a83643b43f76c92ba_Out_0 = _DetailSmoothnessScale;
            float _Multiply_2008466558f0e4819e60b3c41d94487c_Out_2;
            Unity_Multiply_float_float(_Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2, _Property_cea4e47b293a988a83643b43f76c92ba_Out_0, _Multiply_2008466558f0e4819e60b3c41d94487c_Out_2);
            float _Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1;
            Unity_Saturate_float(_Multiply_2008466558f0e4819e60b3c41d94487c_Out_2, _Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1);
            float _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1;
            Unity_Absolute_float(_Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1, _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1);
            Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43;
            float _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1;
            SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(_Lerp_0f76c7b660a9f98c931ff1c5f1662281_Out_3, _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2, _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1, _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43, _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1);
            float _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1;
            Unity_Saturate_float(_BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1, _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1);
            float3 _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0 = float3(_Property_bbb7f63dc018f9828732f80495a95444_Out_0, _Property_48e1c5285b48c78e8af19e38f4bd77f9_Out_0, _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1);
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_R_1 = _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0[0];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_G_2 = _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0[1];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_B_3 = _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0[2];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_A_4 = 0;
            float _Property_006bb9304a39f5808cf13865f8c36ad4_Out_0 = _WetSmoothness;
            float _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3;
            Unity_Lerp_float(_Split_645358fc1f0e278fbfc2ccb5594c95e3_B_3, _Property_006bb9304a39f5808cf13865f8c36ad4_Out_0, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1, _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3);
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.BaseColor = _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            surface.NormalTS = _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Split_645358fc1f0e278fbfc2ccb5594c95e3_R_1;
            surface.Specular = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.Smoothness = _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3;
            surface.Occlusion = _Split_645358fc1f0e278fbfc2ccb5594c95e3_G_2;
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma target 3.5 DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define USE_UNITY_CROSSFADE 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.color = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma target 3.5 DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define USE_UNITY_CROSSFADE 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.color = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma target 3.5 DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define USE_UNITY_CROSSFADE 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float3 AbsoluteWorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
        Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
        UnitySamplerState _Property_46d5a097541149fe957f85c1365643be_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_46d5a097541149fe957f85c1365643be_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, tangentTransform, true);
        }
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
        Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        float Unity_SimpleNoise_ValueNoise_LegacySine_float (float2 uv)
        {
        float2 i = floor(uv);
        float2 f = frac(uv);
        f = f * f * (3.0 - 2.0 * f);
        uv = abs(frac(uv) - 0.5);
        float2 c0 = i + float2(0.0, 0.0);
        float2 c1 = i + float2(1.0, 0.0);
        float2 c2 = i + float2(0.0, 1.0);
        float2 c3 = i + float2(1.0, 1.0);
        float r0; Hash_LegacySine_2_1_float(c0, r0);
        float r1; Hash_LegacySine_2_1_float(c1, r1);
        float r2; Hash_LegacySine_2_1_float(c2, r2);
        float r3; Hash_LegacySine_2_1_float(c3, r3);
        float bottomOfGrid = lerp(r0, r1, f.x);
        float topOfGrid = lerp(r2, r3, f.x);
        float t = lerp(bottomOfGrid, topOfGrid, f.y);
        return t;
        }
        
        void Unity_SimpleNoise_LegacySine_float(float2 UV, float Scale, out float Out)
        {
        float freq, amp;
        Out = 0.0f;
        freq = pow(2.0, float(0));
        amp = pow(0.5, float(3-0));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(1));
        amp = pow(0.5, float(3-1));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(2));
        amp = pow(0.5, float(3-2));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float
        {
        float3 WorldSpaceNormal;
        float3 AbsoluteWorldSpacePosition;
        };
        
        void SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(float Vector1_E4D1C13A, float Vector1_CBF4C304, Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float IN, out float XYZ_1)
        {
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float3 _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1);
        float _Split_742547a7039de986a646d04c157ae549_R_1 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[0];
        float _Split_742547a7039de986a646d04c157ae549_G_2 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[1];
        float _Split_742547a7039de986a646d04c157ae549_B_3 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[2];
        float _Split_742547a7039de986a646d04c157ae549_A_4 = 0;
        float2 _Vector2_40a8919e571ec18499de72022c155b38_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_G_2, 1);
        float2 _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2;
        Unity_Multiply_float2_float2((_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4.xy), _Vector2_40a8919e571ec18499de72022c155b38_Out_0, _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2);
        float _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0 = Vector1_CBF4C304;
        float _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_5fa32af59cdca88389832336b2268bd5_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2);
        float3 _Absolute_644b798714827680b39bf5d34f70385f_Out_1;
        Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_644b798714827680b39bf5d34f70385f_Out_1);
        float _Property_adc4c59482221c8aad681c6558728ac9_Out_0 = Vector1_E4D1C13A;
        float3 _Power_ee478822a04529849ae8df1636c29fe2_Out_2;
        Unity_Power_float3(_Absolute_644b798714827680b39bf5d34f70385f_Out_1, (_Property_adc4c59482221c8aad681c6558728ac9_Out_0.xxx), _Power_ee478822a04529849ae8df1636c29fe2_Out_2);
        float3 _Multiply_b386a937554d73828e437d126d69608b_Out_2;
        Unity_Multiply_float3_float3(_Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Multiply_b386a937554d73828e437d126d69608b_Out_2);
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[0];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[1];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[2];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_A_4 = 0;
        float _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2);
        float4 _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4;
        float3 _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5;
        float2 _Combine_192c2c4a69be588b90ca005a32e22552_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4, _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5, _Combine_192c2c4a69be588b90ca005a32e22552_RG_6);
        float _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2;
        Unity_Multiply_float_float(_Split_742547a7039de986a646d04c157ae549_B_3, -1, _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2);
        float2 _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0 = float2(_Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2, 1);
        float2 _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2;
        Unity_Multiply_float2_float2((_Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4.xy), _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0, _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2);
        float _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2);
        float _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2);
        float4 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4;
        float3 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5;
        float2 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_B_3, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6);
        float2 _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_R_1, 1);
        float2 _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2;
        Unity_Multiply_float2_float2((_Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4.xy), _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0, _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2);
        float _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2);
        float _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2);
        float _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2;
        Unity_Add_float(_Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2);
        float _Add_14295f72880e4b87a1baf1ced943ac40_Out_2;
        Unity_Add_float(_Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2, _Add_14295f72880e4b87a1baf1ced943ac40_Out_2);
        float _Add_e59af300bba2498db32eac1412123447_Out_2;
        Unity_Add_float(_Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Add_e59af300bba2498db32eac1412123447_Out_2);
        float _Add_e855069f047fae8ea9027d56acb61e56_Out_2;
        Unity_Add_float(_Add_e59af300bba2498db32eac1412123447_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Add_e855069f047fae8ea9027d56acb61e56_Out_2);
        float _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        Unity_Divide_float(_Add_14295f72880e4b87a1baf1ced943ac40_Out_2, _Add_e855069f047fae8ea9027d56acb61e56_Out_2, _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2);
        XYZ_1 = _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Contrast_float(float3 In, float Contrast, out float3 Out)
        {
            float midpoint = pow(0.5, 2.2);
            Out =  (In - midpoint) * Contrast + midpoint;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1 = _Property_256e5676e1089881ae3214634430b140_Out_0[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2 = _Property_256e5676e1089881ae3214634430b140_Out_0[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3 = _Property_256e5676e1089881ae3214634430b140_Out_0[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4 = _Property_256e5676e1089881ae3214634430b140_Out_0[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.tex, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.a;
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0 = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1 = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2 = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3 = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4 = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1, _Split_c4822b8eaff9b185be7c059792345712_G_2, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1);
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0 = _BaseUsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_11506852e45cbb8f9732aebed8bbb210;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.uv0 = IN.uv0;
            float4 _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_11506852e45cbb8f9732aebed8bbb210, _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0 = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2);
            UnityTexture2D _Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0 = UnityBuildTexture2DStructNoScale(_IceNoiseNormal);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.uv0 = IN.uv0;
            float4 _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc, _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2);
            float _Property_345c364a9e67bd878b47cfd40d450e2f_Out_0 = _NoiseNormalScale;
            float3 _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2.xyz), _Property_345c364a9e67bd878b47cfd40d450e2f_Out_0, _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2);
            float _Property_852d221028b884858f029fedb8de47d1_Out_0 = _IceNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_852d221028b884858f029fedb8de47d1_Out_0, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1);
            float _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1;
            Unity_Absolute_float(_TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1, _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1);
            float _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0 = _IceNoisePower;
            float _Power_1497f6299359e780a9aa8dde441d98cf_Out_2;
            Unity_Power_float(_Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1, _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0, _Power_1497f6299359e780a9aa8dde441d98cf_Out_2);
            float _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0 = _IceNoiseContrast;
            float3 _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2;
            Unity_Contrast_float((_Power_1497f6299359e780a9aa8dde441d98cf_Out_2.xxx), _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0, _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2);
            float _Split_f399eb1f3ad77580a75b6122d38451b5_R_1 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[0];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_G_2 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[1];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_B_3 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[2];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_A_4 = 0;
            float _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3;
            Unity_Clamp_float(_Split_f399eb1f3ad77580a75b6122d38451b5_R_1, 0, 1, _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3);
            float3 _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3;
            Unity_Lerp_float3(_NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2, _NormalStrength_b496ef5766b1ca83b00cc208ea1bd034_Out_2, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xxx), _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2;
            Unity_NormalBlend_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0, _Lerp_a57daa4ae094b684a79282f8139084cf_Out_3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2);
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.NormalTS = _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2;
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpacePosition = input.positionWS;
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma target 3.5 DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float3 AbsoluteWorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
             float4 interp5 : INTERP5;
             float4 interp6 : INTERP6;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.texCoord1;
            output.interp5.xyzw =  input.texCoord2;
            output.interp6.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.texCoord1 = input.interp4.xyzw;
            output.texCoord2 = input.interp5.xyzw;
            output.color = input.interp6.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        #include "./NMParallaxLayers.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
        Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
        UnitySamplerState _Property_46d5a097541149fe957f85c1365643be_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_46d5a097541149fe957f85c1365643be_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, tangentTransform, true);
        }
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
        Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }
        
        float Unity_SimpleNoise_ValueNoise_LegacySine_float (float2 uv)
        {
        float2 i = floor(uv);
        float2 f = frac(uv);
        f = f * f * (3.0 - 2.0 * f);
        uv = abs(frac(uv) - 0.5);
        float2 c0 = i + float2(0.0, 0.0);
        float2 c1 = i + float2(1.0, 0.0);
        float2 c2 = i + float2(0.0, 1.0);
        float2 c3 = i + float2(1.0, 1.0);
        float r0; Hash_LegacySine_2_1_float(c0, r0);
        float r1; Hash_LegacySine_2_1_float(c1, r1);
        float r2; Hash_LegacySine_2_1_float(c2, r2);
        float r3; Hash_LegacySine_2_1_float(c3, r3);
        float bottomOfGrid = lerp(r0, r1, f.x);
        float topOfGrid = lerp(r2, r3, f.x);
        float t = lerp(bottomOfGrid, topOfGrid, f.y);
        return t;
        }
        
        void Unity_SimpleNoise_LegacySine_float(float2 UV, float Scale, out float Out)
        {
        float freq, amp;
        Out = 0.0f;
        freq = pow(2.0, float(0));
        amp = pow(0.5, float(3-0));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(1));
        amp = pow(0.5, float(3-1));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(2));
        amp = pow(0.5, float(3-2));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float
        {
        float3 WorldSpaceNormal;
        float3 AbsoluteWorldSpacePosition;
        };
        
        void SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(float Vector1_E4D1C13A, float Vector1_CBF4C304, Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float IN, out float XYZ_1)
        {
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float3 _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1);
        float _Split_742547a7039de986a646d04c157ae549_R_1 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[0];
        float _Split_742547a7039de986a646d04c157ae549_G_2 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[1];
        float _Split_742547a7039de986a646d04c157ae549_B_3 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[2];
        float _Split_742547a7039de986a646d04c157ae549_A_4 = 0;
        float2 _Vector2_40a8919e571ec18499de72022c155b38_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_G_2, 1);
        float2 _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2;
        Unity_Multiply_float2_float2((_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4.xy), _Vector2_40a8919e571ec18499de72022c155b38_Out_0, _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2);
        float _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0 = Vector1_CBF4C304;
        float _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_5fa32af59cdca88389832336b2268bd5_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2);
        float3 _Absolute_644b798714827680b39bf5d34f70385f_Out_1;
        Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_644b798714827680b39bf5d34f70385f_Out_1);
        float _Property_adc4c59482221c8aad681c6558728ac9_Out_0 = Vector1_E4D1C13A;
        float3 _Power_ee478822a04529849ae8df1636c29fe2_Out_2;
        Unity_Power_float3(_Absolute_644b798714827680b39bf5d34f70385f_Out_1, (_Property_adc4c59482221c8aad681c6558728ac9_Out_0.xxx), _Power_ee478822a04529849ae8df1636c29fe2_Out_2);
        float3 _Multiply_b386a937554d73828e437d126d69608b_Out_2;
        Unity_Multiply_float3_float3(_Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Multiply_b386a937554d73828e437d126d69608b_Out_2);
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[0];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[1];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[2];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_A_4 = 0;
        float _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2);
        float4 _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4;
        float3 _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5;
        float2 _Combine_192c2c4a69be588b90ca005a32e22552_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4, _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5, _Combine_192c2c4a69be588b90ca005a32e22552_RG_6);
        float _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2;
        Unity_Multiply_float_float(_Split_742547a7039de986a646d04c157ae549_B_3, -1, _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2);
        float2 _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0 = float2(_Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2, 1);
        float2 _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2;
        Unity_Multiply_float2_float2((_Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4.xy), _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0, _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2);
        float _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2);
        float _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2);
        float4 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4;
        float3 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5;
        float2 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_B_3, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6);
        float2 _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_R_1, 1);
        float2 _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2;
        Unity_Multiply_float2_float2((_Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4.xy), _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0, _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2);
        float _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2);
        float _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2);
        float _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2;
        Unity_Add_float(_Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2);
        float _Add_14295f72880e4b87a1baf1ced943ac40_Out_2;
        Unity_Add_float(_Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2, _Add_14295f72880e4b87a1baf1ced943ac40_Out_2);
        float _Add_e59af300bba2498db32eac1412123447_Out_2;
        Unity_Add_float(_Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Add_e59af300bba2498db32eac1412123447_Out_2);
        float _Add_e855069f047fae8ea9027d56acb61e56_Out_2;
        Unity_Add_float(_Add_e59af300bba2498db32eac1412123447_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Add_e855069f047fae8ea9027d56acb61e56_Out_2);
        float _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        Unity_Divide_float(_Add_14295f72880e4b87a1baf1ced943ac40_Out_2, _Add_e855069f047fae8ea9027d56acb61e56_Out_2, _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2);
        XYZ_1 = _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Contrast_float(float3 In, float Contrast, out float3 Out)
        {
            float midpoint = pow(0.5, 2.2);
            Out =  (In - midpoint) * Contrast + midpoint;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float2(float2 A, float2 B, float2 T, out float2 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        UnitySamplerState _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }
        
        struct Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float IN, out float4 XZ_2)
        {
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        XZ_2 = (float4(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3, 0.0, 1.0));
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float
        {
        };
        
        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float IN, out float3 OutVector4_1)
        {
        float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
        float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
        Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
        float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
        Unity_Multiply_float_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
        float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
        float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
        Unity_Multiply_float4_float4(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
        OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _Property_e5176656505ae98292b155cb230ab233_Out_0 = _IceDistortion;
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0 = _BaseUsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_11506852e45cbb8f9732aebed8bbb210;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.uv0 = IN.uv0;
            float4 _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_11506852e45cbb8f9732aebed8bbb210, _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2);
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_R_1 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[0];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[1];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_B_3 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[2];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_A_4 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[3];
            float4 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4;
            float3 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5;
            float2 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6;
            Unity_Combine_float(_Split_a108e1720257bf83ba61786c1ab1a0ca_R_1, _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2, 0, 0, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6);
            float2 _Multiply_9bed13a6994a89889288447a9152078b_Out_2;
            Unity_Multiply_float2_float2((_Property_e5176656505ae98292b155cb230ab233_Out_0.xx), _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6, _Multiply_9bed13a6994a89889288447a9152078b_Out_2);
            float _Property_8644e31610e05a84bfa06afd61d23967_Out_0 = _Ice_Noise_Distortion;
            UnityTexture2D _Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0 = UnityBuildTexture2DStructNoScale(_IceNoiseNormal);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.uv0 = IN.uv0;
            float4 _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc, _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2);
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_R_1 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[0];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[1];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_B_3 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[2];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_A_4 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[3];
            float4 _Combine_0980c1220518a788beef3792138b09bc_RGBA_4;
            float3 _Combine_0980c1220518a788beef3792138b09bc_RGB_5;
            float2 _Combine_0980c1220518a788beef3792138b09bc_RG_6;
            Unity_Combine_float(_Split_aea7e8f011b37b85bd67111f2c0722a7_R_1, _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2, 0, 0, _Combine_0980c1220518a788beef3792138b09bc_RGBA_4, _Combine_0980c1220518a788beef3792138b09bc_RGB_5, _Combine_0980c1220518a788beef3792138b09bc_RG_6);
            float2 _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2;
            Unity_Multiply_float2_float2((_Property_8644e31610e05a84bfa06afd61d23967_Out_0.xx), _Combine_0980c1220518a788beef3792138b09bc_RG_6, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2);
            float _Property_852d221028b884858f029fedb8de47d1_Out_0 = _IceNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_852d221028b884858f029fedb8de47d1_Out_0, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1);
            float _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1;
            Unity_Absolute_float(_TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1, _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1);
            float _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0 = _IceNoisePower;
            float _Power_1497f6299359e780a9aa8dde441d98cf_Out_2;
            Unity_Power_float(_Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1, _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0, _Power_1497f6299359e780a9aa8dde441d98cf_Out_2);
            float _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0 = _IceNoiseContrast;
            float3 _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2;
            Unity_Contrast_float((_Power_1497f6299359e780a9aa8dde441d98cf_Out_2.xxx), _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0, _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2);
            float _Split_f399eb1f3ad77580a75b6122d38451b5_R_1 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[0];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_G_2 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[1];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_B_3 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[2];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_A_4 = 0;
            float _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3;
            Unity_Clamp_float(_Split_f399eb1f3ad77580a75b6122d38451b5_R_1, 0, 1, _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3);
            float2 _Lerp_701142594e6c5786a700edb533ed6de3_Out_3;
            Unity_Lerp_float2(_Multiply_9bed13a6994a89889288447a9152078b_Out_2, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xx), _Lerp_701142594e6c5786a700edb533ed6de3_Out_3);
            float2 _Multiply_be4736503512af8d91df02fa276dcd77_Out_2;
            Unity_Multiply_float2_float2(_Lerp_701142594e6c5786a700edb533ed6de3_Out_3, (_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2);
            float2 _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2;
            Unity_Add_float2((_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2, _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2);
            float3 _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1;
            Unity_SceneColor_float((float4(_Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2, 0.0, 1.0)), _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1);
            float _Property_49f84d0718855d86902de5bbf5925223_Out_0 = _CleanColorPower;
            float3 _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2;
            Unity_Multiply_float3_float3(_SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1, (_Property_49f84d0718855d86902de5bbf5925223_Out_0.xxx), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2);
            float4 _Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0 = _DeepColor;
            float4 _Property_7094041d89afbd878cb83460f4ab68b8_Out_0 = _ShalowColor;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0 = _ShalowFalloffMultiply;
            float _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0, _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2);
            float _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1;
            Unity_Absolute_float(_Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2, _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1);
            float _Property_e6dd087698d3e984bd5eb642347af797_Out_0 = _ShalowFalloffPower;
            float _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2;
            Unity_Multiply_float_float(_Property_e6dd087698d3e984bd5eb642347af797_Out_0, -1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2);
            float _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2;
            Unity_Power_float(_Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2, _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2);
            float _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1;
            Unity_Saturate_float(_Power_aaf82c5db3291a8bb2095cce38670a92_Out_2, _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1);
            float _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3;
            Unity_Clamp_float(_Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1, 0, 1, _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3);
            float4 _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3;
            Unity_Lerp_float4(_Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0, _Property_7094041d89afbd878cb83460f4ab68b8_Out_0, (_Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3.xxxx), _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3);
            float3 _Multiply_175272476246508a97ee024c2aec0469_Out_2;
            Unity_Multiply_float3_float3((_Lerp_bff7238223fec786b08d9cf92a09754c_Out_3.xyz), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2);
            float _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0 = _CleanFalloffMultiply;
            float _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0, _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2);
            float _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3;
            Unity_Clamp_float(_Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2, 0, 1, _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3);
            float _Absolute_2efac825a986e28190f26200795ca9ec_Out_1;
            Unity_Absolute_float(_Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3, _Absolute_2efac825a986e28190f26200795ca9ec_Out_1);
            float _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0 = _CleanFalloffPower;
            float _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2;
            Unity_Power_float(_Absolute_2efac825a986e28190f26200795ca9ec_Out_1, _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0, _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2);
            float _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3;
            Unity_Clamp_float(_Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2, 0, 1, _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3);
            float3 _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3;
            Unity_Lerp_float3(_Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2, (_Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3.xxx), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3);
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_893a7c3932a452849a5239a91f337a35;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.uv0 = IN.uv0;
            float4 _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNM_893a7c3932a452849a5239a91f337a35, _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2);
            float _Property_771911a99405a780908dd542012af7b8_Out_0 = _IceParallaxSteps;
            Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.uv0 = IN.uv0;
            float4 _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2;
            SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(_Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2);
            float _Property_efee416de222038a93fa523171fb9f0d_Out_0 = _ParalaxOffset;
            float _Property_720bc7e00a412889a10ca999204543f8_Out_0 = _IceParallaxNoiseMin;
            float _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0 = _IceParallaxNoiseMax;
            float _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0 = _IceParallaxNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1);
            float _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3;
            Unity_Clamp_float(_TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1, 0, 1, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3);
            float _Lerp_87de925175c62a8986309dc80655ce2f_Out_3;
            Unity_Lerp_float(_Property_720bc7e00a412889a10ca999204543f8_Out_0, _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3);
            float _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3;
            Unity_Lerp_float(_Property_efee416de222038a93fa523171fb9f0d_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3);
            float _Property_acfd17e181f6108ba7921d3e04df886d_Out_0 = _IceDepth;
            float3 _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1 = TransformWorldToTangentDir(IN.WorldSpaceViewDirection.xyz, tangentTransform, true);
            }
            float _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0 = _ParallaxFalloff;
            float _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3;
            Unity_Lerp_float(_Property_eede9dad69eea580b2a3fdc05280f02f_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3);
            float4 _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2;
            ParallaxLayers_float(_Property_771911a99405a780908dd542012af7b8_Out_0, (_PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2.xy), _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3, _Property_acfd17e181f6108ba7921d3e04df886d_Out_0, _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1, IN.WorldSpaceViewDirection, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2);
            float4 _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2;
            Unity_Blend_Lighten_float4(_PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2, _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2;
            Unity_Multiply_float4_float4(_Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_41859d117584758eb8002ecc938f9bce_Out_0, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2);
            float3 _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3;
            Unity_Lerp_float3((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2.xyz), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xxx), _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1 = _Property_256e5676e1089881ae3214634430b140_Out_0[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2 = _Property_256e5676e1089881ae3214634430b140_Out_0[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3 = _Property_256e5676e1089881ae3214634430b140_Out_0[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4 = _Property_256e5676e1089881ae3214634430b140_Out_0[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.tex, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.a;
            float _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4, 2, _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2);
            float _Add_fd3efcae64779e848ef39919335cd44d_Out_2;
            Unity_Add_float(_Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2, -1, _Add_fd3efcae64779e848ef39919335cd44d_Out_2);
            float _Property_605f29777330a58ba88ac032e905433b_Out_0 = _DetailAlbedoScale;
            float _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2;
            Unity_Multiply_float_float(_Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Property_605f29777330a58ba88ac032e905433b_Out_0, _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2);
            float _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1;
            Unity_Saturate_float(_Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2, _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1);
            float _Absolute_8acef423205118879e75274a48969d34_Out_1;
            Unity_Absolute_float(_Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1, _Absolute_8acef423205118879e75274a48969d34_Out_1);
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185;
            float3 _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float((float4(_Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3, 1.0)), _Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Absolute_8acef423205118879e75274a48969d34_Out_1, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float3 _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3;
            Unity_Lerp_float3(_Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, (_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3.xxx), _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3);
            float4 _Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0 = _WetColor;
            float3 _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2;
            Unity_Multiply_float3_float3((_Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0.xyz), _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3;
            Unity_Clamp_float(_Split_5b2299b48b10138ea40c141b79bfe90e_R_1, 0, 1, _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3);
            float _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1;
            Unity_OneMinus_float(_Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1);
            float3 _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            Unity_Lerp_float3(_Lerp_7b0da7568070568992f16c8217ad84e6_Out_3, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2, (_OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1.xxx), _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3);
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.BaseColor = _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma target 3.5 DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.color = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull [_Cull]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma target 3.5 DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.color = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma target 3.5 DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float3 AbsoluteWorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float4 interp4 : INTERP4;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _WaterAlphaMultiply;
        float _WaterAlphaPower;
        float _CleanFalloffMultiply;
        float _CleanFalloffPower;
        float _ShalowFalloffMultiply;
        float _ShalowFalloffPower;
        float _CleanColorPower;
        float4 _ShalowColor;
        float4 _DeepColor;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float _IceNoiseScale;
        float _IceNoiseContrast;
        float _IceNoisePower;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _IceNoiseNormal_TexelSize;
        float _NoiseNormalScale;
        float _BaseMetallic;
        float _BaseAO;
        float _IceSmoothness;
        float _IceCrackSmoothness;
        float _IceNoiseSmoothness;
        float4 _ParalaxMap_TexelSize;
        float _ParalaxOffset;
        float _IceParallaxSteps;
        float _IceDepth;
        float _ParallaxFalloff;
        float _IceParallaxNoiseScale;
        float _IceParallaxNoiseMin;
        float _IceParallaxNoiseMax;
        float _IceDistortion;
        float _Ice_Noise_Distortion;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_IceNoiseNormal);
        SAMPLER(sampler_IceNoiseNormal);
        TEXTURE2D(_ParalaxMap);
        SAMPLER(sampler_ParalaxMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        #include "./NM_Object_VSPro_Indirect.cginc"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        #include "./NMParallaxLayers.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void AddPragma_float(float3 A, out float3 Out){
        #pragma instancing_options renderinglayer procedural:setupVSPro
        Out = A;
        }
        
        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float
        {
        };
        
        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float IN, out float3 ObjectSpacePosition_1)
        {
        float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
        float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
        InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
        float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
        ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
        Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
        UnitySamplerState _Property_46d5a097541149fe957f85c1365643be_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_46d5a097541149fe957f85c1365643be_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, tangentTransform, true);
        }
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
        Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }
        
        float Unity_SimpleNoise_ValueNoise_LegacySine_float (float2 uv)
        {
        float2 i = floor(uv);
        float2 f = frac(uv);
        f = f * f * (3.0 - 2.0 * f);
        uv = abs(frac(uv) - 0.5);
        float2 c0 = i + float2(0.0, 0.0);
        float2 c1 = i + float2(1.0, 0.0);
        float2 c2 = i + float2(0.0, 1.0);
        float2 c3 = i + float2(1.0, 1.0);
        float r0; Hash_LegacySine_2_1_float(c0, r0);
        float r1; Hash_LegacySine_2_1_float(c1, r1);
        float r2; Hash_LegacySine_2_1_float(c2, r2);
        float r3; Hash_LegacySine_2_1_float(c3, r3);
        float bottomOfGrid = lerp(r0, r1, f.x);
        float topOfGrid = lerp(r2, r3, f.x);
        float t = lerp(bottomOfGrid, topOfGrid, f.y);
        return t;
        }
        
        void Unity_SimpleNoise_LegacySine_float(float2 UV, float Scale, out float Out)
        {
        float freq, amp;
        Out = 0.0f;
        freq = pow(2.0, float(0));
        amp = pow(0.5, float(3-0));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(1));
        amp = pow(0.5, float(3-1));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        freq = pow(2.0, float(2));
        amp = pow(0.5, float(3-2));
        Out += Unity_SimpleNoise_ValueNoise_LegacySine_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float
        {
        float3 WorldSpaceNormal;
        float3 AbsoluteWorldSpacePosition;
        };
        
        void SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(float Vector1_E4D1C13A, float Vector1_CBF4C304, Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float IN, out float XYZ_1)
        {
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float3 _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1);
        float _Split_742547a7039de986a646d04c157ae549_R_1 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[0];
        float _Split_742547a7039de986a646d04c157ae549_G_2 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[1];
        float _Split_742547a7039de986a646d04c157ae549_B_3 = _Sign_b826e0ff2d95ec8cb2b2cbbd7ea2eab6_Out_1[2];
        float _Split_742547a7039de986a646d04c157ae549_A_4 = 0;
        float2 _Vector2_40a8919e571ec18499de72022c155b38_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_G_2, 1);
        float2 _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2;
        Unity_Multiply_float2_float2((_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4.xy), _Vector2_40a8919e571ec18499de72022c155b38_Out_0, _Multiply_5fa32af59cdca88389832336b2268bd5_Out_2);
        float _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0 = Vector1_CBF4C304;
        float _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_5fa32af59cdca88389832336b2268bd5_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2);
        float3 _Absolute_644b798714827680b39bf5d34f70385f_Out_1;
        Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_644b798714827680b39bf5d34f70385f_Out_1);
        float _Property_adc4c59482221c8aad681c6558728ac9_Out_0 = Vector1_E4D1C13A;
        float3 _Power_ee478822a04529849ae8df1636c29fe2_Out_2;
        Unity_Power_float3(_Absolute_644b798714827680b39bf5d34f70385f_Out_1, (_Property_adc4c59482221c8aad681c6558728ac9_Out_0.xxx), _Power_ee478822a04529849ae8df1636c29fe2_Out_2);
        float3 _Multiply_b386a937554d73828e437d126d69608b_Out_2;
        Unity_Multiply_float3_float3(_Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Power_ee478822a04529849ae8df1636c29fe2_Out_2, _Multiply_b386a937554d73828e437d126d69608b_Out_2);
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[0];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[1];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3 = _Multiply_b386a937554d73828e437d126d69608b_Out_2[2];
        float _Split_ae83014fcbd9f7879a0b91fa66dc9718_A_4 = 0;
        float _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_0e7b58280659be8c8ca8f9afb8e0ca3b_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2);
        float4 _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4;
        float3 _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5;
        float2 _Combine_192c2c4a69be588b90ca005a32e22552_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4, _Combine_192c2c4a69be588b90ca005a32e22552_RGB_5, _Combine_192c2c4a69be588b90ca005a32e22552_RG_6);
        float _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2;
        Unity_Multiply_float_float(_Split_742547a7039de986a646d04c157ae549_B_3, -1, _Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2);
        float2 _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0 = float2(_Multiply_014402ded5a3988a8c18ba07636ea5a7_Out_2, 1);
        float2 _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2;
        Unity_Multiply_float2_float2((_Combine_192c2c4a69be588b90ca005a32e22552_RGBA_4.xy), _Vector2_caa25d55d456a58982bdfc39b1b43f3f_Out_0, _Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2);
        float _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_a67201b6e1a0a28c98cd9d06e8b09543_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2);
        float _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_88ae991d8653e086af3b82e51f2955ef_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2);
        float4 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4;
        float3 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5;
        float2 _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_B_3, _Split_89ed63cb625cb3878c183d0b71c03400_G_2, 0, 0, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGB_5, _Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RG_6);
        float2 _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0 = float2(_Split_742547a7039de986a646d04c157ae549_R_1, 1);
        float2 _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2;
        Unity_Multiply_float2_float2((_Combine_1e9ffdba42d6918fb7a4b185f1585d2a_RGBA_4.xy), _Vector2_54dfd40df2fc78809955dd272f2cf0c3_Out_0, _Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2);
        float _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2;
        Unity_SimpleNoise_LegacySine_float(_Multiply_addbd5fcede95f80bbb806c94e49ef63_Out_2, _Property_c11cebe3c88d6b87bb35406f7a2f70a2_Out_0, _SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2);
        float _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2;
        Unity_Multiply_float_float(_SimpleNoise_6f991cff7666da838f92bf955d096b48_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2);
        float _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2;
        Unity_Add_float(_Multiply_7bb4009c92b108849ac6ca92bc1442f2_Out_2, _Multiply_77818c22e359fc8cbb7dd20216a8db72_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2);
        float _Add_14295f72880e4b87a1baf1ced943ac40_Out_2;
        Unity_Add_float(_Multiply_2e1040ca9c98d085ace76ee93f094039_Out_2, _Add_769d9ee909c9238dbbf72d2800a2f268_Out_2, _Add_14295f72880e4b87a1baf1ced943ac40_Out_2);
        float _Add_e59af300bba2498db32eac1412123447_Out_2;
        Unity_Add_float(_Split_ae83014fcbd9f7879a0b91fa66dc9718_R_1, _Split_ae83014fcbd9f7879a0b91fa66dc9718_G_2, _Add_e59af300bba2498db32eac1412123447_Out_2);
        float _Add_e855069f047fae8ea9027d56acb61e56_Out_2;
        Unity_Add_float(_Add_e59af300bba2498db32eac1412123447_Out_2, _Split_ae83014fcbd9f7879a0b91fa66dc9718_B_3, _Add_e855069f047fae8ea9027d56acb61e56_Out_2);
        float _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        Unity_Divide_float(_Add_14295f72880e4b87a1baf1ced943ac40_Out_2, _Add_e855069f047fae8ea9027d56acb61e56_Out_2, _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2);
        XYZ_1 = _Divide_91ae4b94f1d9b78e99d0472293b8098c_Out_2;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Contrast_float(float3 In, float Contrast, out float3 Out)
        {
            float midpoint = pow(0.5, 2.2);
            Out =  (In - midpoint) * Contrast + midpoint;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float2(float2 A, float2 B, float2 T, out float2 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        UnitySamplerState _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0 = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_145bd4f3da4b4bb884749b354e7ee542_Out_0.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }
        
        struct Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        };
        
        void SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float IN, out float4 XZ_2)
        {
        float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
        Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
        XZ_2 = (float4(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3, 0.0, 1.0));
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float
        {
        };
        
        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float IN, out float3 OutVector4_1)
        {
        float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
        float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
        Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
        float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
        Unity_Multiply_float_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
        float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
        float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
        Unity_Multiply_float4_float4(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
        OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3;
            float3 _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b_float(IN.ObjectSpacePosition, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3, _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1);
            description.Position = _NMObjectVSProIndirect_624c133c67d88c82aed6cac8608952a3_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _Property_e5176656505ae98292b155cb230ab233_Out_0 = _IceDistortion;
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0 = _BaseUsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_11506852e45cbb8f9732aebed8bbb210;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_11506852e45cbb8f9732aebed8bbb210.uv0 = IN.uv0;
            float4 _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_11506852e45cbb8f9732aebed8bbb210, _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2);
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_R_1 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[0];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[1];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_B_3 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[2];
            float _Split_a108e1720257bf83ba61786c1ab1a0ca_A_4 = _PlanarNMn_11506852e45cbb8f9732aebed8bbb210_XZ_2[3];
            float4 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4;
            float3 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5;
            float2 _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6;
            Unity_Combine_float(_Split_a108e1720257bf83ba61786c1ab1a0ca_R_1, _Split_a108e1720257bf83ba61786c1ab1a0ca_G_2, 0, 0, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGBA_4, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RGB_5, _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6);
            float2 _Multiply_9bed13a6994a89889288447a9152078b_Out_2;
            Unity_Multiply_float2_float2((_Property_e5176656505ae98292b155cb230ab233_Out_0.xx), _Combine_0a33c5b2b8ec8f86b2aeb08c0bc50bf8_RG_6, _Multiply_9bed13a6994a89889288447a9152078b_Out_2);
            float _Property_8644e31610e05a84bfa06afd61d23967_Out_0 = _Ice_Noise_Distortion;
            UnityTexture2D _Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0 = UnityBuildTexture2DStructNoScale(_IceNoiseNormal);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc.uv0 = IN.uv0;
            float4 _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_18f0f01e1e17cf87a7ebcd949e011c50_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc, _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2);
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_R_1 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[0];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[1];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_B_3 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[2];
            float _Split_aea7e8f011b37b85bd67111f2c0722a7_A_4 = _PlanarNMn_7a043284499e5081bab0ed1ddcce79bc_XZ_2[3];
            float4 _Combine_0980c1220518a788beef3792138b09bc_RGBA_4;
            float3 _Combine_0980c1220518a788beef3792138b09bc_RGB_5;
            float2 _Combine_0980c1220518a788beef3792138b09bc_RG_6;
            Unity_Combine_float(_Split_aea7e8f011b37b85bd67111f2c0722a7_R_1, _Split_aea7e8f011b37b85bd67111f2c0722a7_G_2, 0, 0, _Combine_0980c1220518a788beef3792138b09bc_RGBA_4, _Combine_0980c1220518a788beef3792138b09bc_RGB_5, _Combine_0980c1220518a788beef3792138b09bc_RG_6);
            float2 _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2;
            Unity_Multiply_float2_float2((_Property_8644e31610e05a84bfa06afd61d23967_Out_0.xx), _Combine_0980c1220518a788beef3792138b09bc_RG_6, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2);
            float _Property_852d221028b884858f029fedb8de47d1_Out_0 = _IceNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_852d221028b884858f029fedb8de47d1_Out_0, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b, _TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1);
            float _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1;
            Unity_Absolute_float(_TriplanarNMNoise_351a613770537e81b93e8f91ef15860b_XYZ_1, _Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1);
            float _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0 = _IceNoisePower;
            float _Power_1497f6299359e780a9aa8dde441d98cf_Out_2;
            Unity_Power_float(_Absolute_a7dfccd396cb61888c16cea510a7f519_Out_1, _Property_df6feda9e5377a89a942c1f7636f1e96_Out_0, _Power_1497f6299359e780a9aa8dde441d98cf_Out_2);
            float _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0 = _IceNoiseContrast;
            float3 _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2;
            Unity_Contrast_float((_Power_1497f6299359e780a9aa8dde441d98cf_Out_2.xxx), _Property_a956e66de9f6cf8b87e64439b746f1c9_Out_0, _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2);
            float _Split_f399eb1f3ad77580a75b6122d38451b5_R_1 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[0];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_G_2 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[1];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_B_3 = _Contrast_4024e4b32e83d98fb27ed40d4f36eefb_Out_2[2];
            float _Split_f399eb1f3ad77580a75b6122d38451b5_A_4 = 0;
            float _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3;
            Unity_Clamp_float(_Split_f399eb1f3ad77580a75b6122d38451b5_R_1, 0, 1, _Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3);
            float2 _Lerp_701142594e6c5786a700edb533ed6de3_Out_3;
            Unity_Lerp_float2(_Multiply_9bed13a6994a89889288447a9152078b_Out_2, _Multiply_4f8a6e0ca01b0b878cc5b9fdab6004b1_Out_2, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xx), _Lerp_701142594e6c5786a700edb533ed6de3_Out_3);
            float2 _Multiply_be4736503512af8d91df02fa276dcd77_Out_2;
            Unity_Multiply_float2_float2(_Lerp_701142594e6c5786a700edb533ed6de3_Out_3, (_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2);
            float2 _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2;
            Unity_Add_float2((_ScreenPosition_cc729ea2585d7984b83cff8fbb32e3d3_Out_0.xy), _Multiply_be4736503512af8d91df02fa276dcd77_Out_2, _Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2);
            float3 _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1;
            Unity_SceneColor_float((float4(_Add_b8dd80e352ab4c8bb1a57e2c2e2b1845_Out_2, 0.0, 1.0)), _SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1);
            float _Property_49f84d0718855d86902de5bbf5925223_Out_0 = _CleanColorPower;
            float3 _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2;
            Unity_Multiply_float3_float3(_SceneColor_62f24d722b99848ea36247cc6876c8b1_Out_1, (_Property_49f84d0718855d86902de5bbf5925223_Out_0.xxx), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2);
            float4 _Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0 = _DeepColor;
            float4 _Property_7094041d89afbd878cb83460f4ab68b8_Out_0 = _ShalowColor;
            float4 _ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0 = float4(IN.NDCPosition.xy, 0, 0);
            float _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1;
            Unity_SceneDepth_Linear01_float(_ScreenPosition_a14b92c517d0bd8ba5dda05b33022b97_Out_0, _SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1);
            float _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2;
            Unity_Multiply_float_float(_SceneDepth_7af577a02f66b08cbf0a82dd11d101c1_Out_1, _ProjectionParams.z, _Multiply_2b034506acf7a88fb331c13ba3276778_Out_2);
            float4 _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0 = IN.ScreenPosition;
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_R_1 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[0];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_G_2 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[1];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_B_3 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[2];
            float _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4 = _ScreenPosition_1ad44e1b82f129819a03f27c63a9dda5_Out_0[3];
            float _Subtract_789dfca37b064285bed8149008e0bff7_Out_2;
            Unity_Subtract_float(_Multiply_2b034506acf7a88fb331c13ba3276778_Out_2, _Split_49e3faacb6fb0e8d9e50b5560efce959_A_4, _Subtract_789dfca37b064285bed8149008e0bff7_Out_2);
            float _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0 = _ShalowFalloffMultiply;
            float _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_d45faccb9a8eb38699cf047ce0e1bb91_Out_0, _Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2);
            float _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1;
            Unity_Absolute_float(_Multiply_09842a1e2e3dab8097df031fcbac3009_Out_2, _Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1);
            float _Property_e6dd087698d3e984bd5eb642347af797_Out_0 = _ShalowFalloffPower;
            float _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2;
            Unity_Multiply_float_float(_Property_e6dd087698d3e984bd5eb642347af797_Out_0, -1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2);
            float _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2;
            Unity_Power_float(_Absolute_c9feaf529682ca80b82407b0d7b43670_Out_1, _Multiply_becf2d84b3023389befca89c1a80edcf_Out_2, _Power_aaf82c5db3291a8bb2095cce38670a92_Out_2);
            float _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1;
            Unity_Saturate_float(_Power_aaf82c5db3291a8bb2095cce38670a92_Out_2, _Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1);
            float _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3;
            Unity_Clamp_float(_Saturate_ad5b4b8242b08088a70a691ffa09f856_Out_1, 0, 1, _Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3);
            float4 _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3;
            Unity_Lerp_float4(_Property_4bd0c6ca665a3d8c94ecdc6712294e47_Out_0, _Property_7094041d89afbd878cb83460f4ab68b8_Out_0, (_Clamp_f5baa0daace6e28ea726519de4641bc4_Out_3.xxxx), _Lerp_bff7238223fec786b08d9cf92a09754c_Out_3);
            float3 _Multiply_175272476246508a97ee024c2aec0469_Out_2;
            Unity_Multiply_float3_float3((_Lerp_bff7238223fec786b08d9cf92a09754c_Out_3.xyz), _Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2);
            float _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0 = _CleanFalloffMultiply;
            float _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_a887c93266ebda8fbf7fa2426fd08088_Out_0, _Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2);
            float _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3;
            Unity_Clamp_float(_Multiply_1727b2cc4cab2b889161b05cede2a830_Out_2, 0, 1, _Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3);
            float _Absolute_2efac825a986e28190f26200795ca9ec_Out_1;
            Unity_Absolute_float(_Clamp_b1b90ad6d1d94a8d928998aae0fc2a0f_Out_3, _Absolute_2efac825a986e28190f26200795ca9ec_Out_1);
            float _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0 = _CleanFalloffPower;
            float _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2;
            Unity_Power_float(_Absolute_2efac825a986e28190f26200795ca9ec_Out_1, _Property_150ab2ec8c4a8983b5372fb8ee1209a7_Out_0, _Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2);
            float _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3;
            Unity_Clamp_float(_Power_f4a310d75a76d28bb72f53cb07b7cf22_Out_2, 0, 1, _Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3);
            float3 _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3;
            Unity_Lerp_float3(_Multiply_54369d01475e3784b4bec4e6d24dc595_Out_2, _Multiply_175272476246508a97ee024c2aec0469_Out_2, (_Clamp_1b643e9f17afdf8eb0042c0268373325_Out_3.xxx), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3);
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_893a7c3932a452849a5239a91f337a35;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_893a7c3932a452849a5239a91f337a35.uv0 = IN.uv0;
            float4 _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0, _Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), _PlanarNM_893a7c3932a452849a5239a91f337a35, _PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2);
            float _Property_771911a99405a780908dd542012af7b8_Out_0 = _IceParallaxSteps;
            Bindings_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d.uv0 = IN.uv0;
            float4 _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2;
            SG_PlanarNMparallax_8f4c0780863a32842bb34cdaf7eda151_float(_Property_8ec0d512145619859d288abab740e3bf_Out_0, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d, _PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2);
            float _Property_efee416de222038a93fa523171fb9f0d_Out_0 = _ParalaxOffset;
            float _Property_720bc7e00a412889a10ca999204543f8_Out_0 = _IceParallaxNoiseMin;
            float _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0 = _IceParallaxNoiseMax;
            float _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0 = _IceParallaxNoiseScale;
            Bindings_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.WorldSpaceNormal = IN.WorldSpaceNormal;
            _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1;
            SG_TriplanarNMNoise_1831d3bdba78d68499d25c34379bcc3e_float(4, _Property_99873eff650d6e89849f8aa6330fa9cf_Out_0, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44, _TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1);
            float _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3;
            Unity_Clamp_float(_TriplanarNMNoise_2b32fb7fa4c2088593c33ea977059e44_XYZ_1, 0, 1, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3);
            float _Lerp_87de925175c62a8986309dc80655ce2f_Out_3;
            Unity_Lerp_float(_Property_720bc7e00a412889a10ca999204543f8_Out_0, _Property_ec27f3a0ab3e9d848017cc0d4fc13f20_Out_0, _Clamp_f98948b550d15480b1ce6ca1346d34e5_Out_3, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3);
            float _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3;
            Unity_Lerp_float(_Property_efee416de222038a93fa523171fb9f0d_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3);
            float _Property_acfd17e181f6108ba7921d3e04df886d_Out_0 = _IceDepth;
            float3 _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1 = TransformWorldToTangentDir(IN.WorldSpaceViewDirection.xyz, tangentTransform, true);
            }
            float _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0 = _ParallaxFalloff;
            float _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3;
            Unity_Lerp_float(_Property_eede9dad69eea580b2a3fdc05280f02f_Out_0, 0, _Lerp_87de925175c62a8986309dc80655ce2f_Out_3, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3);
            float4 _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2;
            ParallaxLayers_float(_Property_771911a99405a780908dd542012af7b8_Out_0, (_PlanarNMparallax_fa747be847ab9d828a9768cdb0b46c6d_XZ_2.xy), _Lerp_1e424454311ced8eb7ed8fb2e1a1c54e_Out_3, _Property_acfd17e181f6108ba7921d3e04df886d_Out_0, _Transform_1b341a45a24c7786ade1a6e6ec574cfd_Out_1, IN.WorldSpaceViewDirection, _Lerp_b366f3fe289156818a5f95d3160c5204_Out_3, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2);
            float4 _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2;
            Unity_Blend_Lighten_float4(_PlanarNM_893a7c3932a452849a5239a91f337a35_XZ_2, _ParallaxLayersCustomFunction_ec5469e08f93178cbe9a45517f7b2921_Out_2, _Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_eede9dad69eea580b2a3fdc05280f02f_Out_0);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2;
            Unity_Multiply_float4_float4(_Blend_fbdc6b1c3b073780a1c18c93cce4b655_Out_2, _Property_41859d117584758eb8002ecc938f9bce_Out_0, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2);
            float3 _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3;
            Unity_Lerp_float3((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2.xyz), _Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, (_Clamp_e2ecb22fcddb4389ab87beedf0f68421_Out_3.xxx), _Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1 = _Property_256e5676e1089881ae3214634430b140_Out_0[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2 = _Property_256e5676e1089881ae3214634430b140_Out_0[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3 = _Property_256e5676e1089881ae3214634430b140_Out_0[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4 = _Property_256e5676e1089881ae3214634430b140_Out_0[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.tex, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7 = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0.a;
            float _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2;
            Unity_Multiply_float_float(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4, 2, _Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2);
            float _Add_fd3efcae64779e848ef39919335cd44d_Out_2;
            Unity_Add_float(_Multiply_52f8b5b58fa8038aa7f5e6bd44a5987b_Out_2, -1, _Add_fd3efcae64779e848ef39919335cd44d_Out_2);
            float _Property_605f29777330a58ba88ac032e905433b_Out_0 = _DetailAlbedoScale;
            float _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2;
            Unity_Multiply_float_float(_Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Property_605f29777330a58ba88ac032e905433b_Out_0, _Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2);
            float _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1;
            Unity_Saturate_float(_Multiply_e2f43f3d32aa118aa7a6ae4764d42b26_Out_2, _Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1);
            float _Absolute_8acef423205118879e75274a48969d34_Out_1;
            Unity_Absolute_float(_Saturate_7c8334fd3d10d0819f8e616286670f68_Out_1, _Absolute_8acef423205118879e75274a48969d34_Out_1);
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185;
            float3 _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float((float4(_Lerp_1c64acb6f67d3780b4f4de14046b8c10_Out_3, 1.0)), _Add_fd3efcae64779e848ef39919335cd44d_Out_2, _Absolute_8acef423205118879e75274a48969d34_Out_1, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1);
            float _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0 = _WaterAlphaMultiply;
            float _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2;
            Unity_Multiply_float_float(_Subtract_789dfca37b064285bed8149008e0bff7_Out_2, _Property_84ae67371986ff81a4f12c4cacc740f8_Out_0, _Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2);
            float _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3;
            Unity_Clamp_float(_Multiply_da00cf7a8156a283b5f7f61233dd78f5_Out_2, 0, 1, _Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3);
            float _Absolute_723d0a8c684ad58e96147de222441890_Out_1;
            Unity_Absolute_float(_Clamp_9c478e3afe679181ae2700f1ff899dc2_Out_3, _Absolute_723d0a8c684ad58e96147de222441890_Out_1);
            float _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0 = _WaterAlphaPower;
            float _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2;
            Unity_Power_float(_Absolute_723d0a8c684ad58e96147de222441890_Out_1, _Property_47ae5f3cd920738daf6424b98860c4bb_Out_0, _Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2);
            float _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3;
            Unity_Clamp_float(_Power_bdc8062b63bdcd8da89f038c46d0e7ae_Out_2, 0, 1, _Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3);
            float3 _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3;
            Unity_Lerp_float3(_Lerp_6966965b6d7def8db21f34622eec1fba_Out_3, _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, (_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3.xxx), _Lerp_7b0da7568070568992f16c8217ad84e6_Out_3);
            float4 _Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0 = _WetColor;
            float3 _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2;
            Unity_Multiply_float3_float3((_Property_b3a0f629ac3f4c84be44eb113c15ef93_Out_0.xyz), _BlendOverlayBaseColor_66b5af480b0a3288ba91497f7c750185_OutVector4_1, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1 = IN.VertexColor[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2 = IN.VertexColor[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3 = IN.VertexColor[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4 = IN.VertexColor[3];
            float _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3;
            Unity_Clamp_float(_Split_5b2299b48b10138ea40c141b79bfe90e_R_1, 0, 1, _Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3);
            float _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1;
            Unity_OneMinus_float(_Clamp_a67ec360bcae2a8aa68496602ffe74c8_Out_3, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1);
            float3 _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            Unity_Lerp_float3(_Lerp_7b0da7568070568992f16c8217ad84e6_Out_3, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2, (_OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1.xxx), _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3);
            float _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            Unity_Multiply_float_float(_Clamp_ef9912a61e6a7b878c26e3a9a3cda7fd_Out_3, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4, _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2);
            surface.BaseColor = _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3;
            surface.Alpha = _Multiply_6d8742bf2ab6d684a1c40d4c7633b9d0_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}