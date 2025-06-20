// MoodRegistrationManager.cs — drop-in replacement
// Based on your original file :contentReference[oaicite:3]{index=3}

using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using Unity.Services.Analytics;
using Unity.Services.Core;
using Unity.Services.Core.Environments;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace SpaciousPlaces {
    public class MoodRegistrationManager : Singleton<MoodRegistrationManager> {
        public static MoodRegistrationManager Instance;

        [SerializeField] private MoodRegistrationPanel moodPanel;
        [SerializeField] private GameObject menuPanel;
        [SerializeField] private ModeManager modeManager; // Reference to ModeManager
        private SPLevel nextLevel;  // ← new field to hold which level to load after start mood

        [Header("Settings")]
        [SerializeField] private float homeSceneTimeThreshold = 60f;
        [SerializeField] private string[] moodEmojis = { "😢", "😕", "😐", "🙂", "😄" };

        private float homeSceneEnterTime;
        private bool hasShownStart;
        private bool hasShownEnd;
        public bool isStartMood;
        private bool skipMoodForSession = false;

        public bool levelEnd = false;
        public bool launchedFromOptions = false;

        /// <summary>
        /// Store which level to load after the start-of-level mood.
        /// </summary>
        public static SPLevel  SelectedLevel = null;
        //public static SPLevel CurrentSelectedLevel = null;
        public void SetNextLevel(SPLevel level) => nextLevel = level;

        

        #region MonoBehaviour Callbacks
        protected override void Awake() {
            // Instance Created Here
            if (Instance == null) {
                Instance = this;
            }
            //Persistent Flag for the Skip Mood for the session
            skipMoodForSession = false;

            // Getting References of HomeMenuPanel and MoodRegistrationPanel
            menuPanel = IntroController.Instance.GetMenupanel();
            moodPanel = MoodRegistrationPanel.Instance; //  IntroController.Instance.GetMoodPanel();

            // Call base Awake to ensure Singleton behavior without destroying the object
            base.Awake();
            DontDestroyOnLoad(gameObject);

            // Initialize analytics and UI
            InitializeAnalytics();

            // Initialize the mood panel with emojis and callbacks and hide it initially with reference checks
            if (moodPanel != null) {
                moodPanel.Initialize(moodEmojis, OnMoodSelected, OnMoodSkipped);
                moodPanel.Hide();
            }
            else {
                Debug.Log("Mood panel Referecne is Missing!");
            }

            // Show the menu panel if it exists, otherwise log a warning
            if (menuPanel != null) {
                menuPanel.SetActive(true);
            }
            else {
                Debug.Log("Menu panel Reference is Missing!");
            }
        }
        
        public ModeManager GetModeManager() {
            return modeManager;
        }

        private void OnEnable() {
            SceneManager.sceneLoaded += OnSceneLoaded;
            SceneManager.sceneUnloaded += OnSceneUnloaded;
        }

        private void OnDisable() {
            SceneManager.sceneLoaded -= OnSceneLoaded;
            SceneManager.sceneUnloaded -= OnSceneUnloaded;
        }

        private void Update() {

        }
        #endregion

        #region Analytics Initialization
        private async void InitializeAnalytics() {
            var env = Debug.isDebugBuild ? "development" : "production";
            var options = new InitializationOptions().SetEnvironmentName(env);
            await UnityServices.InitializeAsync(options);
            AnalyticsService.Instance.StartDataCollection();
        }

        public void DeleteAnalyticsData() {
            try {
                AnalyticsService.Instance.RequestDataDeletion(); // Request deletion of analytics data
                //AnalyticsService.Instance.RequestDataDeletion();
                Debug.Log("Analytics data deleted successfully.");
            } catch (Exception e) {
                Debug.LogError($"Failed to delete analytics data: {e.Message}");
            }
        }


        #endregion

        #region Scene Management Callbacks
        private void OnSceneLoaded(Scene scene, LoadSceneMode mode) {
            HandleSceneLoadedAsync(scene, mode);
        }
        
        private async Task HandleSceneLoadedAsync(Scene scene, LoadSceneMode mode) {
            if (scene.name == SceneUtils.Names.Home) {
                // Reset flags & timer
                homeSceneEnterTime = Time.time;
                hasShownStart = hasShownEnd = false;

                // Grab and initialize the panel that's in Home
                moodPanel = IntroController.Instance.GetMoodPanel();
                if (moodPanel == null) {
                    Debug.Log("MoodRegistrationPanel not found in Home!");
                    return;
                }

                await moodPanel.Initialize(moodEmojis, OnMoodSelected, OnMoodSkipped);
                
                menuPanel = IntroController.Instance.GetMenupanel();
                if (menuPanel != null) {
                    Debug.Log("[Mood] Second");
                    CanvasGroup menuCanvasGroup = menuPanel.GetComponent<CanvasGroup>();
                    StartCoroutine(FadeCanvasGroup(menuCanvasGroup, 2f, true));
                }

                HomeMenuController.instance.Initialize(false);
            }
        }
        #endregion

        private void OnSceneUnloaded(Scene scene) {

        }

        /// <summary>
        /// Displays the start-of-level mood panel.
        /// </summary>
        public void ShowStartPanel() {
            if (moodPanel == null || hasShownStart) return;
            Debug.Log("Here1");
            isStartMood = true;
            moodPanel.SetQuestion("How are you feeling at the start of this level?");
            moodPanel.Show();
            hasShownStart = true;
        }

        /// <summary>
        /// Displays the end-of-level mood panel.
        /// </summary>
        public void ShowEndPanel() {
            moodPanel = MoodRegistrationPanel.Instance;
            moodPanel.Initialize(moodEmojis, OnMoodSelected, OnMoodSkipped);

            if (moodPanel == null || hasShownEnd || skipMoodForSession)
            {
                SceneLoader.Instance.LoadPreviousScene();
                return;
            }

            moodPanel.SetQuestion("How are you feeling after completing the level?");
            Debug.Log("How are you feeling after completing the level?");
            StartCoroutine(FadeCanvasGroup(moodPanel.canvasGroup, 2f, true));
            hasShownEnd = true;
        }

        //After the user selects a mood, this method is called to record the event and handle UI transitions
        private void OnMoodSelected(int moodValue) {
            Debug.Log("[Mood] Here9");
            var eventName = isStartMood ? "mood_registration_start" : "mood_registration_end";
            var evt = new CustomEvent(eventName)
            {
                { "moodValue",  moodValue },
                { "scene_name", SceneManager.GetActiveScene().name }
            };

            if (!isStartMood && SelectedLevel != null) {
                evt.Add("level_name", SelectedLevel.levelTitle);
                SelectedLevel = null;
            }

            AnalyticsService.Instance.RecordEvent(evt);

            Debug.Log("[Mood] Here5");

            if (moodPanel == null) {
                Debug.Log("[Mood] Mood panel reference is missing!");
            }

            StartCoroutine(FadeCanvasGroup(moodPanel.canvasGroup, 2f, false));

            // ← after capturing start mood, load the stored level

            if (!isStartMood) {
                Debug.Log("[Mood] First");
                SceneLoader.Instance.LoadPreviousScene();
            }
            else if (isStartMood && nextLevel != null) {
                Debug.Log("[Mood] Here6");

                GotoScene.Instance.Go(nextLevel);
                nextLevel = null;
                isStartMood = false;
            }

            launchedFromOptions = false;
        }

        //Level_name needs the level name
        private void OnMoodSkipped() {
            Debug.Log($"[Mood] User skipped mood capture ({(isStartMood ? "START" : "END")})");

            var eventName = isStartMood
                ? "mood_registration_start_skipped"
                : "mood_registration_end_skipped";
            var evt = new CustomEvent(eventName)
            {
                { "scene_name", SceneManager.GetActiveScene().name },
                { "level_name", SceneManager.GetActiveScene().name }
            };
            AnalyticsService.Instance.RecordEvent(evt);

            Debug.Log($"[Mood] User skipped mood capture ({(isStartMood ? "START" : "END")})");

            StartCoroutine(FadeCanvasGroup(moodPanel.canvasGroup, 2f, false));

            skipMoodForSession = true;

            //if (menuPanel != null) {
            //    StartCoroutine(FadeCanvasGroup(menuPanel.GetComponent<CanvasGroup>(), 2f, true));
            //}
            // ← after skipping start mood, load the stored level
            if (isStartMood && nextLevel != null) {
                GotoScene.Instance.Go(nextLevel);
                nextLevel = null;
                isStartMood = false;
            }
            else {
                SceneLoader.Instance.LoadPreviousScene();
            }
        }

        /*private void setNewLevel() {
            List<SPLevel> levels = HomeMenuController.instance.getSPlevelList();
            int idx = 0;
            Debug.LogError("Next Level Name : " + levels[idx].name);
            for (int i = 0; i < levels.Count; i++) {
                if (CurrentSelectedLevel.name == levels[i].name) {
                    idx = i + 1;
                    Debug.LogError("Next Level Name : " + levels[idx].name);
                    SetNextLevel(levels[idx]);
                }
            }

            SceneLoader.Instance.LoadScene(SceneUtils.Names.Home, null);

        }*/

        //Start mood and go to the next level(This is for the first time when the Game starts)
        //public void PrepareStartMoodAndGo(SPLevel level) {

        //    SetNextLevel(level);

        //    //Fade out the menu panel if it exists
        //    if (menuPanel != null) {
        //        CanvasGroup menucanvasgroup = menuPanel.GetComponent<CanvasGroup>();
        //        StartCoroutine(FadeCanvasGroup(menucanvasgroup, 2f, false));
        //    }

        //    // Set the start mood flag to true
        //    if (moodPanel != null) {
        //        if(isStartMood) {
        //            moodPanel.SetQuestion("How are you feeling at the start of this level?");
        //            StartCoroutine(FadeCanvasGroup(moodPanel.canvasGroup, 2f, true));
        //            hasShownStart = true;
        //        }
        //        else {
        //            moodPanel.Hide();
        //            GotoScene.Instance.Go(nextLevel);
        //        }
        //    }
        //}
        public void StartLevelWithMood(SPLevel level) {
            StartCoroutine(PrepareStartMoodAndGo(level));
        }

        private IEnumerator PrepareStartMoodAndGo(SPLevel level) {

            SetNextLevel(level);

            // Fade out the menu panel if it exists
            if (menuPanel != null) {
                CanvasGroup menucanvasgroup = menuPanel.GetComponent<CanvasGroup>();
                yield return StartCoroutine(FadeCanvasGroup(menucanvasgroup, 1f, false));
            }

            // Set the start mood flag to true
            if (moodPanel != null) {
                if (isStartMood) {
                    moodPanel.SetQuestion("How are you feeling at the start of this level?");
                    yield return StartCoroutine(FadeCanvasGroup(moodPanel.canvasGroup, 2f, true));
                    hasShownStart = true;
                }
                else {
                    moodPanel.Hide();
                    GotoScene.Instance.Go(nextLevel);
                }
            }
        }


        public IEnumerator FadeCanvasGroup(CanvasGroup canvasGroup, float duration, bool fadeIn, AnimationCurve fadeCurve = null) {
            if (canvasGroup == null)
                yield break;

            GameObject targetObject = canvasGroup.gameObject;
            Debug.Log("[Mood] Target Object " + targetObject.name);

            if (fadeIn) {
                Debug.Log("[Mood] Target Object Fade In " + targetObject.name);
                targetObject.SetActive(true);
                Debug.Log("[Mood] MoodCanvas Active? = " + targetObject.activeSelf);
                canvasGroup.interactable = true;
                canvasGroup.blocksRaycasts = true;
            }

            float timeElapsed = 0f;
            float startAlpha = fadeIn ? 0f : 1f;
            float endAlpha = fadeIn ? 1f : 0f;

            if (fadeCurve == null)
                fadeCurve = AnimationCurve.Linear(0, 0, 1, 1); // fallback to linear

            while (timeElapsed < duration) {
                float t = timeElapsed / duration;
                float curvedT = fadeCurve.Evaluate(t);
                if (targetObject.name == "MoodCanvas" && fadeIn) {
                    moodPanel.getQuestionText().color = new Color(moodPanel.getQuestionText().color.r, moodPanel.getQuestionText().color.g, moodPanel.getQuestionText().color.b, Mathf.Lerp(startAlpha, endAlpha, curvedT));
                    moodPanel.getSkipText().color = new Color(moodPanel.getSkipText().color.r, moodPanel.getSkipText().color.g, moodPanel.getSkipText().color.b, Mathf.Lerp(startAlpha, endAlpha, curvedT));
                }
                else if (targetObject.name == "MoodCanvas" && !fadeIn) {
                    moodPanel.getQuestionText().color = new Color(moodPanel.getQuestionText().color.r, moodPanel.getQuestionText().color.g, moodPanel.getQuestionText().color.b, endAlpha);
                    moodPanel.getSkipText().color = new Color(moodPanel.getSkipText().color.r, moodPanel.getSkipText().color.g, moodPanel.getSkipText().color.b, endAlpha);
                }
                canvasGroup.alpha = Mathf.Lerp(startAlpha, endAlpha, curvedT);
                
                timeElapsed += Time.deltaTime;
                yield return null;
            }

            canvasGroup.alpha = endAlpha;
            if (targetObject.name == "MoodCanvas") {
                moodPanel.getQuestionText().color = new Color(moodPanel.getQuestionText().color.r, moodPanel.getQuestionText().color.g, moodPanel.getQuestionText().color.b, endAlpha);
                moodPanel.getSkipText().color = new Color(moodPanel.getSkipText().color.r, moodPanel.getSkipText().color.g, moodPanel.getSkipText().color.b, endAlpha);
            }

            if (!fadeIn) {
                targetObject.SetActive(false);
                Debug.Log("[Mood] MoodCanvas Active? = " + targetObject.activeSelf);
                canvasGroup.interactable = true;
                canvasGroup.blocksRaycasts = true;
            }
        }
    }
}
