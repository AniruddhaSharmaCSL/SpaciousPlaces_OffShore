// IAPProductUI.cs — original script with **minimal** guard added in Start()
using System.Collections;    // ← needed for IEnumerator
using System.Collections.Generic;
using Oculus.Platform;
using Oculus.Platform.Models;
using TMPro;
using Unity.Services.Core;
using Unity.Services.RemoteConfig;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Fetches product metadata for the first SKU and shows its formatted price.
/// Also exposes that SKU and a "ready" flag for other components
/// </summary>
public class IAPProductUI : MonoBehaviour
{
    [Header("Meta Quest SKUs (from Dashboard)")]
    private List<string> skus = new();

    [Header("UI")]
    [SerializeField] private TextMeshPro priceLabel;
    [SerializeField] private TextMeshPro skuLabel;
    [SerializeField] private Button buyButton;       // optional: wire here to auto‑enable
    [SerializeField] private IAPTestHarness testHarness;

    public string FirstSku => skus.Count > 0 ? skus[0] : string.Empty;
    public bool ProductReady { get; private set; }

    private void Awake()
    {
        #if UNITY_EDITOR                    
            PopulateMockUI();
        #else
            Debug.Log("[IAP-Debug] IAPProductUI Awake called");
            // Keep the button disabled until we're ready
            if (buyButton) buyButton.interactable = false;

        #endif
    }

    private void Start()
    {
        #if UNITY_EDITOR
            // Editor = dont call the Platform SDK
            return;
        #else

            Debug.Log("[IAP-Debug] IAPProductUI Start called");

            if (!Core.IsInitialized())
            {
                Debug.LogWarning("Platform not initialized yet; waiting...");
                StartCoroutine(WaitForInitThenFetch());
                return;
            }

            FetchPrices();
        #endif
    }

    private IEnumerator WaitForInitThenFetch()
    {
        yield return new WaitUntil(Core.IsInitialized);
        FetchPrices();
    }

    private void FetchPrices()
    {
        if (skus.Count == 0)
        {
            Debug.LogWarning("[IAP-Debug] No SKUs configured in IAPProductUI");
            return;
        }

        Debug.Log($"[IAP-Debug] Requesting products for SKUs: {string.Join(", ", skus)}");
        Debug.Log($"[IAP-Debug] Platform initialized: {Core.IsInitialized()}");
        Debug.Log($"[IAP-Debug] Internet reachability: {UnityEngine.Application.internetReachability}");
        
        IAP.GetProductsBySKU(skus.ToArray()).OnComplete(OnProductsReceived);
    }

    public void SetSkus(IEnumerable<string> incoming)
    {
        skus = new List<string>(incoming);
        Debug.Log($"[IAP-Debug] SetSkus called with: {string.Join(", ", skus)}");
        if (Core.IsInitialized())
        {
            Debug.Log("[IAP-Debug] Platform is initialized, calling FetchPrices immediately");
            FetchPrices();
        }
        else
        {
            Debug.LogWarning("[IAP-Debug] Platform not initialized when SetSkus called");
        }
    }

    private void OnProductsReceived(Message<ProductList> msg)
    {
        Debug.Log($"[IAP-Debug] OnProductsReceived called. IsError: {msg.IsError}");

        if (msg.IsError)
        {
            var error = msg.GetError();
            Debug.LogError($"[IAP-Debug] Product query failed. Error Code: {error.Code}, Message: {error.Message}");
            
            // Log specific known error codes
            switch (error.Code)
            {
                case 1971031:
                    Debug.LogError("[IAP-Debug] Error 1971031: Missing entitlement - App may not be properly configured in Meta dashboard");
                    break;
                case 1971051:
                    Debug.LogError("[IAP-Debug] Error 1971051: Platform not initialized or network issue");
                    break;
                case 1971052:
                    Debug.LogError("[IAP-Debug] Error 1971052: SKU not found - Check if SKU exists in Meta dashboard for this App ID");
                    break;
                default:
                    Debug.LogError($"[IAP-Debug] Unknown error code: {error.Code}");
                    break;
            }
            
            if (skuLabel) skuLabel.text = "SKU: n/a";
            if (priceLabel) priceLabel.text = "Price: n/a";
            return;
        }

        if (msg.Data.Count == 0)
        {
            Debug.LogWarning("[IAP-Debug] No products returned from the server");
            Debug.LogWarning($"[IAP-Debug] This usually means the SKU '{skus[0]}' doesn't exist in the Meta dashboard for this app");
            if (skuLabel) skuLabel.text = "SKU: n/a";
            if (priceLabel) priceLabel.text = "Price: n/a";
            return;
        }

        Product product = msg.Data[0];
        Debug.Log($"[IAP-Debug] Product received - SKU: {product.Sku}, Price: {product.FormattedPrice}");
        ProductReady = true;

        //auto Purchase w/o button
        //Debug.Log("[IAP-Debug] Attempting auto-purchase");
        //if (testHarness != null)
        //    testHarness.Purchase();

        if (skuLabel) skuLabel.text = product.Sku;
        if (priceLabel) priceLabel.text = product.FormattedPrice;
        if (buyButton) buyButton.interactable = true;
    }

    private void PopulateMockUI()       
    {
        const string fallback = "spacious_full_game_unlock";   // used if Remote Config not ready

        // Try to read Remote Config if Unity Services has finished initialising.
        string activeSku = UnityServices.State == ServicesInitializationState.Initialized
            ? RemoteConfigService.Instance.appConfig.GetString("active_sku", fallback)
            : fallback;

        skuLabel.text = activeSku;
        priceLabel.text = "$14.99";
        buyButton.interactable = true;
        ProductReady = true;
    }
}
