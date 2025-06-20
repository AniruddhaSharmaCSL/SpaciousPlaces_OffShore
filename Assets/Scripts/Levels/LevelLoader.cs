using SonicBloom.Koreo;
using System;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.Events;
using UnityEngine.Video;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using System.Collections;
using UnityEngine.AddressableAssets.ResourceLocators;

namespace SpaciousPlaces {
    class PendingInstrumentTransform {
        public GameObject obj;
        public Vector3 localPosition;
        public Vector3 localRotation;
    }

    [System.Serializable]
    class InstrumentData {
        public Instrument instrument;
        public Vector3 localPosition;
        public Vector3 localRotation;
    }

    [System.Serializable]
    class InstrumentDataWrapper {
        public List<InstrumentData> instruments;
    }

    [Serializable]
    public class InstrumentInfo {
        [SerializeField] private Instrument instrument;
        [SerializeField] private GameObject instrumentObject;
        private Vector3 position;
        private Vector3 rotation;

        public Instrument Instrument => instrument;
        public GameObject InstrumentObject => instrumentObject;
        public Vector3 Position => position;
        public Vector3 Rotation => rotation;
    }

    public class LevelLoader : MonoBehaviour {
        [SerializeField] private VideoPlayer skyboxVideoPlayer;
        [SerializeField] private KoreoPicker koreoPicker;
        [SerializeField] private BeatQuantizationManager beatQuantizationManager;
        [SerializeField] private GameObject[] vrObjects;
        [SerializeField] private MeshRenderer depthSkyboxMeshRenderer;
        [SerializeField] private GameObject ambienceAudio;
        [SerializeField] private GameObject droneAudio;

        [SerializeField] private List<InstrumentInfo> instrumentInfos = new List<InstrumentInfo>();

        [SerializeField] private UnityEvent onMRLevelLoaded;

        [SerializeField] private SPLevel level;

        [SerializeField] private GameObject MoodPanel;

        public SPLevel CurrentLevel => level;

        private bool levelLoaded = false;
        public bool IsLevelLoaded => levelLoaded;

        private float levelStartTime;
        private bool isTimerRunning = false;

        public float ElapsedTime => isTimerRunning ? Time.time - levelStartTime : 0f;


        private List<PendingInstrumentTransform> pendingTransforms = new List<PendingInstrumentTransform>();


        public static UnityEvent OnLevelLoaded = new UnityEvent();


        private void Start() {
            if (!levelLoaded && level != null) {
                LoadLevelData(level);

            }
            else {
                Debug.Log("level data already loaded");
            }
            if (GameTypeManager.instance.vrGuardian != null) {
                GameTypeManager.instance.vrGuardian.enabled = true;
            }
        }

        public void LoadLevelData(SPLevel level) {
            if (levelLoaded) {
                Debug.Log("level data already loaded");
                return;
            }

            /* inform AudioMixManager so it switches its pref-key */
            AudioMixManager.Instance.SetCurrentLevel(level.name);

            Debug.Log("loading level data");

            this.level = level;

            var directionalLight = GameObject.Find("Directional Light")?.GetComponent<Light>();
            if (directionalLight != null) {
                directionalLight.useColorTemperature = true;
                directionalLight.colorTemperature = level.lightTemperature;
                directionalLight.intensity = level.lightIntensity;
            }


            // report the SPLevel title once MainScene is fully loaded 
            SceneAnalytics.SendLevelOpened(
                SceneManager.GetActiveScene(),
                level.levelTitle
            );

            LoadInstrumentPositions(level);

            foreach (var instrumentInfo in instrumentInfos) {
                configureInstrument(level, instrumentInfo);
            }

            // Ambience audio can be set up regardless of video loading
            foreach (var ambience in level.ambience) {
                var audioSource = ambienceAudio.AddComponent<AudioSource>();
                audioSource.clip = ambience.AudioClip;
                audioSource.outputAudioMixerGroup = ambience.MixerGroup;
                audioSource.loop = true;
                audioSource.Play();
            }

            foreach (var drone in level.drones) {
                var audioSource = droneAudio.AddComponent<AudioSource>();
                audioSource.clip = drone.AudioClip;
                audioSource.outputAudioMixerGroup = drone.MixerGroup;
                audioSource.loop = true;
                audioSource.Play();
            }

            if (level.mixerSnapshot != null) {
                AudioMixManager.Instance.LoadAudioSnapshot(level.mixerSnapshot);
            }
            else {
                AudioMixManager.Instance.LoadDefaultMixer(false);
            }

            if (level.Theme != null)
                level.Theme.ApplyTheme();

            switch (level.type) {
                case LevelType.NoDepthVR:
                    configureNoDepthVRLevel(level);
                    FinalizeLevelLoading();
                    break;
                case LevelType.MixedReality:
                    configureMRLevel();
                    FinalizeLevelLoading();
                    break;
                case LevelType.DepthVR:
                    configureDepthVRLevel(level);
                    FinalizeLevelLoading();
                    break;
                case LevelType.VideoVR:
                    StartCoroutine(configureVideoLevel(level));
                    // Do not call FinalizeLevelLoading() here, it will be called when video is ready
                    break;
            }
        }

