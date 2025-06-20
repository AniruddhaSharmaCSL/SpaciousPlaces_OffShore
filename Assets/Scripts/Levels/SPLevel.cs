using SonicBloom.Koreo;
using System;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.Video;

namespace SpaciousPlaces
{
    [System.Serializable]
    public enum LevelType
    {
        MixedReality,
        NoDepthVR,
        DepthVR,
        VideoVR,
    };

    [Flags]
    public enum Instrument
    {
        None = 0,
        Congas = 1 << 0,
        Cymbal = 1 << 4,
    };

    [System.Serializable]
    public class AudioClipAndMixer
    {
        [SerializeField] private AudioClip _audioClip;
        [SerializeField] private AudioMixerGroup _mixerGroup;

        public AudioClip AudioClip
        {
            get { return _audioClip; }
            private set { _audioClip = value; }
        }

        public AudioMixerGroup MixerGroup
        {
            get { return _mixerGroup; }
            private set { _mixerGroup = value; }
        }
    }

    [CreateAssetMenu(fileName = "Level")]
    [System.Serializable]
    public class SPLevel : ScriptableObject
    {
        [SerializeField] public LevelType type;

        // Basic fields shown for all types
        [SerializeField] public string levelTitle;
        [SerializeField] public Sprite thumbnail;
        [SerializeField] public Koreography koreo;
        [SerializeField] public Instrument instruments;
        [SerializeField] public bool showMIDIPitchDebug = false;
        [SerializeField] public AudioMixerSnapshot mixerSnapshot;
        [SerializeField] public AudioClipAndMixer[] ambience;
        [SerializeField] public AudioClipAndMixer[] drones;
        [SerializeField] private Theme _theme = null;
        [SerializeField] public float lightTemperature = 6827f; //directional light
        [SerializeField] public float lightIntensity = 0.5f;
        [SerializeField] public SceneUtils.SceneId scene = SceneUtils.SceneId.Main;

        public Theme Theme { get { return _theme; } }

        // Shared fields
        [SerializeField]
        [ShowIf(new string[] { "IsDepthType", "IsNoDepthType", "IsMixedRealityType", "IsVideoType" }, LogicOperator.Or)]
        public Cubemap customReflection;

        [SerializeField]
        [Range(0f, 1f)]
        [ShowIf(new string[] { "IsDepthType", "IsNoDepthType", "IsMixedRealityType", "IsVideoType" }, LogicOperator.Or)]
        public float reflectionIntensity = 0.7f;

        // VR-specfic field
        [SerializeField]
        [ShowIf(new string[] { "IsNoDepthType" })]
        public Material skyboxMaterial;

        // Video-specific fields
        [SerializeField]
        [ShowIf("IsVideoType")]
        public VideoClip skyboxVideo;

        [SerializeField]
        [ShowIf("IsVideoType")]
        public float videoStartDelay = 0f;

        [SerializeField]
        [ShowIf("IsVideoType")]
        
        [Tooltip("If checked, uses the video skybox for reflections instead of the custom reflection cubemap")]
        public bool useVideoAsSkybox = false;

        [SerializeField]
        [ShowIf("IsDepthType")]
        [RequireShader("DWD/Skybox/Depth Skybox")]
        public Material depthSkyboxMaterial;

        [SerializeField]
        [ShowIf("IsVideoType")]
        [Tooltip("Addressable key for the VideoClip inside the downloaded bundle")]
        public string videoAddressableKey;

        [SerializeField]
        [ShowIf("IsVideoType")]
        [Tooltip("Toggle whether to use addressable video instead of the built-in clip")]
        public bool useAddressableVideo = false;

        //public EnviroConfiguration enviroConfig;

        //[SerializeField]
        //[Tooltip("Show platform particles during Instrument Mode")]
        //public bool platformParticles = false;

        // Helper methods
        private bool IsMixedRealityType()
        {
            return type == LevelType.MixedReality;
        }

        private bool IsNoDepthType()
        {
            return type == LevelType.NoDepthVR;
        }

        private bool IsVideoType()
        {
            return type == LevelType.VideoVR;
        }

        private bool IsDepthType()
        {
            return type == LevelType.DepthVR;
        }
    }
}