using System;
using TMPro;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.Events;
using UnityEngine.SceneManagement;  // Added for PlayerPrefs key management
using UnityEngine.UI;
using UnityEngine.Rendering;

namespace VRUIP
{
    public enum BusType { Instruments, Music, Ambience }

    public class SliderController : A_ColorController
    {
        [Header("Customize")]
        [SerializeField] private bool showPercentage;
        [SerializeField] private bool showText;
        [SerializeField] private bool showIcon;
        [SerializeField]
        [Tooltip("If clickable, clicking volume will mute and disable slider")]
        private bool iconClickable;
        [SerializeField] private bool showDecimals = true;
        [SerializeField] private string sliderTextValue;

        [Header("Colors")]
        [SerializeField] private Color emptyColor;
        [SerializeField] private Color fillColor;
        [SerializeField] private Color pressedColor;
        [SerializeField] private Color textColor;

        [Header("Components")]
        [SerializeField] private Slider slider;
        [SerializeField] private IconController muteIcon;
        [SerializeField] private IconController resetIcon;
        [SerializeField] private TextMeshProUGUI percentageText;
        [SerializeField] private TextMeshProUGUI sliderText;
        [SerializeField] private Image emptyImage;
        [SerializeField] private Image fillImage;

        private AudioMixer mixer;
        private string volumeParameter;
        public float lastSliderValue = 1f;
        private bool isMuted = false;

        [SerializeField] private BusType busType;  // set this in each slider prefab
        public BusType BusType => busType;

        /// <summary>
        /// Called by AudioMixManager to wire up audio.
        /// </summary>
        public void Bind(AudioMixer mixer, string parameterName)
        {
            this.mixer = mixer;
            this.volumeParameter = parameterName;
        }

        private void Awake()
        {
            SetupSlider();
            slider.onValueChanged.AddListener(OnSliderChanged);
        }

        [ContextMenu("Setup Slider (VRUIP)")]
        private void SetupSlider()
        {
            sliderText.gameObject.SetActive(showText);
            sliderText.color = textColor;
            sliderText.text = sliderTextValue;
            percentageText.gameObject.SetActive(showPercentage);
            percentageText.color = textColor;
            SetPercentageText(slider.value);
            slider.onValueChanged.AddListener(SetPercentageText);
            emptyImage.color = emptyColor;
            fillImage.color = fillColor;

            if (muteIcon != null)
            {
                muteIcon.gameObject.SetActive(showIcon);
                muteIcon.button.interactable = iconClickable;
                muteIcon.interactable = iconClickable;
                muteIcon.button.onClick.AddListener(OnMuteClicked);
            }

            if (resetIcon != null)
            {
                resetIcon.button.onClick.AddListener(OnResetClicked);
                resetIcon.gameObject.SetActive(true);
                resetIcon.button.interactable = true;
                resetIcon.interactable = true;
            }
        }

        private void OnResetClicked()
        {
            AudioMixManager.Instance.ResetAllVolumes();
        }

        private void OnMuteClicked()
        {
            // Added: Handle mute toggle with PlayerPrefs
            string levelKey = AudioMixManager.Instance != null && !string.IsNullOrEmpty(AudioMixManager.Instance.CurrentLevelName)
                                ? AudioMixManager.Instance.CurrentLevelName
                                : SceneManager.GetActiveScene().name;
            string volumeKey = levelKey + "_Volume_" + busType;
            string muteKey = levelKey + "_Mute_" + busType;
            if (!isMuted)
            {
                // Cache current volume and mute
                lastSliderValue = slider.value;
                PlayerPrefs.SetFloat(volumeKey, lastSliderValue);
                PlayerPrefs.SetInt(muteKey, 1);
                // Set slider to 0 and mute audio
                slider.SetValueWithoutNotify(0f);
                mixer.SetFloat(volumeParameter, AudioMixManager.Instance.MuteDb);
                SetMutedState(true);
            }
            else
            {
                // Unmute: restore volume and update mute state
                PlayerPrefs.SetInt(muteKey, 0);
                float db = AudioMixManager.Instance.EvaluateDb(lastSliderValue);
                mixer.SetFloat(volumeParameter, db);
                slider.SetValueWithoutNotify(lastSliderValue);
                SetPercentageText(lastSliderValue);
                SetMutedState(false);
            }
        }

        /// <summary>
        /// Mutes/unmutes the channel UI and visuals (does not change stored volume).
        /// </summary>
        public void SetMutedState(bool muted)
        {
            isMuted = muted;

            // 1) disable/enable the slider UI (without destroying it)
            slider.interactable = !muted;

            // 2) tint the track
            emptyImage.color = muted
                ? new Color(emptyColor.r, emptyColor.g, emptyColor.b, 0.3f)
                : emptyColor;
            fillImage.color = muted
                ? new Color(fillColor.r, fillColor.g, fillColor.b, 0.3f)
                : fillColor;

            // 3) tint the text
            var textCol = muted ? Color.grey : textColor;
            percentageText.color = textCol;
            sliderText.color = textCol;

            if (muteIcon != null)
            {
                // 4) dim or restore the icon (adjust alpha)
                var iconImg = muteIcon.button.image;
                var ic = iconImg.color;
                iconImg.color = new Color(ic.r, ic.g, ic.b, muted ? 0.3f : 1f);
            }
        }

        public void SetValue(float value, bool notify = true)
        {
            if (notify) slider.value = value;
            else slider.SetValueWithoutNotify(value);

            SetPercentageText(value);

            if (isMuted)
            {
                SetMutedState(false);
                mixer.SetFloat(volumeParameter, AudioMixManager.Instance.EvaluateDb(value));
                string levelKey = AudioMixManager.Instance != null && !string.IsNullOrEmpty(AudioMixManager.Instance.CurrentLevelName)
                                    ? AudioMixManager.Instance.CurrentLevelName
                                    : SceneManager.GetActiveScene().name;
                PlayerPrefs.SetInt(levelKey + "_Mute_" + busType, 0);
            }
        }

        public void RegisterOnChanged(UnityAction<float> action)
        {
            slider.onValueChanged.AddListener(action);
        }

        private void OnSliderChanged(float t)
        {
            if (isMuted) return;
            float db = AudioMixManager.Instance.EvaluateDb(t);
            mixer.SetFloat(volumeParameter, db);
        }

        protected override void SetColors(ColorTheme theme)
        {
            emptyImage.color = theme.thirdColor;
            fillImage.color = theme.fourthColor;
            sliderText.color = theme.secondaryColor;
            percentageText.color = theme.secondaryColor;
        }

        private void SetPercentageText(float normalized)
        {
            float percent = normalized * 100f;

            if (!showDecimals || Mathf.Approximately(normalized, 0f) ||
                Mathf.Approximately(normalized, 1f))
            {
                percentageText.text = Mathf.RoundToInt(percent) + "%";
            }
            else
            {
                percentageText.text = percent.ToString("N1") + "%";
            }
        }
    }
}