        private void FinalizeLevelLoading() {
            if (level.koreo != null) {
                koreoPicker.AddKoreographyAtIndex(0, level.koreo);
                koreoPicker.StartCurrentKoreographyAtIndex(0);
            }
            else if (beatQuantizationManager != null) {
                beatQuantizationManager.QuantizeOff(true);
            }

            if (beatQuantizationManager != null) {
                beatQuantizationManager.BeatDivisionDidChange();
            }

            levelLoaded = true;
            OnLevelLoaded.Invoke();

            levelStartTime = Time.time;
            isTimerRunning = true;

            Debug.Log($"Level loaded. Timer started at {levelStartTime}");
        }

        private void configureMRLevel() {
            foreach (var obj in vrObjects) {
                obj.SetActive(false);
            }
            enablePassthrough(true);
            RenderSettings.skybox = null;

            if (level.customReflection != null) {
                RenderSettings.ambientMode = UnityEngine.Rendering.AmbientMode.Custom;
                RenderSettings.defaultReflectionMode = UnityEngine.Rendering.DefaultReflectionMode.Custom;
                RenderSettings.customReflectionTexture = level.customReflection;
                RenderSettings.reflectionIntensity = level.reflectionIntensity;
            }
            else {
                RenderSettings.defaultReflectionMode = UnityEngine.Rendering.DefaultReflectionMode.Skybox;
                RenderSettings.customReflectionTexture = null;
            }

            skyboxVideoPlayer.enabled = false;

            if (onMRLevelLoaded != null) {
                onMRLevelLoaded.Invoke();
            }
        }

        private void configureNoDepthVRLevel(SPLevel level) {
            foreach (var obj in vrObjects) {
                obj.SetActive(true);
            }

            enablePassthrough(false);

            Debug.Log("changing skybox");
            RenderSettings.skybox = level.skyboxMaterial;

            if (level.customReflection != null) {
                RenderSettings.ambientMode = UnityEngine.Rendering.AmbientMode.Custom;
                RenderSettings.defaultReflectionMode = UnityEngine.Rendering.DefaultReflectionMode.Custom;
                RenderSettings.customReflectionTexture = level.customReflection;
                RenderSettings.reflectionIntensity = level.reflectionIntensity;
            }
            else {
                RenderSettings.defaultReflectionMode = UnityEngine.Rendering.DefaultReflectionMode.Skybox;
                RenderSettings.customReflectionTexture = null;
            }
        }

        private void configureDepthVRLevel(SPLevel level) {
            if (vrObjects != null) {
                foreach (var obj in vrObjects) {
                    obj.SetActive(true);
                }
            }

            enablePassthrough(false);
            RenderSettings.skybox = null;

            if (depthSkyboxMeshRenderer != null) {
                Debug.Log("changing depth skybox");

                depthSkyboxMeshRenderer.gameObject.SetActive(true);
                depthSkyboxMeshRenderer.material = level.depthSkyboxMaterial;
            }

            if (level.customReflection != null) {
                RenderSettings.ambientMode = UnityEngine.Rendering.AmbientMode.Custom;
                RenderSettings.defaultReflectionMode = UnityEngine.Rendering.DefaultReflectionMode.Custom;
                RenderSettings.customReflectionTexture = level.customReflection;
                RenderSettings.reflectionIntensity = level.reflectionIntensity;
            }
            else {
                RenderSettings.defaultReflectionMode = UnityEngine.Rendering.DefaultReflectionMode.Skybox;
                RenderSettings.customReflectionTexture = null;
            }
        }

