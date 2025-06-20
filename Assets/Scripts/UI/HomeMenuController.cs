using Firebase.Extensions;
using Firebase.Firestore;
using Oculus.Interaction.Body.Input;
using Oculus.Platform.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Threading.Tasks;
using TMPro;
using Unity.Burst.CompilerServices;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.Analytics;
using UnityEngine.Networking;
using UnityEngine.ResourceManagement.AsyncOperations;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using VRUIP;

namespace SpaciousPlaces
{
    public class HomeMenuController : MonoBehaviour
    {
        public static HomeMenuController instance;

        [SerializeField] GameObject levelButtonPrefab;

        [SerializeField] private GameObject UnlockHolder;
        [SerializeField] private GameObject PurchaseHolder;
        [SerializeField] private GameObject MainBodyBackground;
        [SerializeField] private GameObject MainBody;
        [SerializeField] private GameObject PurchasePanel;
        [SerializeField] private GameObject DownloadPanel;
        [SerializeField] private Button bonusUnlockButton;
        [SerializeField] private Button purchaseButton;
        [SerializeField] private Button cancelPurchase;
        [SerializeField] private Button acceptPurchase;
        [SerializeField] private Button cancelDownload;
        [SerializeField] private Button acceptDownload;
        [SerializeField] private TextMeshProUGUI fileSizeText;
        [SerializeField] private EmailUIConnectors emailUIConnectors;

        [SerializeField] SPLevel bannerLevel;
        [SerializeField] Button bannerButton;

        [SerializeField] List<SPLevel> spaces;
        [SerializeField] GameObject spacesContent;

        [SerializeField] List<SPLevel> instruments;
        [SerializeField] GameObject instrumentsContent;

        [SerializeField] bool includeTestLevels = false;

        private bool FTFL = true; // First Time Free Level
        bool isCancelled = false;
        //--------MetaID--------
        protected static string metaID;
        protected string MetaID
        {
            get { return metaID; }
            set { metaID = value; }
        }
        protected void AssignMetaID(string newID)
        {
            //Assign MetaID from here
            MetaID = newID;
        }

        private GameObject bonusButton;
        private List<GameObject> levelButtons = new();

        private FirebaseFirestore db;

        protected string oneSignalAPIKey = "os_v2_app_wdgtonjhozhsbljvbdudddzxbk5curvfqc6ejxv2urtu5dskxpw3lckriz6ljichdz35d7vhlmzbgc63yiex3sl462n6x2qeuwz4lcy";
        protected string oneSignalAppId = "b0cd3735-2776-4f20-ad35-08e8318f370a";

        private void Awake()
        {
            if (instance == null)
            {
                instance = this;
            }

            AssignMetaID("1111");
        }

        private void Start()
        {

        }

        public List<SPLevel> GetSPlevelList()
        {
            return spaces;
        }

        [ContextMenu("Rebuild Home Menu")]
        public void Initialize(bool isInitial)
        {
            if (GameTypeManager.instance.HasFullUnlock()) { 
                FTFL = false;
            }

            if (FTFL && !isInitial) {
                StartCoroutine(ScaleFade(MainBody.transform, Vector3.one, 0.5f, false));
                StartCoroutine(ScaleFade(MainBodyBackground.transform, Vector3.one, 0.5f, false));
                StartCoroutine(ScaleFade(PurchasePanel.transform,new Vector3(0.8f, 0.8f, 0.8f),0.5f,true));
                PurchaseHolder.SetActive(false);
                AskToBuyFullGameOrTrial();
            }


            if (levelButtons != null && levelButtons.Count > 0)
            {
                foreach (var button in levelButtons) {
                    Destroy(button);
                }
            }

            bannerButton.GetComponent<Button>().onClick.RemoveAllListeners();
            bannerButton.GetComponentInChildren<Image>().sprite = bannerLevel.thumbnail;
            bannerButton.GetComponent<Button>().onClick.AddListener(() =>
            {
/*                Debug.Log("Load " + bannerLevel);
                GotoScene.Instance.Go(bannerLevel);*/
                Debug.Log("Load " + bannerLevel);
                MoodRegistrationManager.SelectedLevel = bannerLevel;
                MoodRegistrationManager.Instance.StartLevelWithMood(bannerLevel);
                FTFL = true;
            });

            foreach (SPLevel level in spaces)
            {
                if (includeTestLevels && 
                    (level.scene == SceneUtils.SceneId.SamplerTest || level.scene == SceneUtils.SceneId.IAPTest))
                {
                    AddLevelButton(level, spacesContent.transform);
                }
                else if (level.scene == SceneUtils.SceneId.Main)
                {
                    AddLevelButton(level, spacesContent.transform);
                }
            }

            foreach (SPLevel level in instruments)
            {
                AddLevelButton(level, instrumentsContent.transform);
            }

            if (MoodRegistrationManager.Instance.levelEnd) {
                //MoodRegistrationManager.Instance.ShowMenuAfterHome();
                MoodRegistrationManager.Instance.levelEnd = false;
            }

            BonusAndLevelButtonSetup();
        }

