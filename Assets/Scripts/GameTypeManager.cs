using SpaciousPlaces;
using System.Collections;
using System.Collections.Generic;
using Unity.Services.Core;
using Unity.Services.RemoteConfig;
using Unity.VisualScripting;
using UnityEngine;

public class GameTypeManager : MonoBehaviour
{
    public static GameTypeManager instance;

    [SerializeField]private bool hasFullUnlock = false; // This should be set based on your entitlement checks

    public VRGuardian vrGuardian;   

    public bool hasInitialized = false; // Flag to check if initialization has been done

    struct userAttributes { }
    struct appAttributes { }

    void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
    }
    // Start is called before the first frame update
    void Start()
    {
        Initialize();
    }
    
    public async void Initialize()
    {
        // Ensure Unity Services are initialized
        await UnityServices.InitializeAsync();
        // Set the environment ID for Remote Config
        RemoteConfigService.Instance.SetEnvironmentID("6217181d-6e39-447d-81ef-f0c3ac6e3dfb");
        // Fetch remote configuration
        RemoteConfigService.Instance.FetchCompleted += OnRemoteConfigFetched;
        RemoteConfigService.Instance.FetchConfigs(new userAttributes(), new appAttributes());
    }

    private void OnDestroy() {
        RemoteConfigService.Instance.FetchCompleted -= OnRemoteConfigFetched;
    }

    private void OnRemoteConfigFetched(ConfigResponse response) {
        Debug.Log("Remote config fetch completed with status: " + response.status);

        bool isFullUnlock = false;

        if (response.requestOrigin == ConfigOrigin.Remote)
        {
            Debug.Log("Remote config fetched successfully: " + response.status);

            string activeSku = RemoteConfigService.Instance.appConfig.GetString("active_sku", "");
            Debug.Log("Remote config - active_sku: " + activeSku);

            string skuJson = RemoteConfigService.Instance.appConfig.GetJson("sku_list_json");
            List<string> validSkus = JsonUtility.FromJson<Wrapper>(@"{""skus"":" + skuJson + "}").skus;

            if (validSkus.Contains(activeSku))
            {
                Debug.Log("[GTM] HasFullUnlock" + activeSku);
                isFullUnlock = true;
                if (!PlayerPrefs.HasKey("hasFullUnlock") || PlayerPrefs.GetInt("hasFullUnlock") == 0) {
                    PlayerPrefs.SetInt("hasFullUnlock", 1);
                }
            }
            else {
                isFullUnlock = false;
                if (!PlayerPrefs.HasKey("hasFullUnlock") || PlayerPrefs.GetInt("hasFullUnlock") == 1) {
                    PlayerPrefs.SetInt("hasFullUnlock", 0);
                }
                PlayerPrefs.SetInt("hasFullUnlock", 0);
            }
        }

        SetFullUnlock(isFullUnlock);
    }

    public void SetFullUnlock(bool value)
    {
        hasFullUnlock = value;
        

        GetComponent<FirebaseInit>().Initializer(); // Reinitialize Firebase if needed
        hasInitialized = value;
        InitializeHomeMenu(true);
    }

    public void InitializeHomeMenu(bool intialSetup) {
        if (HomeMenuController.instance != null) {
            HomeMenuController.instance.Initialize(intialSetup); // Refresh the home menu when unlock state changes
        }
    }

    public bool HasFullUnlock()
    {
        return PlayerPrefs.HasKey("hasFullUnlock") ? PlayerPrefs.GetInt("hasFullUnlock") == 1 : hasFullUnlock;
    }
}

[System.Serializable]
public class Wrapper {
    public List<string> skus;
}