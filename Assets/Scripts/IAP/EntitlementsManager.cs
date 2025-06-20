using System;
using System.Collections;
using UnityEngine;
using Oculus.Platform;
using Oculus.Platform.Models;
using Oculus.Platform.BuildingBlocks;
using Sirenix.OdinInspector;
using UnityEngine.UI;
using SpaciousPlaces;

public class EntitlementsManager : MonoBehaviour
{
    public static EntitlementsManager Instance { get; private set; }

    public bool HasFullUnlock { get; private set; }
    public event Action<bool> OnFullUnlockChanged;

    [SerializeField] private IAPProductUI productUI;
    [SerializeField] private int refreshMinutes = 240;     // 0 = never

    [SerializeField] private Button homeButton;
    #if UNITY_EDITOR
        // Debug buttons for testing
        [Sirenix.OdinInspector.Button("Force Unlock (Game Mode)", ButtonSizes.Medium)]
        [Sirenix.OdinInspector.PropertyOrder(100)]
        void DebugForceUnlockButton() => DebugForceUnlock();

        [Sirenix.OdinInspector.Button("Force Lock (Demo Mode)", ButtonSizes.Medium)]
        [Sirenix.OdinInspector.PropertyOrder(101)]
        void DebugForceLockButton() => DebugForceLock();

        [Sirenix.OdinInspector.Button("Show Current State", ButtonSizes.Medium)]
        [Sirenix.OdinInspector.PropertyOrder(102)]
        void DebugShowStateButton() => DebugShowState();

        [Sirenix.OdinInspector.Button("Clear Cache (Reset to Demo)", ButtonSizes.Medium)]
        [Sirenix.OdinInspector.PropertyOrder(103)]
        void DebugClearCacheButton() => ResetCachedEntitlement();
    #endif

    const string kCacheKey = "FullGameUnlocked";

    // Network monitoring
    private NetworkReachability lastReachability;
    private Coroutine networkMonitorCoroutine;

    // Retry logic
    private bool isRetryingQuery = false;
    private int currentRetryCount = 0;
    private const int MAX_RETRY_ATTEMPTS = 3;
    private const float INITIAL_RETRY_DELAY = 2f;
    private bool lastQuerySucceeded = false;

    // Cache obfuscation
    const string kObfuscationSalt = "CR3@T1oN$_M3LoD13S";

    void Awake()
    {
        if (Instance) { Destroy(gameObject); return; }
        Instance = this;
        DontDestroyOnLoad(gameObject);

        if (!productUI)
            productUI = FindObjectOfType<IAPProductUI>();   // fallback

        // Initialize network state
        lastReachability = UnityEngine.Application.internetReachability;

        // Load obfuscated cache
        HasFullUnlock = LoadObfuscatedEntitlement();

        StartCoroutine(MainRoutine());

        homeButton.onClick.AddListener(ReturnToHome);
    }

    private void ReturnToHome() {
        SceneLoader.Instance.LoadPreviousScene();
    }

    IEnumerator MainRoutine()
    {
        // wait for Platform.Init from your bootstrapper
        while (!Core.IsInitialized()) yield return null;

        // Start network monitoring
        networkMonitorCoroutine = StartCoroutine(MonitorNetworkChanges());

        // ---------- ① verify app entitlement ----------
        var req = Entitlements.IsUserEntitledToApplication();
        Message msg = null;
        bool done = false;

        req.OnComplete(m => { msg = m; done = true; });
        while (!done) yield return null;

        if (msg.IsError)
        {
            // 1971031 = "Missing entitlement"  (official Meta error code)
            var code = msg.GetError().Code;

            if (UnityEngine.Application.isEditor && code == 1971031)
            {
                Debug.Log("[IAP] Expected: no entitlement in Editor — continuing in Demo Mode.");
                // fall through so the rest of the coroutine (QueryPurchases, cache update) still runs
            }
            else
            {
                Debug.LogWarning($"[IAP] App-entitlement failed: {msg.GetError().Message}. Staying in Demo Mode.");
                yield break;
            }
        }
        else
        {
            Debug.Log("[IAP] App entitlement verified successfully.");
        }

        // ---------- ② resolve IAP immediately with retry logic ----------
        yield return StartCoroutine(QueryPurchasesWithRetry());

        if (refreshMinutes > 0)
        {
            var wait = new WaitForSecondsRealtime(refreshMinutes * 60f);
            while (true)
            {
                yield return wait;
                if (UnityEngine.Application.internetReachability != NetworkReachability.NotReachable)
                    yield return StartCoroutine(QueryPurchasesWithRetry());
            }
        }
    }

    // Network change detection
    IEnumerator MonitorNetworkChanges()
    {
        while (true)
        {
            yield return new WaitForSeconds(5f); // Check every 5 seconds

            var currentReachability = UnityEngine.Application.internetReachability;

            // Network came back online - check purchases immediately
            if (lastReachability == NetworkReachability.NotReachable &&
                currentReachability != NetworkReachability.NotReachable)
            {
                Debug.Log("[IAP] Network restored - checking purchases immediately");
                // Use regular query, not the retry version, to avoid nested retries
                yield return StartCoroutine(QueryPurchases());
            }

            lastReachability = currentReachability;
        }
    }