        private void AddLevelButton(SPLevel level, Transform parent)
        {
            GameObject button = Instantiate(levelButtonPrefab, spacesContent.transform);
            button.GetComponentInChildren<TextMeshProUGUI>().text = level.levelTitle;
            button.GetComponent<LevelHolder>().level = level;

            if (button.GetComponentInChildren<TextMeshProUGUI>().text == "Bonus")
            {
                bonusButton = button;
            }

            button.GetComponent<Button>().interactable = false;
            button.transform.GetChild(2).gameObject.SetActive(true);
            button.transform.GetChild(3).gameObject.SetActive(false);

            var image = button.GetComponentInChildren<Image>();

            if (image == null)
            {
                // for curve button
                image = button.GetComponentInChildren<Image>();
            }

            image.sprite = level.thumbnail;

            button.GetComponent<Button>().onClick.AddListener(() =>
            {
                Debug.Log("Load " + level.levelTitle);
                MoodRegistrationManager.SelectedLevel = level;
                MoodRegistrationManager.Instance.StartLevelWithMood(level);
            });
            button.transform.SetParent(parent);

            levelButtons.Add(button);
        }

        public void BonusAndLevelButtonSetup()
        {                                 
            db = FirebaseFirestore.DefaultInstance;
            StartCoroutine(BonusAndLevelButtonSetupCoroutine());
        }

