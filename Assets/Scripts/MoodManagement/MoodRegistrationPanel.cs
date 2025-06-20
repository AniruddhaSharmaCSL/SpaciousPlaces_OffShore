// MoodRegistrationPanel.cs
using System;
using System.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using VRUIP;


namespace SpaciousPlaces
{

    [RequireComponent(typeof(CanvasGroup))]
    public class MoodRegistrationPanel : MonoBehaviour
    {
        public static MoodRegistrationPanel Instance;
        [Header("UI References")]
        [SerializeField] public CanvasGroup canvasGroup;
        [SerializeField] private TextMeshProUGUI questionText;
        [SerializeField] private Button[] moodButtons;
        [SerializeField] private Button skipButton;

        private TextMeshProUGUI SkipText;


        /// <summary>
        /// Call once to set up labels and callbacks.
        /// </summary>
        /// 

        private void Awake() {

            if (Instance == null)
            {
                Instance = this;
            }

            canvasGroup.gameObject.SetActive(false);
            SkipText = skipButton.GetComponentInChildren<TextMeshProUGUI>();
        }
        public Task Initialize(string[] emojis, Action<int> onSelected, Action onSkipped)
        {
            // Wire up each mood button
            for (int i = 0; i < moodButtons.Length && i < emojis.Length; i++)
            {
                int idx = i;  // capture for closure
                var btn = moodButtons[i];
                btn.onClick.RemoveAllListeners();
                btn.onClick.AddListener(() => onSelected(idx+1));
            }

            // Wire up skip button
            skipButton.onClick.RemoveAllListeners();
            skipButton.onClick.AddListener(() => onSkipped());

            // Hide();
            return Task.CompletedTask;
        }

        /// <summary>
        /// Change the prompt text.
        /// </summary>
        public void SetQuestion(string question)
        {
            Debug.Log($"[MoodPanel] SetQuestion: {question} (text ref = {questionText})");
            questionText.text = question;
        }

        public TextMeshProUGUI getQuestionText() {
            return questionText;
        }

        public TextMeshProUGUI getSkipText() {
            return SkipText;
        }

        public void Show()
        {
            canvasGroup.gameObject.SetActive(true);
            canvasGroup.alpha = 1f;
            canvasGroup.interactable = true;
            canvasGroup.blocksRaycasts = true;
        }

        public void Hide()
        {
            canvasGroup.gameObject.SetActive(false);
            canvasGroup.alpha = 0f;
            canvasGroup.interactable = false;
            canvasGroup.blocksRaycasts = false;
        }
    }
}
