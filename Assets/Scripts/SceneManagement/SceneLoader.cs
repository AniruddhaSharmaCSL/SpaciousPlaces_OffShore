using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;
using static UnityEngine.InputSystem.InputAction;

namespace SpaciousPlaces
{
    public class SceneLoader : Singleton<SceneLoader>
    {
        public static SceneLoader Instance;
        [SerializeField] OVRScreenFade ScreenFade = null;

        public UnityEvent onSceneLoadStart = new UnityEvent();
        public UnityEvent onSceneLoadFinish = new UnityEvent();
        public UnityEvent onBeforeUnload = new UnityEvent();

        bool m_isLoading = false;

        Scene m_persistentScene;
        string m_currentScene = null;
        SPLevel m_currentLevel;

        private string m_lastScene = null;

        override protected void Awake()
        {
            if (Instance == null)
            {
                Instance = this;
            }

            SceneManager.sceneLoaded += SetActiveScene;

            if (OVRManager.display != null)
            {
                OVRManager.display.RecenteredPose += () =>
                {
                    SceneUtils.AlignXRRig(SceneManager.GetSceneByName(m_currentScene));
                };
            }

            if (!Application.isEditor)
            {
                m_persistentScene = SceneManager.GetActiveScene();

                int sceneCount = SceneManager.sceneCountInBuildSettings;

                if (sceneCount > 1)
                {
                    SceneManager.LoadSceneAsync(1, LoadSceneMode.Additive);
                }
                else
                {
                    Debug.LogError("No scenes other than Persistent found");
                }
            }
            else
            {
                m_persistentScene = SceneManager.GetSceneByName(SceneUtils.Names.XRPersistency);
                SetActiveScene(SceneManager.GetSceneAt(1), LoadSceneMode.Additive);
            }
        }

        private void OnDestroy()
        {
            SceneManager.sceneLoaded -= SetActiveScene;
        }

        public void LoadPreviousScene(CallbackContext context)
        {
            LoadPreviousScene();
        }

        public Transform getCenterEyeAnchor()
        {
            return ScreenFade.transform;
        }

        public void LoadPreviousScene()
        {
            //avoid race condition
            //if (m_isLoading) { return; }

            // Send analytics before changing scene state
            if (m_currentScene != null)
            {
                var currentScene = SceneManager.GetActiveScene();
                //SceneAnalytics.SendLevelClosed(currentScene, m_currentLevel?.levelTitle);
            }

            if (m_lastScene != null && m_lastScene != SceneUtils.Names.XRPersistency && m_currentScene != SceneUtils.Names.Home)
            {
                LoadScene(m_lastScene, null);
            }
            else if (m_currentScene != SceneUtils.Names.Home)
            {
                // If there's no previous scene or we're not already in Home, go to Home
                LoadScene(SceneUtils.Names.Home, null);
            }
        }

        public void LoadScene(string sceneName, SPLevel level)
        {
            if (m_isLoading) { return; }

            m_lastScene = m_currentScene;
            m_currentLevel = level;
            StartCoroutine(Load(sceneName));
        }

        void SetActiveScene(Scene scene, LoadSceneMode mode)
        {
            if (scene == m_persistentScene) { return; } // Avoid setting the persistent scene as active if it's loaded after the "Content"/current scene

            SceneManager.SetActiveScene(scene);
            m_currentScene = scene.name;

            SetLevelData(scene, mode);

            Transform xrRigOrigin = SceneUtils.GetRigOrigin(scene);

            if (xrRigOrigin != null)
            {
                SceneUtils.AlignXRRig(scene);
            }
            else
            {
                Debug.Log("xr rig origin not found, didnt align");
            }
        }

        void SetLevelData(Scene scene, LoadSceneMode mode)
        {
            if (m_currentLevel != null)
            {
                SceneUtils.LoadLevelData(scene, m_currentLevel);
            }
        }

        IEnumerator Load(string sceneName)
        {
            m_isLoading = true;

            onSceneLoadStart?.Invoke();
            onBeforeUnload?.Invoke();

            yield return FadeOut();

            yield return StartCoroutine(UnloadCurrentScene());

            yield return LoadNewScene(sceneName);

            // Skip waiting for level load if loading Home scene
            if (sceneName == SceneUtils.Names.Home)
            {
                // For Home scene, fade in immediately
                yield return FadeIn();
                onSceneLoadFinish?.Invoke();
            }
            else
            {
                // For other scenes, check if they have a LevelLoader
                StartCoroutine(WaitForLevelLoadedThenFadeIn());
            }

            m_isLoading = false;
            m_currentScene = sceneName;
        }

        IEnumerator UnloadCurrentScene()
        {
            Scene sceneToUnload;

            if (m_currentScene != null)
            {
                sceneToUnload = SceneManager.GetSceneByName(m_currentScene);
            }
            else
            {
                sceneToUnload = SceneManager.GetActiveScene();
            }

            // Send analytics before unloading
            if (sceneToUnload.name != SceneUtils.Names.XRPersistency)
            {
                SceneAnalytics.SendLevelClosed(sceneToUnload, m_currentLevel?.levelTitle);
            }

            AsyncOperation unload = SceneManager.UnloadSceneAsync(sceneToUnload);

            while (!unload.isDone)
            {
                yield return null;
            }
        }

        IEnumerator LoadNewScene(string sceneName)
        {
            if (sceneName == SceneUtils.Names.Home)
            {
                // Reset to default mixer on Home Screen
                AudioMixManager.Instance.LoadDefaultMixer(true);
            }

            else
            {
                AudioMixManager.Instance.FadeOutHomeScreenMixer();
            }

            AsyncOperation load = SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Additive);

            while (!load.isDone)
            {
                yield return null;
            }
        }

        IEnumerator FadeOut()
        {
            // Start the fade out effect
            ScreenFade.FadeOut();

            // Wait for the fade duration
            float fadeDuration = ScreenFade.fadeTime;
            yield return new WaitForSeconds(fadeDuration);
        }

        IEnumerator FadeIn()
        {
            // Start the fade in effect
            ScreenFade.FadeIn();

            // Wait for the fade duration
            float fadeDuration = ScreenFade.fadeTime;
            yield return new WaitForSeconds(fadeDuration);
        }

        IEnumerator WaitForLevelLoadedThenFadeIn()
        {
            // Wait one frame for the scene to initialize
            yield return null;

            // Find the LevelLoader in the scene that was just loaded
            LevelLoader levelLoader = Object.FindObjectOfType<LevelLoader>();

            if (levelLoader == null)
            {
                // No LevelLoader found - just fade in immediately
                Debug.Log("No LevelLoader found in the loaded scene - fading in immediately");
                yield return FadeIn();
                onSceneLoadFinish?.Invoke();
                yield break;
            }

            // Subscribe to the static event
            bool levelLoadComplete = levelLoader.IsLevelLoaded;
            UnityAction levelLoadedHandler = () => {
                Debug.Log("SceneLoader: Level load complete");
                levelLoadComplete = true; 
            };

            LevelLoader.OnLevelLoaded.AddListener(levelLoadedHandler);

            // Wait until the level is loaded
            float timeout = 30f;
            float timer = 0f;

            while (!levelLoadComplete && timer < timeout)
            {
                timer += Time.deltaTime;
                yield return null;
            }

            // Clean up the event listener
            LevelLoader.OnLevelLoaded.RemoveListener(levelLoadedHandler);

            onSceneLoadFinish?.Invoke();

            // Now that the level is loaded (or we've timed out), fade in
            yield return FadeIn();
        }
    }
}