        private IEnumerator BonusAndLevelButtonSetupCoroutine()
        {
            if (GameTypeManager.instance.HasFullUnlock())
            {
                Debug.Log("[HMC] Check state");

                bool BonusVerified = false;
                yield return StartCoroutine(CheckBonusVerifyCoroutine(result =>
                {
                    BonusVerified = result;
                }));

                Debug.Log("[HMC] BonusVerified -- " + BonusVerified);

                UnlockHolder.SetActive(!BonusVerified);

                if (!BonusVerified)
                {
                    bonusUnlockButton.onClick.RemoveAllListeners();
                    bonusUnlockButton.onClick.AddListener(EnableEmailVerfication);
                }

                foreach (GameObject button in levelButtons)
                {
                    SPLevel buttonLevel = button.GetComponent<LevelHolder>().level;
                    bool isAssetType = false;
                    bool LevelAssestsLoaded = true;

                    if (buttonLevel.type == LevelType.VideoVR && buttonLevel.useAddressableVideo)
                    {
                        LevelAssestsLoaded = false;
                        isAssetType = true;
                        Debug.Log("Here");

                        AsyncOperationHandle<long> getDownloadSizeHandle = Addressables.GetDownloadSizeAsync(buttonLevel.videoAddressableKey);
                        yield return getDownloadSizeHandle;

                        Debug.Log("Here");

                        if (getDownloadSizeHandle.Status == AsyncOperationStatus.Succeeded)
                        {
                            long downloadSize = getDownloadSizeHandle.Result;



                            fileSizeText.text = $"File Size: {downloadSize / 1024f / 1024f:F2} MB";

                            if (downloadSize > 0)
                            {
                                Debug.Log("Video needs to be downloaded.");
                                LevelAssestsLoaded = false;
                            }
                            else
                            {
                                Debug.Log("Video is already downloaded.");
                                LevelAssestsLoaded = true;
                            }
                        }
                        else
                        {
                            Debug.LogError("Failed to get download size.");
                        }
                    }

                    if (button.GetComponentInChildren<TextMeshProUGUI>().text == "Bonus")
                    {                             
                        button.SetActive(true);
                        button.transform.GetChild(2).gameObject.SetActive(!BonusVerified);
                        Debug.Log("[HMC] Check state - 3");

                        if (!BonusVerified)
                        {                                    
                            button.transform.GetChild(3).gameObject.SetActive(false);
                            button.transform.GetChild(4).gameObject.SetActive(false);
                            button.GetComponent<Button>().interactable = false;
                            button.transform.GetChild(2).GetComponent<Button>().onClick.RemoveAllListeners();
                            button.transform.GetChild(2).GetComponent<Button>().onClick.AddListener(() => {
                                EnableEmailVerfication();
                                Debug.Log("[HMC] Check state - 4");
                            });
                        }
                        else if (BonusVerified && isAssetType)
                        {
                            if (!LevelAssestsLoaded)
                            {
                                button.transform.GetChild(3).gameObject.SetActive(true);
                                button.transform.GetChild(4).gameObject.SetActive(false); 
                                button.GetComponent<Button>().interactable = false;
                                button.transform.GetChild(3).GetComponent<Button>().onClick.RemoveAllListeners();
                                button.transform.GetChild(3).GetComponent<Button>().onClick.AddListener(() => {
                                    ShowDownloadPopUp(buttonLevel.videoAddressableKey, button.gameObject);
                                    Debug.Log("[HMC] Check state - 6");
                                });
                            }
                            else
                            {
                                button.transform.GetChild(3).gameObject.SetActive(false);
                                button.transform.GetChild(4).gameObject.SetActive(true);
                                button.transform.GetChild(4).GetComponent<Button>().onClick.AddListener(() => {
                                    DeleteAsset(buttonLevel.videoAddressableKey, button.gameObject);
                                    Debug.Log("[HMC] Check state - 9");
                                });
                                button.GetComponent<Button>().interactable = true;
                            }
                        }
                    }
                    else
                    {
                        button.transform.GetChild(2).gameObject.SetActive(false);

                        if (isAssetType)
                        {
                            button.transform.GetChild(3).gameObject.SetActive(!LevelAssestsLoaded);
                            button.transform.GetChild(4).gameObject.SetActive(LevelAssestsLoaded);

                            if (LevelAssestsLoaded)
                            {
                                button.transform.GetChild(4).GetComponent<Button>().onClick.RemoveAllListeners();
                                button.transform.GetChild(4).GetComponent<Button>().onClick.AddListener(() => {
                                    DeleteAsset(buttonLevel.videoAddressableKey, button.gameObject);
                                    Debug.Log("[HMC] Check state - 9");
                                });
                                button.GetComponent<Button>().interactable = true;
                            }
                            else
                            {
                                button.transform.GetChild(3).GetComponent<Button>().onClick.RemoveAllListeners();
                                button.transform.GetChild(3).GetComponent<Button>().onClick.AddListener(() => {
                                    ShowDownloadPopUp(buttonLevel.videoAddressableKey, button);
                                    Debug.Log("[HMC] Check state - 7");
                                });
                                button.GetComponent<Button>().interactable = false;
                            }
                        }
                        else
                        {
                            button.GetComponent<Button>().interactable = true;
                        }

                        Debug.Log("[HMC] Check state - 5");
                    }
                }
                Debug.Log("[HMC] Check state - 5");
            }
            else
            {
                PurchaseHolder.SetActive(true);
                purchaseButton.onClick.RemoveAllListeners();
                purchaseButton.onClick.AddListener(() => {
                    AskToBuyFullGameOrTrial();
                });

                foreach (GameObject button in levelButtons)
                {
                    if (button.GetComponentInChildren<TextMeshProUGUI>().text == "Bonus") {
                        button.SetActive(false);
                    }

                    button.transform.GetChild(3).gameObject.SetActive(false);
                    button.transform.GetChild(2).GetComponent<Button>().onClick.RemoveAllListeners();
                    button.transform.GetChild(2).GetComponent<Button>().onClick.AddListener(() => {
                        AskToBuyFullGameOrTrial();
                    });
                }
            }
        }

        //--------BonusLevelUnlock--------
        private IEnumerator CheckBonusVerifyCoroutine(Action<bool> onResult) {
            if (PlayerPrefs.GetInt("BonusLevelUnlocked") == 1) {
                Debug.Log("[HMC] Bonus Level is already unlocked.");
                onResult(true);
                yield break;
            }
            else {
                Debug.Log("[HMC] Checking Verification from Firebase...");
                yield return StartCoroutine(GetVerificationStatus(MetaID, isVerified =>
                {
                    if (isVerified) {
                        PlayerPrefs.SetInt("BonusLevelUnlocked", 1);
                    }
                    onResult(isVerified);
                }));
            }
        }