        public IEnumerator configureVideoLevel(SPLevel level)
        {
            Debug.Log("Configuring video level...");

            foreach (var obj in vrObjects)
            {
                obj.SetActive(true);
            }

            Debug.Log("VR objects activated.");

            enablePassthrough(false);
            Debug.Log("Passthrough disabled.");

            RenderSettings.skybox = level.skyboxMaterial;
            Debug.Log($"Skybox material set to: {level.skyboxMaterial.name}");

            skyboxVideoPlayer.enabled = true;
            Debug.Log("Skybox video player enabled.");

            if (level.useAddressableVideo)
            {
                Debug.Log("Loading addressable video...");

                AsyncOperationHandle<long> getDownloadSizeHandle = Addressables.GetDownloadSizeAsync(level.videoAddressableKey);
                yield return getDownloadSizeHandle;

                Debug.Log("Here");

                if (getDownloadSizeHandle.Status == AsyncOperationStatus.Succeeded)
                {
                    long downloadSize = getDownloadSizeHandle.Result;

                    if (downloadSize > 0)
                    {
                        Debug.LogWarning($"❌ Video not cached. Download size: {downloadSize} bytes. Skipping playback.");
                        yield break;
                    }
                    else
                    {
                        Debug.Log("✅ Video is already cached. Proceeding to load." + downloadSize);
                    }
                }
                else
                {
                    Debug.LogError("❌ Failed to get download size."); 
                    yield break;
                }

                var handle = Addressables.LoadAssetAsync<VideoClip>(level.videoAddressableKey);
                yield return handle;

                if (handle.Status == AsyncOperationStatus.Succeeded)
                {
                    level.skyboxVideo = handle.Result;
                    skyboxVideoPlayer.clip = level.skyboxVideo;
                    Debug.Log($"Addressable video loaded successfully: {level.videoAddressableKey}");
                }
                else
                {
                    Debug.LogError($"Failed to load video clip with key: {level.videoAddressableKey}");
                    yield break;
                }
            }
            else
            {
                Debug.Log("Using directly referenced video clip.");
                skyboxVideoPlayer.clip = level.skyboxVideo;
            }

            // Set reflection mode based on level settings
            if (level.useVideoAsSkybox)
            {
                RenderSettings.defaultReflectionMode = UnityEngine.Rendering.DefaultReflectionMode.Skybox;
                RenderSettings.customReflectionTexture = null;
                Debug.Log("Reflection mode: Skybox (video used as skybox).");
            }
            else
            {
                RenderSettings.defaultReflectionMode = UnityEngine.Rendering.DefaultReflectionMode.Custom;
                if (level.customReflection != null)
                {
                    RenderSettings.customReflectionTexture = level.customReflection;
                    RenderSettings.reflectionIntensity = level.reflectionIntensity;
                    Debug.Log($"Reflection mode: Custom | Intensity: {level.reflectionIntensity}");
                }
                else
                {
                    RenderSettings.customReflectionTexture = null;
                    Debug.Log("Reflection mode: Custom | No custom reflection texture.");
                }
            }

            // Prepare the video
            Debug.Log("Preparing video clip...");
            skyboxVideoPlayer.prepareCompleted += PrepareCompleted;
            skyboxVideoPlayer.Prepare();
        }

        private void PrepareCompleted(VideoPlayer source) {
            source.prepareCompleted -= PrepareCompleted;
            source.Play();

            FinalizeLevelLoading();
        }

        public void UnloadLevelData() {
            enablePassthrough(false);
            RenderSettings.skybox = null;
            RenderSettings.customReflectionTexture = null;

            isTimerRunning = false;
            levelStartTime = 0f;
        }

        private void OnDestroy() {
            UnloadLevelData();
            if (GameTypeManager.instance.vrGuardian != null) {
                GameTypeManager.instance.vrGuardian.enabled = false;
            }
        }

