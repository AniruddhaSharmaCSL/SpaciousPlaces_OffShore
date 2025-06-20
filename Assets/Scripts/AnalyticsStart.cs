using System.Threading.Tasks;
using UnityEngine;
using Unity.Services.Core;
using Unity.Services.Analytics;

public class AnalyticsStart : MonoBehaviour
{
    private static bool _isInitialized = false;
    public static bool IsInitialized => _isInitialized;

    async void Awake()
    {
        DontDestroyOnLoad(gameObject);     // keep this object alive across scene loads
        await InitAnalyticsAsync();
    }

    static async Task InitAnalyticsAsync()
    {
        try
        {
            // Initialise the core UGS SDK (downloads config, checks env‑IDs, etc.)
            await UnityServices.InitializeAsync();

            // — If you need GDPR/CCPA consent, prompt the player here
            // AnalyticsService.Instance.PauseDataCollection(); // optional

            // Begin sending automatic and custom events
            AnalyticsService.Instance.StartDataCollection();
            _isInitialized = true;
            Debug.Log("Unity Analytics initialized successfully");
        }
        catch (System.Exception e)
        {
            Debug.LogWarning($"Failed to initialize Unity Analytics: {e.Message}");
            _isInitialized = false;
        }
    }
}