        public IEnumerator GetVerificationStatus(string metaID, Action<bool> onResult) {
            DocumentReference docRef = db.Collection("Verification Status").Document(metaID);
            Task<DocumentSnapshot> task = docRef.GetSnapshotAsync();

            yield return new WaitUntil(() => task.IsCompleted);

            if (task.Exception != null) {
                Debug.LogError("[HMC] Firestore error: " + task.Exception);
                onResult(false);
            }
            else {
                DocumentSnapshot snapshot = task.Result;
                if (snapshot.Exists && snapshot.ContainsField("isVerified")) {
                    bool isVerified = snapshot.GetValue<bool>("isVerified");
                    Debug.Log("[HMC] isVerified: " + isVerified);
                    if (isVerified) PlayerPrefs.SetInt("BonusLevelUnlocked", 1);
                    onResult(isVerified);
                }
                else {
                    Debug.Log("[HMC] Document not found or missing field.");
                    onResult(false);
                }
            }
        }

        private void EnableEmailVerfication()
        {
            UnlockHolder.SetActive(false);
            emailUIConnectors.gameObject.SetActive(true);
            StartCoroutine(ScaleFade(MainBody.transform, Vector3.one, 0.5f, false));
            StartCoroutine(ScaleFade(MainBodyBackground.transform, Vector3.one, 0.5f, false));
            StartCoroutine(ScaleFade(emailUIConnectors.transform, Vector3.one * 0.5f, 0.5f, true));

            emailUIConnectors.submitButton.onClick.AddListener(() => {
                string email = emailUIConnectors.emailInputField.text;
                bool consented = emailUIConnectors.termsToggle.isOn;

                if (IsValidEmail(email) && consented)
                {
                    PlayerPrefs.SetString("UserEmail", email);
                    PlayerPrefs.Save();
                    SendToOneSignal(email);
                    SaveVerificationStatus(true);
                }
            });

            emailUIConnectors.cancelButton.onClick.AddListener(() => {
                StartCoroutine(ScaleFade(emailUIConnectors.transform, Vector3.one * 0.5f, 0.5f, false));
                StartCoroutine(ScaleFade(MainBody.transform, Vector3.one, 0.5f, true));
                StartCoroutine(ScaleFade(MainBodyBackground.transform, Vector3.one, 0.5f, true));
                emailUIConnectors.gameObject.SetActive(false);
                UnlockHolder.SetActive(true);
            });
        }

        private bool IsValidEmail(string email)
        {
            return email.Contains("@") && email.Contains(".");
        }

        public void SaveVerificationStatus(bool isVerified) {
            DocumentReference docRef = db.Collection("Verification Status").Document(MetaID);

            Dictionary<string, object> data = new Dictionary<string, object>
            {
            { "isVerified", isVerified }
        };

            docRef.SetAsync(data).ContinueWithOnMainThread(task =>
            {
                if (task.IsCompleted) {
                    Debug.Log("[HMC]Document successfully written with MetaID: " + MetaID);
                }
                else {
                    Debug.LogError("[HMC] Error writing document: " + task.Exception);
                }
            });
        }

        private void SendToOneSignal(string email)
        {
            StartCoroutine(PushEmailToOneSignal(email));
        }

        private IEnumerator PushEmailToOneSignal(string email)
        {
            string url = "https://onesignal.com/api/v1/players";
            string metaId = MetaID;
            string jsonBody = $"{{" +
                      $"\"app_id\":\"{oneSignalAppId}\"," +
                      $"\"device_type\":11," +
                      $"\"identifier\":\"{email}\"," +
                      $"\"external_id\":\"{metaId}\"" +
                      $"}}";
            using (UnityWebRequest request = new UnityWebRequest(url, "POST"))
            {
                byte[] bodyRaw = System.Text.Encoding.UTF8.GetBytes(jsonBody);
                request.uploadHandler = new UploadHandlerRaw(bodyRaw);
                request.downloadHandler = new DownloadHandlerBuffer();

                request.SetRequestHeader("Content-Type", "application/json; charset=utf-8");
                request.SetRequestHeader("Authorization", "Basic " + oneSignalAPIKey);

                yield return request.SendWebRequest();

                if (request.result != UnityWebRequest.Result.Success)
                {
                    Debug.Log($"OneSignal Email Push Failed: HTTP {request.responseCode} - {request.error}");
                    Debug.Log("Response body: " + request.downloadHandler.text);
                    HideEmailPanel();
                }
                else
                {
                    Debug.Log("Email successfully registered with OneSignal: " + email);
                    string responseText = request.downloadHandler.text;

                    // Parse player_id from JSON
                    var responseJson = JsonUtility.FromJson<OneSignalPlayerResponse>(responseText);
                    if (!string.IsNullOrEmpty(responseJson.id))
                    {
                        PlayerPrefs.SetString("external_id", responseJson.id);
                        PlayerPrefs.Save();
                        UnlockBonusLevel();
                        Debug.Log("Saved OneSignal Player ID: " + responseJson.id);
                    }
                    else
                    {
                        Debug.LogWarning("No player_id found in OneSignal response.");
                    }
                }
            }
        }

