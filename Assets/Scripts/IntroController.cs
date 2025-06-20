using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.Events;

namespace SpaciousPlaces
{
    public class IntroController : MonoBehaviour
    {
        static bool introPlayed = false;

        public static IntroController Instance;

        [SerializeField] GameObject rigStart;
        [SerializeField] GameObject rigEnd;
        [SerializeField] GameObject logo;
        [SerializeField] GameObject homeCanvas;
        // [SerializeField] Material fadeMaterial;
        [SerializeField] GameObject logoText;

        [SerializeField] AudioMixerGroup musicMixerGroup;
        [SerializeField, Range(0.1f, 10f)] float musicFadeInDuration = 5f;
        [SerializeField, Range(0.1f, 5f)] float cameraMoveSpeed = 1f;
        [SerializeField, Range(0.1f, 5f)] float finalAnimationDuration = 1f;
        [SerializeField] AnimationCurve cameraMovementCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);
        [SerializeField] AnimationCurve volumeFadeCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);
        [SerializeField]
        AnimationCurve fadeCurve = new AnimationCurve(
            new Keyframe(0, 0, 0, 0),      // Start flat
            new Keyframe(0.4f, 0.05f, 0, 0.1f),  // Stay low for 40% of the time
            new Keyframe(0.8f, 0.9f, 1.5f, 1.5f),  // Steeper ramp up
            new Keyframe(1, 1, 1f, 0)    // Smooth finish
        );
        [SerializeField] AnimationCurve logoMovementCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);

        [SerializeField] private float logoStartScale = 3f;

        [SerializeField] EventRelay OnIntroStart;
        [SerializeField] EventRelay OnIntroComplete;
        [SerializeField] private MoodRegistrationPanel moodPanel;

        private Transform xrRig;
        private bool isFading = false;
        private float fadeStartTime;
        private CanvasGroup activeCanvasGroup;
        private float logoTargetScale;

        Vector3 logoStartPos;
        Vector3 logoEndPos;


        private void Awake()
        {
            if (Instance == null)
            {
                Instance = this;
            }
        }

        private void Start()
        {
            if (introPlayed)
            {
                return;
            }

            introPlayed = true;

            xrRig = SceneUtils.GetRig();

            if (xrRig != null)
            {
                xrRig.position = rigStart.transform.position;
                xrRig.rotation = rigStart.transform.rotation;
            }

            if (homeCanvas != null)
            {
                activeCanvasGroup = homeCanvas.GetComponentInChildren<CanvasGroup>();

                if (activeCanvasGroup == null)
                {
                    // for uncurved canvas
                    activeCanvasGroup = homeCanvas.GetComponent<CanvasGroup>();
                }

                if (activeCanvasGroup != null)
                {
                    activeCanvasGroup.alpha = 0f;
                }
            }

            /* if (fadeMaterial != null)
             {
                 Color startColor = fadeMaterial.color;
                 startColor.a = 0f;
                 fadeMaterial.color = startColor;
             }*/

            if (logo != null)
            {
                logoStartPos = logo.transform.position;
                logoEndPos = logoStartPos;

                logoStartPos.y = 0f;

                logo.transform.position = logoStartPos;
            }

            if (logoText != null)
            {
                logoTargetScale = logoText.transform.localScale.x;
                logoText.transform.localScale = logoStartScale * Vector3.one;
            }

            StartCoroutine(PlayIntroSequence());
        }

        private float currentFadeTime = 0f;

        private void Update()
        {
            if (!isFading)
            {
                return;
            }

            currentFadeTime += Time.deltaTime;
            float progress = Mathf.Clamp01(currentFadeTime / finalAnimationDuration);
            float fadeProgress = fadeCurve.Evaluate(progress);

            if (activeCanvasGroup != null)
            {
                Debug.Log($"Setting canvas group alpha to {fadeProgress}");
                activeCanvasGroup.alpha = fadeProgress;
            }

            /* if (fadeMaterial != null)
             {
                 Color currentColor = fadeMaterial.color;
                 currentColor.a = fadeProgress;
                 fadeMaterial.color = currentColor;
             }*/

            if (progress >= 1f)
            {
                OnIntroComplete?.Raise();

                isFading = false;

                // Set fade time lower for fades after intro 
                OVRScreenFade fade = FindAnyObjectByType<OVRScreenFade>();

                if (fade != null)
                {
                    fade.fadeTime = 1f;
                }
            }
        }

        public GameObject GetMenupanel()
        {
            return homeCanvas;
        }

        public MoodRegistrationPanel GetMoodPanel() {

            return moodPanel;
        }

        private IEnumerator PlayIntroSequence()
        {
            StartCoroutine(FadeMusicIn());

            // Move camera
            float journeyLength = Vector3.Distance(rigStart.transform.position, rigEnd.transform.position);
            float elapsedTime = 0f;
            OnIntroStart?.Raise();

            while (elapsedTime <= journeyLength / cameraMoveSpeed)
            {
                elapsedTime += Time.deltaTime;
                float fractionOfJourney = Mathf.Clamp01(elapsedTime / (journeyLength / cameraMoveSpeed));

                if (xrRig != null)
                {
                    float curvedProgress = cameraMovementCurve.Evaluate(fractionOfJourney);
                    xrRig.position = Vector3.Lerp(
                        rigStart.transform.position,
                        rigEnd.transform.position,
                        curvedProgress
                    );
                }

                if (logoText != null)
                {
                    // Move logo
                    float curvedProgress = logoMovementCurve.Evaluate(fractionOfJourney);

                    logoText.transform.localScale = Vector3.Lerp(Vector3.one * logoStartScale, Vector3.one * logoTargetScale, curvedProgress);
                    logo.transform.position = Vector3.Lerp(logoStartPos, logoEndPos, curvedProgress);
                }

                yield return null;
            }
            MoodRegistrationManager.Instance.isStartMood = true;
            // Start fades
            fadeStartTime = Time.time;
            isFading = true;
        }

        private IEnumerator FadeMusicIn()
        {
            if (musicMixerGroup == null) yield break;

            float startVolume = -80f;
            float targetVolume = 0f;
            musicMixerGroup.audioMixer.GetFloat("HomeDroneVol", out startVolume);

            float elapsedTime = 0f;

            musicMixerGroup.audioMixer.SetFloat("HomeDroneVol", startVolume);

            while (elapsedTime <= musicFadeInDuration)
            {
                elapsedTime += Time.deltaTime;
                float progress = Mathf.Clamp01(elapsedTime / musicFadeInDuration);
                float curvedProgress = volumeFadeCurve.Evaluate(progress);
                float currentVolume = Mathf.Lerp(startVolume, targetVolume, curvedProgress);
                musicMixerGroup.audioMixer.SetFloat("HomeDroneVol", currentVolume);
                yield return null;
            }

            // Ensure we hit exactly the target volume
            musicMixerGroup.audioMixer.SetFloat("HomeDroneVol", targetVolume);
        }
    }
}