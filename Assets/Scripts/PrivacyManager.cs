using OneSignalSDK;
using SpaciousPlaces;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading.Tasks;
using TMPro;
using Unity.Services.Analytics;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;
using VRUIP;

public class PrivacyManager : MonoBehaviour
{
    public static PrivacyManager Instance;

    [SerializeField]private GameObject privacyPanel;

    [SerializeField] private GameObject bodyPanel;
    [SerializeField] private GameObject backgroundPanel;
    [SerializeField] private GameObject confirmationPanel;
    [SerializeField] private Button privacyButton;
    [SerializeField] private Toggle moodMetricsCheck;
    [SerializeField] private Toggle emailCheck;
    [SerializeField] private Button acceptButton;
    [SerializeField] private Button cancelButton;
    [SerializeField] private Button yesButton;
    [SerializeField] private Button noButton;
    [SerializeField] private TextMeshProUGUI confirmationText;
    [SerializeField] private Button privacyLink;

    private string url = "https://spaciousplaces.ai/privacy";

    private void Awake() {
        if (Instance != null) {
            Instance = this;
        }
    }

    public Task<bool> IsEmailStoredAsync()
    {
        var tcs = new TaskCompletionSource<bool>();
        StartCoroutine(HomeMenuController.instance.CheckEmailForExternalID(result => tcs.SetResult(result)));
        return tcs.Task;
    }

    void Start() {
        privacyButton.onClick.AddListener(TogglePrivacyPanel);
        acceptButton.onClick.AddListener(AcceptDeletionPopUp);
        cancelButton.onClick.AddListener(CancelDeletion);
        yesButton.onClick.AddListener(OnConfirmationAccepted);
        noButton.onClick.AddListener(OnConfirmationCanceled);
        privacyLink.onClick.AddListener(OpenLink);
    }

    public void OpenLink() {
        Application.OpenURL(url);
    }

    private async void TogglePrivacyPanel()
    {
        bool isEmailStored = await IsEmailStoredAsync();

        emailCheck.gameObject.SetActive(isEmailStored);

        StartCoroutine(ScaleFade(bodyPanel.transform, Vector3.zero, 0.5f, false));
        StartCoroutine(ScaleFade(backgroundPanel.transform, Vector3.zero, 0.5f, false));
        StartCoroutine(ScaleFade(privacyPanel.transform, new Vector3(0.8f, 0.8f, 0.8f), 0.5f, true));
    }

    private void AcceptDeletionPopUp() {
        if (!moodMetricsCheck.isOn && !emailCheck.isOn) {
            UnityEngine.Debug.LogWarning("At least one option must be selected to proceed with deletion."); 
            return;
        }

        StartCoroutine(ScaleFade(privacyPanel.transform, new Vector3(0.8f, 0.8f, 0.8f), 0.5f, false));
        StartCoroutine(ScaleFade(confirmationPanel.transform, new Vector3(0.5f, 0.5f, 0.5f), 0.5f, true));

        if (moodMetricsCheck.isOn && !emailCheck.isOn) {
            UnityEngine.Debug.Log("Mood metrics data will be deleted.");
            confirmationText.text =
                "You're about to delete your Mood Metrics\n" +
                "tracking data from our system.\n\n" +
                "Please note: This process may take between\n" +
                "7 to 30 business days. During this time,\n" +
                "no new Mood Metrics will be recorded.";
        }
        else if (emailCheck.isOn && !moodMetricsCheck.isOn) {
            UnityEngine.Debug.Log("Email data will be deleted.");
            confirmationText.text =
                "You're about to permanently remove\n" +
                "the email linked to your account.\n\n" +
                "This action will prevent future communication\n" +
                "and access to certain services.";
        }
        else if (moodMetricsCheck.isOn && emailCheck.isOn) {
            UnityEngine.Debug.Log("Both Mood metrics and Email data will be deleted.");
            confirmationText.text =
                "You're about to delete your Mood Metrics\n" +
                "data and remove your linked email.\n\n" +
                "Mood Metrics deletion may take 7 to 30\n" +
                "business days. During that time, no new\n" +
                "metrics will be collected or stored.";
        }

        Canvas.ForceUpdateCanvases();
        LayoutRebuilder.ForceRebuildLayoutImmediate(confirmationText.GetComponent<RectTransform>());
        LayoutRebuilder.ForceRebuildLayoutImmediate(confirmationText.transform.parent.GetComponent<RectTransform>());
    }

    private void CancelDeletion() {
        StartCoroutine(ScaleFade(privacyPanel.transform, new Vector3(0.8f, 0.8f, 0.8f), 0.5f, false));
        StartCoroutine(ScaleFade(bodyPanel.transform, Vector3.one, 0.5f, true));
        StartCoroutine(ScaleFade(backgroundPanel.transform, Vector3.one, 0.5f, true));

        moodMetricsCheck.isOn = false;
        emailCheck.isOn = false;
    }

    private void OnConfirmationAccepted() {

        if (!moodMetricsCheck.isOn && !emailCheck.isOn) {
            UnityEngine.Debug.LogWarning("At least one option must be selected to proceed with deletion.");
            return;
        }
        if (moodMetricsCheck.isOn) {
            UnityEngine.Debug.Log("Mood metrics data will be deleted.");
            MoodRegistrationManager.Instance.DeleteAnalyticsData();
        }
        if (emailCheck.isOn) {
            UnityEngine.Debug.Log("Email data will be deleted.");
            HomeMenuController.instance.DeleteData();
        }

        StartCoroutine(ScaleFade(confirmationPanel.transform, new Vector3(0.5f, 0.5f, 0.5f), 0.5f, false));
        StartCoroutine(ScaleFade(bodyPanel.transform, Vector3.one, 0.5f, true));
        StartCoroutine(ScaleFade(backgroundPanel.transform, Vector3.one, 0.5f, true));

        moodMetricsCheck.isOn = false;
        emailCheck.isOn = false;
    }

    private void OnConfirmationCanceled() {
        StartCoroutine(ScaleFade(confirmationPanel.transform, new Vector3(0.5f, 0.5f, 0.5f), 0.5f, false));
        StartCoroutine(ScaleFade(privacyPanel.transform, new Vector3(0.8f, 0.8f, 0.8f), 0.5f, true));

    }

    public IEnumerator ScaleFade(Transform target, Vector3 targetScale, float duration, bool fadeIn) {
        Vector3 startScale = fadeIn ? Vector3.zero : targetScale;
        Vector3 endScale = fadeIn ? targetScale : Vector3.zero;

        float timeElapsed = 0f;

        while (timeElapsed < duration) {
            float t = timeElapsed / duration;
            target.localScale = Vector3.Lerp(startScale, endScale, t);
            timeElapsed += Time.deltaTime;
            yield return null;
        }

        target.localScale = endScale;
    }
}