        private void UnlockBonusLevel()
        {
            PlayerPrefs.SetInt("BonusLevelUnlocked", 1);
            PlayerPrefs.Save();
            Analytics.CustomEvent("email_shared");
            ShowBonusLevel();
        }

        private void ShowBonusLevel()
        {
            HideEmailPanel();

            UnlockHolder.SetActive(false);
            bonusButton.transform.GetChild(2).gameObject.SetActive(false);
            bonusButton.GetComponent<Button>().interactable = true;
        }

        private void HideEmailPanel()
        {
            StartCoroutine(ScaleFade(emailUIConnectors.transform, Vector3.one * 0.5f, 0.5f, false));
            StartCoroutine(ScaleFade(MainBody.transform, Vector3.one, 0.5f, true));
            StartCoroutine(ScaleFade(MainBodyBackground.transform, Vector3.one, 0.5f, true)); 
            emailUIConnectors.gameObject.SetActive(false);
            UnlockHolder.SetActive(true);
        }

        public void DeleteData()
        {
            string appId = oneSignalAppId;
            string aliasLabel = "external_id";
            string aliasId = MetaID;

            Debug.Log("[RemoteConfig] Alias ID - " + aliasId);

            string url = $"https://api.onesignal.com/apps/{appId}/users/by/{aliasLabel}/{aliasId}";
            StartCoroutine(DeleteUserCoroutine(url));
        }

        private IEnumerator DeleteUserCoroutine(string url)
        {
            UnityWebRequest request = UnityWebRequest.Delete(url);
            request.SetRequestHeader("Authorization", "Key " + oneSignalAPIKey);
            request.SetRequestHeader("accept", "application/json");

            yield return request.SendWebRequest();

            if (request.result == UnityWebRequest.Result.Success)
            {
                Debug.Log("✅ OneSignal user deleted successfully.");
                Debug.Log("Response code: " + request.responseCode); // Should be 200 or 204
                PlayerPrefs.SetInt("BonusLevelUnlocked", 0);
            }
            else
            {
                Debug.LogError("❌ Failed to delete OneSignal user.");
                Debug.LogError("Error: " + request.error);
                Debug.LogError("Response Code: " + request.responseCode);
                Debug.LogError("Response: " + request.downloadHandler?.text);
            }
        }

        public IEnumerator CheckEmailForExternalID(System.Action<bool> callback)
        {
            string url = $"https://api.onesignal.com/apps/{oneSignalAppId}/users/by/external_id/{MetaID}";

            Debug.Log("Starting request to OneSignal...");

            UnityWebRequest request = UnityWebRequest.Get(url);
            request.SetRequestHeader("accept", "application/json");
            request.SetRequestHeader("Authorization", $"Key {oneSignalAPIKey}");

            yield return request.SendWebRequest();

            if (request.result != UnityWebRequest.Result.Success)
            {
                Debug.LogWarning($"❌ Request failed: {request.error}");
                callback(false);
                yield break;
            }

            Debug.Log("Request successful.");
            Debug.Log($"Raw JSON Response:\n{request.downloadHandler.text}");

            string json = request.downloadHandler.text;

            if (string.IsNullOrEmpty(json))
            {
                Debug.LogWarning("Empty response received.");
                callback(false);
                yield break;
            }

            bool hasEmail = json.Contains("\"type\":\"Email\"") && json.Contains("\"token\":\"") && !json.Contains("\"token\":null");
            Debug.Log($"Email check result: {(hasEmail ? "Found" : "Not Found")}");

            callback(hasEmail);
        }

