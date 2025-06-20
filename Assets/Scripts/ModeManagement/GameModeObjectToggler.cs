using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SpaciousPlaces;  // Add namespace for LevelLoader

public class GameModeObjectToggler : MonoBehaviour
{
    [Header("In-Scene References")]
    [SerializeField] private List<GameObject> InstrumentObjects = new List<GameObject>();
    [SerializeField] private List<GameObject> CreativeObjects = new List<GameObject>();
    [SerializeField] private List<GameObject> BreathingObjects = new List<GameObject>();

    [Header("Cross-Scene Objects (by name)")]
    [SerializeField] private string[] InstrumentObjectNames = new string[0];
    [SerializeField] private string[] CreativeObjectNames = new string[0];
    [SerializeField] private string[] BreathingObjectNames = new string[0];

    private GameObject[] crossSceneCreativeObjects;
    private GameObject[] crossSceneInstrumentObjects;
    private GameObject[] crossSceneBreathingObjects;

    private GameObject danceRingParticles;
    private GameObject smallDanceRingParticles;
    private LevelLoader levelLoader;

    // Start is called before the first frame update
    void Start()
    {
        // Find all cross-scene creative objects by name
        crossSceneCreativeObjects = new GameObject[CreativeObjectNames.Length];
        for (int i = 0; i < CreativeObjectNames.Length; i++)
        {
            crossSceneCreativeObjects[i] = GameObject.Find(CreativeObjectNames[i]);
            if (crossSceneCreativeObjects[i] == null)
            {
                Debug.LogWarning($"GameModeObjectToggler: Could not find cross-scene creative object named {CreativeObjectNames[i]}");
            }

            // Store references to particle systems if we find them
            if (CreativeObjectNames[i] == "DanceRingParticles")
            {
                danceRingParticles = crossSceneCreativeObjects[i];
            }
            else if (CreativeObjectNames[i] == "SmallDanceRingParticles")
            {
                smallDanceRingParticles = crossSceneCreativeObjects[i];
            }
        }

        // Find all cross-scene instrument objects by name
        crossSceneInstrumentObjects = new GameObject[InstrumentObjectNames.Length];
        for (int i = 0; i < InstrumentObjectNames.Length; i++)
        {
            crossSceneInstrumentObjects[i] = GameObject.Find(InstrumentObjectNames[i]);
            if (crossSceneInstrumentObjects[i] == null)
            {
                Debug.LogWarning($"GameModeObjectToggler: Could not find cross-scene instrument object named {InstrumentObjectNames[i]}");
            }
        }

        // Find all cross-scene breathing objects by name
        crossSceneBreathingObjects = new GameObject[BreathingObjectNames.Length];
        for (int i = 0; i < BreathingObjectNames.Length; i++)
        {
            crossSceneBreathingObjects[i] = GameObject.Find(BreathingObjectNames[i]);
            if (crossSceneBreathingObjects[i] == null)
                Debug.LogWarning($"GameModeObjectToggler: Could not find cross-scene breathing object named {BreathingObjectNames[i]}");
        }

        // Get LevelLoader reference
        levelLoader = FindObjectOfType<LevelLoader>();

        ModeManager.Instance.OnGameModeChanged.AddListener(OnGameModeChanged);

        // Set initial state
        OnGameModeChanged(ModeManager.Instance.CurrentMode);

        LevelLoader.OnLevelLoaded.AddListener(OnLevelSettingsChanged);
        OnLevelSettingsChanged();
    }

    private void OnDestroy()
    {
        if (ModeManager.Instance != null)
        {
            ModeManager.Instance.OnGameModeChanged.RemoveListener(OnGameModeChanged);
        }

        //temporarily added 
        LevelLoader.OnLevelLoaded.RemoveListener(OnLevelSettingsChanged);
    }

