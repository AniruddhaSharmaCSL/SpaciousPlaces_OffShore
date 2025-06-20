using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using VRUIP;
using UnityEngine.Events;
using SpaciousPlaces;

public class AudioMixManager : Singleton<AudioMixManager>
{
    [Header("Mixers")]
    [SerializeField] private AudioMixer mainMixer;
    [SerializeField] private AudioMixerSnapshot defaultMix;
    [SerializeField] private AudioMixerGroup homeScreenMixer;

    [Header("Submix Volume Parameters")]
    private const string MUSIC_PARAM = "Music_Sub";
    private const string INSTRUMENTS_PARAM = "Instruments_Sub";
    private const string AMBIENCE_PARAM = "Ambience_Sub";

    private const float MinDb = -80f;
    [SerializeField] public float maxDb => 10f;
    private const float DefaultNormalizedZeroDb = 0.8f;

    private Dictionary<BusType, SliderController> _registered = new();
    // Added for level-specific settings
    private string currentLevelName = "";
    public string CurrentLevelName => currentLevelName;  // Added: allow external access to level name
    private bool prefsLoadedForCurrentLevel = false;

    private void Start()
    {
        BindSceneSliders();
        // Load saved volumes for current level on start
        ApplySavedVolumes();
    }

    // runtime registry
    private readonly Dictionary<BusType, SliderController> _sliders = new();

    private void OnEnable()
    {
        SceneManager.sceneLoaded += OnSceneLoaded;
        // Listen for level loaded event to apply preferences
        LevelLoader.OnLevelLoaded.AddListener(OnLevelDataLoaded);
    }
    private void OnDisable()
    {
        SceneManager.sceneLoaded -= OnSceneLoaded;
        LevelLoader.OnLevelLoaded.RemoveListener(OnLevelDataLoaded);
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        BindSceneSliders();
        // Apply saved preferences on scene load
        ApplySavedVolumes();
    }

    // Called after a level's data has fully loaded (from LevelLoader).
    private void OnLevelDataLoaded()
    {
        ApplySavedVolumes();
    }

    private void BindSceneSliders()
    {
        _sliders.Clear();
        var all = FindObjectsOfType<SliderController>();
        foreach (var slider in all)
        {
            RegisterSlider(slider, slider.BusType);
        }
    }

    public void RegisterSlider(SliderController slider, BusType bus)
    {
        var param = GetParam(bus);
        slider.Bind(mainMixer, param);
        Debug.Log($"RegisterSlider: bus={bus}, bound slider to mixer param={param}");
        _sliders[bus] = slider;

        if (mainMixer.GetFloat(param, out float db))
            Debug.Log($"  mixer reports {db} dB for {bus}");

        //float lin = DecibelsToLinear(db);
        //slider.SetValue(lin, notify: false);

        float normalized = EvaluatePercentFromDb(db);
        Debug.Log($"  normalized slider value for {bus} → {normalized:P0}");
        slider.SetValue(normalized, notify: false);

        switch (bus)
        {
            case BusType.Instruments:
                slider.RegisterOnChanged(SetInstrumentsVolume);
                break;
            case BusType.Music:
                slider.RegisterOnChanged(SetMusicVolume);
                break;
            case BusType.Ambience:
                slider.RegisterOnChanged(SetAmbienceVolume);
                break;
        }

        Debug.Log($"  bound {bus} slider → {param}");
    }

    /// <summary>Sets the current level name for preferences.</summary>
    public void SetCurrentLevel(string levelName)
    {
        currentLevelName = levelName;
        prefsLoadedForCurrentLevel = false;
        Debug.Log($"AudioMixManager: Current level set to {levelName}");
    }

    /// <summary>
    /// Moves every bus back to normalized 0.8 (→ your 0 dB point).
    /// </summary>
    public void ResetAllVolumes()
    {
        const float defaultLevel = DefaultNormalizedZeroDb;
        Debug.Log($"ResetAllVolumes() → setting all sliders to {defaultLevel:P0}");

        foreach (var kv in _sliders)
        {
            Debug.Log($"  resetting {kv.Key}");
            kv.Value.SetValue(defaultLevel);
        }
    }

    private string GetParam(BusType b) => b switch
    {
        BusType.Music => MUSIC_PARAM,
        BusType.Ambience => AMBIENCE_PARAM,
        BusType.Instruments => INSTRUMENTS_PARAM,
        _ => throw new ArgumentOutOfRangeException()
    };

    public void SetInstrumentsVolume(float linear)
    {
        float db = SliderToDecibels(linear);
        Debug.Log($"SetInstrumentsVolume({linear:F2}) → {db:F1}dB");
        mainMixer.SetFloat(INSTRUMENTS_PARAM, db);
        // Added: Save user volume preference for Instruments
        string levelKey = !string.IsNullOrEmpty(currentLevelName) ? currentLevelName : SceneManager.GetActiveScene().name;
        PlayerPrefs.SetFloat(levelKey + "_Volume_Instruments", linear);
    }

    public void SetMusicVolume(float linear)
    {
        float db = SliderToDecibels(linear);
        Debug.Log($"SetMusicVolume({linear:F2}) → {db:F1}dB");
        mainMixer.SetFloat(MUSIC_PARAM, db);
        // Added: Save user volume preference for Music
        string levelKey = !string.IsNullOrEmpty(currentLevelName) ? currentLevelName : SceneManager.GetActiveScene().name;
        PlayerPrefs.SetFloat(levelKey + "_Volume_Music", linear);
    }