        //--------IAP--------
        //To be called 2 more times
        private void AskToBuyFullGameOrTrial()
        {
            PurchaseHolder.SetActive(false);

            StartCoroutine(ScaleFade(MainBody.transform, Vector3.one, 0.5f, false));
            StartCoroutine(ScaleFade(MainBodyBackground.transform, Vector3.one, 0.5f, false));
            StartCoroutine(ScaleFade(PurchasePanel.transform, new Vector3(0.8f, 0.8f, 0.8f), 0.5f, true));

            cancelPurchase.onClick.RemoveAllListeners();
            cancelPurchase.onClick.AddListener(CancelPurchase);
            acceptPurchase.onClick.RemoveAllListeners();
            acceptPurchase.onClick.AddListener(AcceptPurchase);
        }

        private void AcceptPurchase()
        {
            PurchaseHolder.SetActive(false);

            StartCoroutine(ScaleFade(PurchasePanel.transform, new Vector3(0.8f, 0.8f, 0.8f), 0.5f, false));
            StartCoroutine(ScaleFade(MainBody.transform, Vector3.one, 0.5f, true));
            StartCoroutine(ScaleFade(MainBodyBackground.transform, Vector3.one, 0.5f, true));

            SceneLoader.Instance.LoadScene("IAPTest", null);
            Debug.Log("[HMC] Purchase Accepted");
        }

        private void CancelPurchase()
        {
            PurchaseHolder.SetActive(true);

            StartCoroutine(ScaleFade(PurchasePanel.transform, new Vector3(0.8f, 0.8f, 0.8f), 0.5f, false));
            StartCoroutine(ScaleFade(MainBody.transform, Vector3.one, 0.5f, true));
            StartCoroutine(ScaleFade(MainBodyBackground.transform, Vector3.one, 0.5f, true));

            Debug.Log("[HMC] Purchase Canceled");
        }

        //--------AssetBundle--------
        private void ShowDownloadPopUp(string key, GameObject button)
        {
            StartCoroutine(ShowDownloadPopUpCoroutine(key, button));
        }

        private IEnumerator ShowDownloadPopUpCoroutine(string key, GameObject button) {
            isCancelled = false;

            var releaseHandle = Addressables.ClearDependencyCacheAsync(key, false);
            yield return releaseHandle;

            Addressables.Release(releaseHandle);

            var getSizeHandle = Addressables.GetDownloadSizeAsync(key);
            yield return getSizeHandle;
            long size = getSizeHandle.Result;

            fileSizeText.text = $"File Size: {size / 1024f / 1024f:F2} MB";

            DownloadPanel.transform.GetChild(2).gameObject.SetActive(false);
            DownloadPanel.transform.GetChild(3).GetChild(0).gameObject.SetActive(true);
            DownloadPanel.transform.GetChild(3).gameObject.SetActive(true);

            StartCoroutine(ScaleFade(MainBody.transform, Vector3.one, 0.5f, false));
            StartCoroutine(ScaleFade(MainBodyBackground.transform, Vector3.one, 0.5f, false));
            StartCoroutine(ScaleFade(DownloadPanel.transform, new Vector3(0.8f, 0.8f, 0.8f), 0.5f, true));

            acceptDownload.onClick.RemoveAllListeners();
            acceptDownload.onClick.AddListener(() => {
                DownloadAsset(key, button);
            });

            cancelDownload.onClick.RemoveAllListeners();
            cancelDownload.onClick.AddListener(() => {
                HideDownloadPopUp();
            });

            Addressables.Release(getSizeHandle);
        }

        private void HideDownloadPopUp()
        {
            DownloadPanel.transform.GetChild(2).gameObject.SetActive(false);
            DownloadPanel.transform.GetChild(3).gameObject.SetActive(true);
            StartCoroutine(ScaleFade(DownloadPanel.transform, new Vector3(0.8f, 0.8f, 0.8f), 0.5f, false));
            StartCoroutine(ScaleFade(MainBody.transform, Vector3.one, 0.5f, true));
            StartCoroutine(ScaleFade(MainBodyBackground.transform, Vector3.one, 0.5f, true));
        }

        public void DownloadAsset(string videoKey, GameObject button)
        {
            DownloadPanel.transform.GetChild(2).gameObject.SetActive(true);
            DownloadPanel.transform.GetChild(3).GetChild(0).gameObject.SetActive(false);
            StartCoroutine(DownloadAssetCouroutine(videoKey, button));
        }