        private void configureInstrument(SPLevel level, InstrumentInfo instrumentInfo) {
            if (instrumentInfo == null || instrumentInfo.InstrumentObject == null) {
                Debug.Log("no instrument");
                return;
            }
            else {
                Debug.Log("configuring instrument " + instrumentInfo.Instrument + " " + instrumentInfo.InstrumentObject);
            }
            if (!level.instruments.HasFlag(instrumentInfo.Instrument)) {
                instrumentInfo.InstrumentObject.SetActive(false);
            }
            else {
                instrumentInfo.InstrumentObject.SetActive(true);
            }

            var pitchQuantizers = instrumentInfo.InstrumentObject.GetComponentsInChildren<PitchQuantizer>();

            foreach (var pitchQuantizer in pitchQuantizers) {
                pitchQuantizer.ShowDebug = level.showMIDIPitchDebug;
            }
        }

        private static void enablePassthrough(bool enable) {
            var rig = SceneUtils.GetRig();

            if (rig != null) {
                var passthroughLayer = rig.GetComponent<OVRPassthroughLayer>();
                if (passthroughLayer != null) {
                    passthroughLayer.enabled = enable;
                }

                var camera = rig.gameObject.GetComponent<OVRCameraRig>().centerEyeAnchor.GetComponent<Camera>();

                if (camera != null) {
                    camera.clearFlags = enable ? CameraClearFlags.SolidColor : CameraClearFlags.Skybox;
                    camera.backgroundColor = enable ? Color.clear : Color.black;
                }
            }
        }

        private void LoadInstrumentPositions(SPLevel level) {
            string filename = level != null ? level.name : "DefaultInstruments";

            TextAsset jsonFile = Resources.Load<TextAsset>($"InstrumentPositions/{filename}");

            if (jsonFile == null) {
                Debug.Log($"No instrument positions file found for level: {filename}");
                return;
            }


            try {
                string json = jsonFile.text;
                var data = JsonUtility.FromJson<InstrumentDataWrapper>(json);

                if (data?.instruments == null) {
                    Debug.LogError($"Invalid instrument data in file: {jsonFile.name}");
                    return;
                }

                pendingTransforms.Clear();

                foreach (var savedData in data.instruments) {
                    var instrumentInfo = instrumentInfos.Find(info => info.Instrument == savedData.instrument);
                    if (instrumentInfo != null && instrumentInfo.InstrumentObject != null) {
                        pendingTransforms.Add(new PendingInstrumentTransform {
                            obj = instrumentInfo.InstrumentObject,
                            localPosition = savedData.localPosition,
                            localRotation = savedData.localRotation
                        });

                        Debug.Log($"Queued transform for {instrumentInfo.InstrumentObject.name}");
                    }
                }
            }
            catch (System.Exception e) {
                Debug.LogError($"Error loading instrument positions: {e.Message}");
            }
        }

        private void FixedUpdate() {
            if (pendingTransforms.Count > 0) {
                foreach (var pending in pendingTransforms) {
                    var rb = pending.obj.GetComponent<Rigidbody>();
                    if (rb != null) {
                        // Convert local to world for rigidbody if needed
                        Vector3 worldPos;
                        Quaternion worldRot;

                        if (pending.obj.transform.parent != null) {
                            worldPos = pending.obj.transform.parent.TransformPoint(pending.localPosition);
                            worldRot = pending.obj.transform.parent.rotation * Quaternion.Euler(pending.localRotation);
                        }
                        else {
                            worldPos = pending.localPosition;
                            worldRot = Quaternion.Euler(pending.localRotation);
                        }

                        rb.MovePosition(worldPos);
                        rb.MoveRotation(worldRot);

                        // Update transform to match
                        pending.obj.transform.localPosition = pending.localPosition;
                        pending.obj.transform.localRotation = Quaternion.Euler(pending.localRotation);

                        Debug.Log($"Setting {pending.obj.name} local position to {pending.localPosition}, local rotation to {pending.localRotation}");
                    }
                    else {
                        pending.obj.transform.localPosition = pending.localPosition;
                        pending.obj.transform.localRotation = Quaternion.Euler(pending.localRotation);
                    }
                }

                pendingTransforms.Clear();
            }
        }
    }
}