    // Query with exponential backoff retry
    IEnumerator QueryPurchasesWithRetry()
    {
        if (isRetryingQuery)
        {
            Debug.Log("[IAP] Already retrying query, skipping duplicate retry");
            yield break;
        }

        isRetryingQuery = true;
        currentRetryCount = 0;
        float backoffTime = INITIAL_RETRY_DELAY;

        while (currentRetryCount < MAX_RETRY_ATTEMPTS)
        {
            lastQuerySucceeded = false;
            yield return StartCoroutine(QueryPurchases());

            if (lastQuerySucceeded)
            {
                currentRetryCount = 0; // Reset for next time
                break;
            }

            currentRetryCount++;
            if (currentRetryCount < MAX_RETRY_ATTEMPTS)
            {
                Debug.Log($"[IAP] Query failed, retry {currentRetryCount}/{MAX_RETRY_ATTEMPTS} in {backoffTime}s");
                yield return new WaitForSeconds(backoffTime);
                backoffTime *= 2; // Exponential backoff
            }
            else
            {
                Debug.LogWarning($"[IAP] Query failed after {MAX_RETRY_ATTEMPTS} attempts");
            }
        }

        isRetryingQuery = false;
    }

    IEnumerator QueryPurchases()
    {
        // Check if productUI is null first
        if (!productUI)
        {
            Debug.LogError("[IAP] EntitlementsManager: productUI is null - trying to find it");
            productUI = FindObjectOfType<IAPProductUI>();
            if (!productUI)
            {
                Debug.LogError("[IAP] EntitlementsManager: Could not find IAPProductUI - cannot query purchases");
                lastQuerySucceeded = false;
                yield break;
            }
        }

        bool online = UnityEngine.Application.internetReachability != NetworkReachability.NotReachable;

#if UNITY_EDITOR
        // In-Editor we have no live entitlement service, so always hit the
        // durable-cache endpoint and avoid error 1971051.
        Request<PurchaseList> req = IAP.GetViewerPurchasesDurableCache();
#else

        Request<PurchaseList> req = online
            ? IAP.GetViewerPurchases()
            : IAP.GetViewerPurchasesDurableCache();
#endif

        Message<PurchaseList> msg = null;
        bool done = false;
        req.OnComplete(m => { msg = m; done = true; });
        while (!done) yield return null;

        if (msg.IsError)
        {
            Debug.LogWarning($"[IAP] Purchase query error ({(online ? "online" : "durable")}): {msg.GetError().Message}");
            lastQuerySucceeded = false;
            yield break; // keep whatever flag we already had
        }

        lastQuerySucceeded = true;
        bool owns = false;

        if (productUI)  // RemoteSku already set productUI.FirstSku
        {
            string targetSku = productUI.FirstSku;
            foreach (var p in msg.Data)
                if (p.Sku == targetSku) { owns = true; break; }
        }
        else
        {
            Debug.LogError("[IAP] EntitlementsManager: productUI reference missing — cannot evaluate entitlement.");
        }

        if (owns != HasFullUnlock)
        {
            Debug.Log($"[IAP] Entitlement changed → {(owns ? "UNLOCKED" : "REVOKED")}");
            HasFullUnlock = owns;
            SaveObfuscatedEntitlement(owns);
            OnFullUnlockChanged?.Invoke(owns);
        }
    }

    // called by IAPTestHarness after a live checkout
    public void MarkPurchasedLocally()
    {
        if (HasFullUnlock) return;
        HasFullUnlock = true;
        SaveObfuscatedEntitlement(true);
        OnFullUnlockChanged?.Invoke(true);
    }

    /// <summary>
    /// Clears the locally-cached entitlement flag and reverts the app to Demo mode.
    /// </summary>
    public void ResetCachedEntitlement()
    {
        // 1️⃣ Delete the stored flag and flush it to disk
        PlayerPrefs.DeleteKey(kCacheKey);
        PlayerPrefs.Save();

        // Update runtime state & notify listeners, so UI refreshes immediately
        if (HasFullUnlock)
        {
            HasFullUnlock = false;
            OnFullUnlockChanged?.Invoke(false);
        }

        Debug.Log("[IAP-Debug] Cached entitlement cleared — back to Demo mode.");
    }

    // Force an immediate purchase check (useful before attempting to buy)
    public void ForceCheckPurchases(System.Action<bool> callback = null)
    {
        StartCoroutine(ForceCheckPurchasesCoroutine(callback));
    }

    private IEnumerator ForceCheckPurchasesCoroutine(System.Action<bool> callback)
    {
        yield return StartCoroutine(QueryPurchases());
        callback?.Invoke(HasFullUnlock);
    }

    // ========== Obfuscation Methods ==========