        private IEnumerator DownloadAssetCouroutine(string videoKey, GameObject button) {
            var releaseVideoHandle = Addressables.ClearDependencyCacheAsync(videoKey, false);
            yield return releaseVideoHandle;
            Addressables.Release(releaseVideoHandle);

            var getSizeHandle = Addressables.GetDownloadSizeAsync(videoKey);
            yield return getSizeHandle;

            Image fill = DownloadPanel.transform.GetChild(2).GetChild(0).GetComponent<Image>();
            fill.fillAmount = 0f;
            if (getSizeHandle.Status == AsyncOperationStatus.Succeeded)
            {
                long size = getSizeHandle.Result;

                if (size > 0)
                {
                    var downloadHandle = Addressables.DownloadDependenciesAsync(videoKey, false);

                    cancelDownload.onClick.RemoveAllListeners();
                    cancelDownload.onClick.AddListener(() => {
                        CancelDownload();
                    });
                    while (!downloadHandle.IsDone)
                    {
                        if (isCancelled) {
                            Debug.LogWarning("Download cancelled by user.");
                            Addressables.Release(downloadHandle);
                            var releaseHandle = Addressables.ClearDependencyCacheAsync(videoKey, false);
                            yield return releaseHandle;

                            Addressables.Release(releaseHandle);

                            fill.fillAmount = 0f;
                            fileSizeText.text = $"File Size: {size / 1024f / 1024f:F2} MB";
                            isCancelled = false;
                            yield break;
                        }

                        float progress = downloadHandle.PercentComplete;
                        float DownloadedSize = progress * size;
                        fill.fillAmount = Mathf.Clamp01(progress);
                        Debug.Log($"Downloading video... {progress:P0}");
                        fileSizeText.text = $"Downloaded: {DownloadedSize / 1024f / 1024f:F2} MB / {size / 1024f / 1024f:F2} MB";

                        yield return null;
                    }

                    if (downloadHandle.IsValid())
                    {
                        if (downloadHandle.Status == AsyncOperationStatus.Succeeded)
                        {
                            fill.fillAmount = 1f;
                            Debug.Log("Video downloaded successfully.");
                            cancelDownload.onClick.RemoveAllListeners();
                            cancelDownload.onClick.AddListener(() => {
                                HideDownloadPopUp();
                            });
                            HideDownloadPopUp();
                            button.transform.GetChild(3).gameObject.SetActive(false);
                            button.transform.GetChild(4).gameObject.SetActive(true);
                            button.GetComponent<Button>().interactable = true;
                            button.transform.GetChild(4).GetComponent<Button>().onClick.RemoveAllListeners();
                            button.transform.GetChild(4).GetComponent<Button>().onClick.AddListener(() => {
                                DeleteAsset(videoKey, button);
                                Debug.Log("[HMC] Check state - 9");
                            });
                        }
                        else
                        {
                            Debug.LogError("Download failed.");
                            cancelDownload.onClick.RemoveAllListeners();
                            cancelDownload.onClick.AddListener(() => {
                                HideDownloadPopUp();
                            });
                            button.transform.GetChild(3).gameObject.SetActive(true);
                            button.transform.GetChild(4).gameObject.SetActive(false);
                            button.GetComponent<Button>().interactable = false; 
                            button.transform.GetChild(3).GetComponent<Button>().onClick.RemoveAllListeners();
                            button.transform.GetChild(3).GetComponent<Button>().onClick.AddListener(() => {
                                ShowDownloadPopUp(videoKey, button);
                                Debug.Log("[HMC] Check state - 9");
                            });
                        }
                    }
                    else
                    {
                        Debug.LogError("Handle became invalid before use.");
                        button.transform.GetChild(3).gameObject.SetActive(true);
                        button.transform.GetChild(4).gameObject.SetActive(false);
                        button.GetComponent<Button>().interactable = false; 
                        button.transform.GetChild(3).GetComponent<Button>().onClick.RemoveAllListeners();
                        button.transform.GetChild(3).GetComponent<Button>().onClick.AddListener(() => {
                            ShowDownloadPopUp(videoKey, button);
                            Debug.Log("[HMC] Check state - 9");
                        });
                    }

                    Addressables.Release(downloadHandle);
                }
                else
                {
                    Debug.Log("Video already cached.");
                    button.transform.GetChild(3).gameObject.SetActive(false);
                    button.transform.GetChild(4).gameObject.SetActive(true);
                    button.GetComponent<Button>().interactable = true;
                    button.transform.GetChild(4).GetComponent<Button>().onClick.RemoveAllListeners();
                    button.transform.GetChild(4).GetComponent<Button>().onClick.AddListener(() => {
                        DeleteAsset(videoKey, button);
                        Debug.Log("[HMC] Check state - 9");
                    });
                }
            }
            else
            {
                Debug.LogError("Failed to check video download size.");
                cancelDownload.onClick.RemoveAllListeners();
                cancelDownload.onClick.AddListener(() => {
                    HideDownloadPopUp();
                });
                button.transform.GetChild(3).gameObject.SetActive(true);
                button.transform.GetChild(4).gameObject.SetActive(false);
                button.GetComponent<Button>().interactable = false; 
                button.transform.GetChild(3).GetComponent<Button>().onClick.RemoveAllListeners();
                button.transform.GetChild(3).GetComponent<Button>().onClick.AddListener(() => {
                    ShowDownloadPopUp(videoKey, button);
                    Debug.Log("[HMC] Check state - 9");
                });
            }
            Addressables.Release(getSizeHandle);
        }