    public void SetAmbienceVolume(float linear)
    {
        float db = SliderToDecibels(linear);
        Debug.Log($"SetAmbienceVolume({linear:F2}) → {db:F1}dB");
        mainMixer.SetFloat(AMBIENCE_PARAM, db);
        // Added: Save user volume preference for Ambience
        string levelKey = !string.IsNullOrEmpty(currentLevelName) ? currentLevelName : SceneManager.GetActiveScene().name;
        PlayerPrefs.SetFloat(levelKey + "_Volume_Ambience", linear);
    }

    [SerializeField]
    private AnimationCurve volumePanelCurve = new AnimationCurve(
        new Keyframe(0f, -80f),
        new Keyframe(DefaultNormalizedZeroDb, 0f),
        new Keyframe(1f, 10f)
    );

    private float SliderToDecibels(float t)
    {
        return Mathf.Clamp(volumePanelCurve.Evaluate(t), -80f, 10f);
    }

    /// <summary>
    /// Returns the dB level at normalized [0…1] using the volumePanelCurve.
    /// </summary>
    public float EvaluateDb(float normalized)
    {
        return SliderToDecibels(normalized);
    }

    public float EvaluatePercentFromDb(float db)
    {
        float target = Mathf.Clamp(db, MuteDb, maxDb);
        if (target <= MuteDb) return 0f;
        if (target >= maxDb) return 1f;

        float low = 0f, high = 1f, mid = 0f;
        for (int i = 0; i < 20; i++)
        {
            mid = 0.5f * (low + high);
            if (SliderToDecibels(mid) < target)
                low = mid;
            else
                high = mid;
        }
        return mid;
    }

    /// <summary>
    /// The “mute” dB value — i.e. the bottom of the curve, at normalized 0 → –80 dB.
    /// </summary>
    public float MuteDb
    {
        get { return SliderToDecibels(0f); }
    }

    private float DecibelsToLinear(float db)
    {
        return Mathf.Pow(10f, db / 20f);
    }

    public void LoadAudioSnapshot(AudioMixerSnapshot snapshot)
    {
        snapshot.TransitionTo(0f);
    }

    public void LoadDefaultMixer(bool fadeInHomescreen = true)
    {
        defaultMix.TransitionTo(0f);

        if (fadeInHomescreen)
        {
            FadeInHomeScreenMixer();
        }
    }

    /// <summary>
    /// Apply saved volume slider values and mute states for the current level (from PlayerPrefs).
    /// </summary>
    private void ApplySavedVolumes()
    {
        if (prefsLoadedForCurrentLevel) return;
        string levelKey = !string.IsNullOrEmpty(currentLevelName) ? currentLevelName : SceneManager.GetActiveScene().name;
        foreach (var kv in _sliders)
        {
            BusType bus = kv.Key;
            SliderController slider = kv.Value;
            string volumeKey = levelKey + "_Volume_" + bus;
            string muteKey = levelKey + "_Mute_" + bus;
            bool isMutedPref = PlayerPrefs.HasKey(muteKey) ? PlayerPrefs.GetInt(muteKey) == 1 : false;
            if (isMutedPref)
            {
                // If muted, set slider to 0 but keep stored value for unmute
                float storedValue = PlayerPrefs.HasKey(volumeKey) ? PlayerPrefs.GetFloat(volumeKey) : DefaultNormalizedZeroDb;
                slider.lastSliderValue = storedValue;
                slider.SetValue(0f, notify: false);
                slider.SetMutedState(true);
                mainMixer.SetFloat(GetParam(bus), MuteDb);
            }
            else
            {
                // Not muted: if we have a stored volume, apply it
                if (PlayerPrefs.HasKey(volumeKey))
                {
                    float storedValue = PlayerPrefs.GetFloat(volumeKey);
                    slider.SetValue(storedValue, notify: false);
                    mainMixer.SetFloat(GetParam(bus), EvaluateDb(storedValue));
                }
            }
        }
        prefsLoadedForCurrentLevel = true;
    }

    #region  Home-screen mixer fading  (restored)

    public void FadeOutHomeScreenMixer(float duration = 2f)
    {
        StartCoroutine(FadeHomeScreenMixerCoroutine(duration, true));
    }

    public void FadeInHomeScreenMixer(float duration = 2f)
    {
        StartCoroutine(FadeHomeScreenMixerCoroutine(duration, false));
    }

    private IEnumerator FadeHomeScreenMixerCoroutine(float duration, bool fadeOut)
    {
        const string MIX_PARAM = "HomeDroneVol";

        mainMixer.GetFloat(MIX_PARAM, out float startDb);

        float targetDb = fadeOut ? -80f : 0f;          // -80 dB ≈ silent
        float t = 0f;
        while (t < duration)
        {
            t += Time.deltaTime;
            float lerpDb = Mathf.Lerp(startDb, targetDb, t / duration);
            mainMixer.SetFloat(MIX_PARAM, lerpDb);
            yield return null;
        }
        mainMixer.SetFloat(MIX_PARAM, targetDb);        // clamp exactly
    }
    #endregion

}