    private void SaveObfuscatedEntitlement(bool isUnlocked)
    {
        // Instead of storing plain "1" or "0", we create an obfuscated value
        string valueToStore = isUnlocked ?
            GenerateObfuscatedUnlockToken() :
            GenerateObfuscatedLockToken();

        PlayerPrefs.SetString(kCacheKey, valueToStore);
        PlayerPrefs.Save();

        Debug.Log($"[IAP] Saved obfuscated entitlement: {(isUnlocked ? "UNLOCKED" : "LOCKED")}");
    }

    private bool LoadObfuscatedEntitlement()
    {
        // First check if using old format (migration support)
        if (PlayerPrefs.HasKey(kCacheKey))
        {
            string value = PlayerPrefs.GetString(kCacheKey, "");

            // Check if it's the old "1" format
            if (value == "1" || (PlayerPrefs.GetInt(kCacheKey, -1) == 1))
            {
                Debug.Log("[IAP] Migrating from old cache format to obfuscated format");
                SaveObfuscatedEntitlement(true);
                return true;
            }
        }

        if (!PlayerPrefs.HasKey(kCacheKey))
            return false;

        string storedValue = PlayerPrefs.GetString(kCacheKey, "");

        // Check if it's a valid unlock token
        bool isUnlocked = IsValidUnlockToken(storedValue);

        Debug.Log($"[IAP] Loaded obfuscated entitlement: {(isUnlocked ? "UNLOCKED" : "LOCKED")}");
        return isUnlocked;
    }

    private string GenerateObfuscatedUnlockToken()
    {
        // Create a token that looks random but we can verify
        // Combines device ID, salt, and a magic number
        string deviceId = SystemInfo.deviceUniqueIdentifier;
        string combined = deviceId + kObfuscationSalt + "UNLOCKED_2025";
        return HashString(combined);
    }

    private string GenerateObfuscatedLockToken()
    {
        // Different pattern for locked state
        string deviceId = SystemInfo.deviceUniqueIdentifier;
        string combined = deviceId + kObfuscationSalt + "LOCKED_DEMO";
        return HashString(combined);
    }

    private bool IsValidUnlockToken(string token)
    {
        if (string.IsNullOrEmpty(token))
            return false;

        // Regenerate the expected unlock token and compare
        string expectedUnlockToken = GenerateObfuscatedUnlockToken();
        return token == expectedUnlockToken;
    }

    private string HashString(string input)
    {
        // Simple hash function - you could use System.Security.Cryptography for stronger hash
        // but this is sufficient for basic obfuscation
        int hash = 0;
        foreach (char c in input)
        {
            hash = ((hash << 5) - hash) + c;
            hash = hash & hash; // Convert to 32bit integer
        }

        // Convert to hex string and add some padding/formatting
        string hexHash = System.Math.Abs(hash).ToString("X8");
        return $"MQ_{hexHash}_{input.Length}";
    }

    void OnDestroy()
    {
        // Stop network monitoring
        if (networkMonitorCoroutine != null)
        {
            StopCoroutine(networkMonitorCoroutine);
        }
    }

#if UNITY_EDITOR
    // Debug menu for testing
    [ContextMenu("Debug/Force Unlock (Testing)")]
    void DebugForceUnlock()
    {
        Debug.Log("[IAP-Debug] Forcing unlock for testing");
        SaveObfuscatedEntitlement(true);
        HasFullUnlock = true;
        OnFullUnlockChanged?.Invoke(true);
    }

    [ContextMenu("Debug/Force Lock (Testing)")]
    void DebugForceLock()
    {
        Debug.Log("[IAP-Debug] Forcing lock for testing");
        SaveObfuscatedEntitlement(false);
        HasFullUnlock = false;
        OnFullUnlockChanged?.Invoke(false);
    }

    [ContextMenu("Debug/Show Current State")]
    void DebugShowState()
    {
        string token = PlayerPrefs.GetString(kCacheKey, "NOT_SET");
        Debug.Log($"[IAP-Debug] Current state:");
        Debug.Log($"  - HasFullUnlock: {HasFullUnlock}");
        Debug.Log($"  - Cached token: {token}");
        Debug.Log($"  - Is valid unlock: {IsValidUnlockToken(token)}");
        Debug.Log($"  - Device ID: {SystemInfo.deviceUniqueIdentifier}");
    }

    [ContextMenu("Debug/Test Obfuscation")]
    void DebugTestObfuscation()
    {
        Debug.Log("[IAP-Debug] Testing obfuscation...");

        // Test unlock
        SaveObfuscatedEntitlement(true);
        bool loadedUnlock = LoadObfuscatedEntitlement();
        Debug.Log($"Unlock test: Saved=true, Loaded={loadedUnlock} - {(loadedUnlock ? "PASS" : "FAIL")}");

        // Test lock
        SaveObfuscatedEntitlement(false);
        bool loadedLock = LoadObfuscatedEntitlement();
        Debug.Log($"Lock test: Saved=false, Loaded={loadedLock} - {(!loadedLock ? "PASS" : "FAIL")}");
    }
#endif
}