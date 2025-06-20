using System.Collections;
using System.Collections.Generic;
using Unity.Services.Analytics;
using Unity.Services.Core;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneAnalytics : MonoBehaviour
{
    private const string PersistencyScene = "XR Persistency";
    private float _enterTime;
    private static string _levelTitle = "";   // static so the static methods can use it
    private static bool _isInitialized = false;

    private async void Awake()
    {
        DontDestroyOnLoad(gameObject);     // keep this object alive across scene loads
        
        try
        {
            // Initialise the core UGS SDK (downloads config, checks env‑IDs, etc.)
            await UnityServices.InitializeAsync();

            // Begin sending automatic and custom events
            AnalyticsService.Instance.StartDataCollection();
            _isInitialized = true;
            Debug.Log("Unity Analytics initialized successfully");
        }
        catch (System.Exception e)
        {
            Debug.LogWarning($"Failed to initialize Unity Analytics: {e.Message}");
            _isInitialized = false;
        }
    }

    private void OnEnable()
    {
        SceneManager.sceneLoaded += OnSceneLoaded;
        SceneManager.sceneUnloaded += OnSceneUnloaded;
    }

    private void OnDisable()
    {
        SceneManager.sceneLoaded -= OnSceneLoaded;
        SceneManager.sceneUnloaded -= OnSceneUnloaded;
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        _enterTime = Time.realtimeSinceStartup;

        if (scene.name == PersistencyScene)
            return;                      // never log the permanent container

        SceneManager.SetActiveScene(scene);
        SendLevelOpened(scene, null);
    }

    /// <summary>
    /// Other scripts can call this when they know the SPLevel title.
    /// </summary>
    public static void SendLevelOpened(Scene scene, string levelTitle)
    {
        _levelTitle = levelTitle;

        if (!_isInitialized || AnalyticsService.Instance == null)
        {
            Debug.LogWarning("Analytics not initialized - will retry level_opened event");
            Instance.StartCoroutine(RetrySendLevelOpened(scene, levelTitle));
            return;
        }

        try
        {
            AnalyticsService.Instance.RecordEvent(
                new CustomEvent("level_opened")
                {
                    { "userLevel", scene.buildIndex },
                    { "scene_name", scene.name },
                    { "level_name", levelTitle }
                });

            // Try to flush, but catch any exceptions if it's already flushing
            try
            {
                AnalyticsService.Instance.Flush();
            }
            catch (System.Exception e)
            {
                Debug.LogWarning($"Failed to flush analytics: {e.Message}");
            }

            Debug.Log($"Analytics event level_opened — {scene.name} | {levelTitle}");
        }
        catch (System.Exception e)
        {
            Debug.LogWarning($"Failed to send level_opened analytics: {e.Message}");
        }
    }

    private static IEnumerator RetrySendLevelOpened(Scene scene, string levelTitle)
    {
        int retryCount = 0;
        const int maxRetries = 30;  // Increased from 10 to 30
        const float retryDelay = 1.0f;  // Increased from 0.5 to 1.0 seconds

        while ((!_isInitialized || AnalyticsService.Instance == null) && retryCount < maxRetries)
        {
            yield return new WaitForSeconds(retryDelay);
            retryCount++;
            
            if (_isInitialized && AnalyticsService.Instance != null)
            {
                Debug.Log($"Analytics service initialized after {retryCount} retries ({retryCount * retryDelay} seconds)");
                SendLevelOpened(scene, levelTitle);
                yield break;
            }
            
            if (retryCount % 5 == 0)  // Log every 5 retries
            {
                Debug.Log($"Waiting for analytics initialization... Attempt {retryCount}/{maxRetries} ({(retryCount * retryDelay):F1} seconds)");
            }
        }

        if (!_isInitialized || AnalyticsService.Instance == null)
        {
            Debug.LogWarning($"Failed to send level_opened analytics after {maxRetries} retries ({maxRetries * retryDelay} seconds) - analytics service not initialized");
        }
    }

    /*────────────────────────── SCENE CLOSE ────────────────────────*/

    private void OnSceneUnloaded(Scene scene)
    {
        if (scene.name == PersistencyScene) return;

        // If something else called SendLevelClosed already, skip duplicates
        //if (scene.name != _currentSceneName) return;

        SendLevelClosed(scene, _levelTitle);

    }

    public static void SendLevelClosed(Scene scene, string levelTitle)
    {
        if (!_isInitialized)
        {
            Debug.LogWarning("Analytics not initialized - skipping level_closed event");
            return;
        }

        try
        {
            float elapsed = Time.realtimeSinceStartup - Instance._enterTime;

            AnalyticsService.Instance.RecordEvent(
                new CustomEvent("level_closed")
                {
                    { "userLevel", scene.buildIndex },
                    { "scene_name", scene.name },
                    { "level_name", levelTitle },
                    { "elapsed_seconds", elapsed}
                });

            // If you want to force‑flush in the Editor:
            AnalyticsService.Instance.Flush();
            
            Debug.Log($"Analytics event level_closed — {scene.name} | {levelTitle} | {elapsed:F2} seconds");
        }
        catch (System.Exception e)
        {
            Debug.LogWarning($"Failed to send level_closed analytics: {e.Message}");
        }
    }

    // simple singleton so we have one persistent publisher
    private static SceneAnalytics _instance;
    private static SceneAnalytics Instance
        => _instance ??= FindObjectOfType<SceneAnalytics>();
}
