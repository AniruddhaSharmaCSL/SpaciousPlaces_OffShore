using UnityEngine;
using Unity.Services.Core;
using Unity.Services.Authentication;
using Unity.Services.RemoteConfig;
using System.Collections.Generic;
using System.Threading.Tasks;
using Unity.Services.Core.Environments;

public class RemoteSku : MonoBehaviour
{
    [SerializeField] private IAPProductUI productUI;   // drag-reference
    [SerializeField] private string fallbackSku = "spacious_full_game_unlock"; // Fallback if Remote Config fails
    [SerializeField] private bool debugLogs = true;

    struct UserAttributes { }
    struct AppAttributes { }

    async void Start()  // Changed from Awake to Start to ensure proper initialization order
    {
        // Check if SKUs have already been set (e.g., by HardcodedSku)
        if (!string.IsNullOrEmpty(productUI?.FirstSku))
        {
            LogDebug($"SKUs already set to '{productUI.FirstSku}' - skipping Remote Config");
            return;
        }

        await InitializeUnityServices();
    }

    async Task InitializeUnityServices()
    {
        try
        {
            // Initialize Unity Services
            var options = new InitializationOptions();

            // Set environment - "development" for testing, "production" for release
#if UNITY_EDITOR || DEVELOPMENT_BUILD
            options.SetEnvironmentName("development");
            LogDebug("Using DEVELOPMENT environment for Remote Config");
#else
                options.SetEnvironmentName("production");
                LogDebug("Using PRODUCTION environment for Remote Config");
#endif

            await UnityServices.InitializeAsync(options);
            LogDebug("Unity Services initialized successfully");

            // Sign in anonymously - required for Remote Config
            if (!AuthenticationService.Instance.IsSignedIn)
            {
                await AuthenticationService.Instance.SignInAnonymouslyAsync();
                LogDebug($"Signed in anonymously. PlayerID: {AuthenticationService.Instance.PlayerId}");
            }
            else
            {
                LogDebug($"Already signed in. PlayerID: {AuthenticationService.Instance.PlayerId}");
            }

            // Now fetch Remote Config
            RemoteConfigService.Instance.FetchCompleted += OnRemoteReady;
            RemoteConfigService.Instance.FetchConfigs(new UserAttributes(), new AppAttributes());
            LogDebug("Remote Config fetch initiated");
        }
        catch (ServicesInitializationException e)
        {
            LogError($"Unity Services initialization failed: {e.Message}");
            UseFallbackSku();
        }
        catch (AuthenticationException e)
        {
            LogError($"Authentication failed: {e.Message}");
            UseFallbackSku();
        }
        catch (System.Exception e)
        {
            LogError($"Unexpected error during initialization: {e.Message}");
            UseFallbackSku();
        }
    }

    void OnRemoteReady(ConfigResponse response)
    {
        LogDebug($"Remote Config fetch completed. Status: {response.status}");

        if (response.status == ConfigRequestStatus.Failed)
        {
            LogError("Remote Config fetch failed");
            UseFallbackSku();
            return;
        }

        try
        {
            var cfg = RemoteConfigService.Instance.appConfig;

            if (cfg == null) {
                Debug.Log("AppConfig is Null");
            }


            // 1) Pull the full JSON list of SKUs
            string listJson = cfg.GetJson("sku_list_json", "[]");
            LogDebug($"Retrieved sku_list_json: {listJson}");

            List<string> allSkus = ParseSkuList(listJson);
            if (allSkus.Count == 0)
            {
                LogError("Bad or empty sku_list_json");
                UseFallbackSku();
                return;
            }

            // 2) Find which SKU should be active today
            string active = cfg.GetString("active_sku", string.Empty);
            LogDebug($"Active SKU from Remote Config: {active}");

            if (!string.IsNullOrEmpty(active) && allSkus.Remove(active))
            {
                // Put the active SKU at the front so FirstSku picks it up
                allSkus.Insert(0, active);
            }
            else
            {
                LogWarning("active_sku missing or not in list; using first entry by default");
            }

            // 3) Push the (re-ordered) list into your IAP UI
            if (productUI != null)
            {
                productUI.SetSkus(allSkus);
                LogDebug($"Set SKUs successfully. Active: {productUI.FirstSku}");
            }
            else
            {
                LogError("productUI reference is null!");
                UseFallbackSku();
            }
        }
        catch (System.Exception e)
        {
            LogError($"Error processing Remote Config data: {e.Message}");
            UseFallbackSku();
        }
    }

    void UseFallbackSku()
    {
        if (!string.IsNullOrEmpty(fallbackSku) && productUI != null)
        {
            LogWarning($"Using fallback SKU: {fallbackSku}");
            productUI.SetSkus(new[] { fallbackSku });
        }
    }

    [System.Serializable]
    class SkuArray
    {
        public string[] list;
    }

    static List<string> ParseSkuList(string rawJson)
    {
        try
        {
            // JsonUtility can't read a top-level array, so wrap it
            string wrapped = "{\"list\":" + rawJson + "}";
            Debug.Log("RawJson : " + rawJson);
            Debug.Log("Wrapped JSON: " + wrapped);

            SkuArray box = JsonUtility.FromJson<SkuArray>(wrapped);
            return box?.list != null ? new List<string>(box.list) : new List<string>();
        }
        catch (System.Exception e)
        {
            Debug.LogError($"Failed to parse SKU list JSON: {e.Message}");
            return new List<string>();
        }
    }

    // Logging helpers with debug toggle
    void LogDebug(string message)
    {
        if (debugLogs)
            Debug.Log($"[RemoteSku] {message}");
    }

    void LogWarning(string message)
    {
        Debug.LogWarning($"[RemoteSku] {message}");
    }

    void LogError(string message)
    {
        Debug.LogError($"[RemoteSku] {message}");
    }

    void OnDestroy()
    {
        // Unsubscribe from events
        RemoteConfigService.Instance.FetchCompleted -= OnRemoteReady;
    }
}