    /*
    private void OnGameModeChanged(ModeManager.GameMode mode)
    {
        if (mode == ModeManager.GameMode.Instrument)
        {
            foreach (GameObject obj in InstrumentObjects)
            {
                if (obj != null) obj.SetActive(true);
            }
            foreach (GameObject obj in crossSceneInstrumentObjects)
            {
                if (obj != null) obj.SetActive(true);
            }
            foreach (GameObject obj in CreativeObjects)
            {
                if (obj != null) obj.SetActive(false);
            }
            foreach (GameObject obj in crossSceneCreativeObjects)
            {
                if (obj != null) obj.SetActive(false);
            }
            // Show/hide platform particles based on level setting in Instrument mode
            UpdateParticleVisibility();
        }
        else
        {
            foreach (GameObject obj in InstrumentObjects)
            {
                if (obj != null) obj.SetActive(false);
            }
            foreach (GameObject obj in crossSceneInstrumentObjects)
            {
                if (obj != null) obj.SetActive(false);
            }
            foreach (GameObject obj in CreativeObjects)
            {
                if (obj != null) obj.SetActive(true);
            }
            foreach (GameObject obj in crossSceneCreativeObjects)
            {
                if (obj != null) obj.SetActive(true);
            }
            // Always show particles in Creative mode
            if (danceRingParticles != null) danceRingParticles.SetActive(true);
            if (smallDanceRingParticles != null) smallDanceRingParticles.SetActive(true);
        }
    }
    */

    private void OnGameModeChanged(ModeManager.GameMode mode)
    {
        switch (mode)
        {
            case ModeManager.GameMode.Instrument:
                SetActive(CreativeObjects, false);
                SetActive(BreathingObjects, false);
                SetActive(InstrumentObjects, true);

                SetActive(crossSceneCreativeObjects, false);
                SetActive(crossSceneBreathingObjects, false);
                SetActive(crossSceneInstrumentObjects, true);
                UpdateParticleVisibility();
                break;

            case ModeManager.GameMode.Creative:
                SetActive(InstrumentObjects, false);
                SetActive(BreathingObjects, false);
                SetActive(CreativeObjects, true);

                SetActive(crossSceneInstrumentObjects, false);
                SetActive(crossSceneBreathingObjects, false);
                SetActive(crossSceneCreativeObjects, true);

                // particles always on in Creative
                if (danceRingParticles) danceRingParticles.SetActive(true);
                if (smallDanceRingParticles) smallDanceRingParticles.SetActive(true);
                break;

            case ModeManager.GameMode.Breathing:
                SetActive(InstrumentObjects, false);
                SetActive(CreativeObjects, false);
                SetActive(BreathingObjects, true);

                SetActive(crossSceneInstrumentObjects, false);
                SetActive(crossSceneCreativeObjects, false);
                SetActive(crossSceneBreathingObjects, true);

                // turn platform particles off for a calm scene
                if (danceRingParticles) danceRingParticles.SetActive(false);
                if (smallDanceRingParticles) smallDanceRingParticles.SetActive(false);
                break;
        }
    }

    private static void SetActive(IEnumerable<GameObject> list, bool active)
    {
        if (list == null) return;
        foreach (var go in list)
            if (go) go.SetActive(active);
    }

    private void UpdateParticleVisibility() // for toggling during Instrument Mode from SPLevel. Currently disabled
    {
        if (levelLoader == null)
        {
            levelLoader = FindObjectOfType<LevelLoader>();
        }

        bool showParticles = false; // Default to not showing if no level data

        if (levelLoader != null && levelLoader.CurrentLevel != null)
        {
            //showParticles = levelLoader.CurrentLevel.platformParticles;
        }

        // Only update particle visibility if we're in Instrument mode
        if (ModeManager.Instance.CurrentMode == ModeManager.GameMode.Instrument)
        {
            //if (danceRingParticles != null) danceRingParticles.SetActive(showParticles);
            //if (smallDanceRingParticles != null) smallDanceRingParticles.SetActive(showParticles);
        }
    }

    // Public method to update particle visibility when level settings change
    public void OnLevelSettingsChanged()
    {
        UpdateParticleVisibility();
    }
}