        private void CancelDownload() {
            isCancelled = true;
            DownloadPanel.transform.GetChild(3).GetChild(0).gameObject.SetActive(true);
            DownloadPanel.transform.GetChild(2).gameObject.SetActive(false);
            cancelDownload.onClick.RemoveAllListeners();
            cancelDownload.onClick.AddListener(() => {
                HideDownloadPopUp();
            });
        }


        public void DeleteAsset(string videoKey, GameObject button)
        {
            StartCoroutine(DeleteAssestCouroutine(videoKey, button));
        }

        private IEnumerator DeleteAssestCouroutine(string videoKey, GameObject button)
        {
            var releaseHandle = Addressables.ClearDependencyCacheAsync(videoKey, false);
            yield return releaseHandle;

            if (releaseHandle.IsValid())
            {
                if (releaseHandle.Status == AsyncOperationStatus.Succeeded)
                {
                    Debug.Log("Video cache cleared.");
                    button.transform.GetChild(3).gameObject.SetActive(true);
                    button.transform.GetChild(4).gameObject.SetActive(false);
                    button.transform.GetChild(3).GetComponent<Button>().onClick.RemoveAllListeners();
                    button.transform.GetChild(3).GetComponent<Button>().onClick.AddListener(() => {
                        ShowDownloadPopUp(videoKey, button);
                        Debug.Log("[HMC] Check state - 9");
                    });
                    button.GetComponent<Button>().interactable = false;
                }
                else
                {
                    Debug.LogError("Failed to delete video from cache.");
                    button.transform.GetChild(3).gameObject.SetActive(false);
                    button.transform.GetChild(4).gameObject.SetActive(true);
                    button.GetComponent<Button>().interactable = true;
                    button.transform.GetChild(4).GetComponent<Button>().onClick.RemoveAllListeners();
                    button.transform.GetChild(4).GetComponent<Button>().onClick.AddListener(() => {
                        DeleteAsset(videoKey, button);
                        Debug.Log("[HMC] Check state - 9");
                    });
                }

                Addressables.Release(releaseHandle);
            }
            else
            {
                Debug.LogError("Handle became invalid before use.");
                button.transform.GetChild(3).gameObject.SetActive(true);
                button.transform.GetChild(4).gameObject.SetActive(false);
                button.GetComponent<Button>().interactable = false; 
                button.transform.GetChild(3).GetComponent<Button>().onClick.RemoveAllListeners();
                button.transform.GetChild(3).GetComponent<Button>().onClick.AddListener(() => {
                    ShowDownloadPopUp(videoKey, button);
                    Debug.Log("[HMC] Check state - 9");
                });
            }
        }

        //--------HomeUI--------

        [ContextMenu("Clear Home Menu")]
        public void Clear()
        {
            foreach (var button in spacesContent.transform)
            {
                DestroyImmediate(((Transform)button).gameObject);
            }

            foreach (var button in instrumentsContent.transform)
            {
                DestroyImmediate(((Transform)button).gameObject);
            }
        }

        //--------Animation--------
        public IEnumerator ScaleFade(Transform target, Vector3 targetScale, float duration, bool fadeIn)
        {
            Vector3 startScale = fadeIn ? Vector3.zero : targetScale;
            Vector3 endScale = fadeIn ? targetScale : Vector3.zero;

            float timeElapsed = 0f;

            while (timeElapsed < duration)
            {
                float t = timeElapsed / duration;
                target.localScale = Vector3.Lerp(startScale, endScale, t);
                timeElapsed += Time.deltaTime;
                yield return null;
            }

            target.localScale = endScale; // Ensure final value
        }
    }
}

[System.Serializable]
public class OneSignalPlayerResponse
{
    public string id;
}
