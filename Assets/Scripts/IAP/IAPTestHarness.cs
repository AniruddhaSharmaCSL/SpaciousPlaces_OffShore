// IAPTestHarness.cs - Improved version with better ownership handling
using Oculus.Platform;
using Oculus.Platform.Models;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class IAPTestHarness : MonoBehaviour
{
    [SerializeField] private IAPProductUI productUI;
    [SerializeField] private TextMeshPro statusLabel;
    [SerializeField] private Button buyButton;
    [SerializeField] private GameObject alreadyOwnedPanel; // Optional UI panel to show when already owned

    private bool entitlementsReady = false;

    private void Awake()
    {
        if (!productUI) productUI = GetComponent<IAPProductUI>();
        if (!buyButton) buyButton = GetComponentInChildren<Button>();
    }

    private IEnumerator Start()
    {
        // Disable buy button initially
        if (buyButton) buyButton.interactable = false;

        // Wait for the singleton to exist
        yield return new WaitUntil(() => EntitlementsManager.Instance != null);

        // Wait a bit for the first entitlement check to complete
        yield return new WaitForSeconds(2f);

        entitlementsReady = true;

        // Subscribe first, then immediately sync UI
        EntitlementsManager.Instance.OnFullUnlockChanged += RefreshUI;
        RefreshUI(EntitlementsManager.Instance.HasFullUnlock);
    }

    /// <summary>Called by the Buy button.</summary>
    public void Purchase()
    {
        Debug.Log("[IAP-Debug] Purchase() called");

        if (!entitlementsReady)
        {
            Debug.LogWarning("[IAP-Debug] Entitlements not ready yet. Please wait.");
            ShowTemporaryMessage("Please wait, checking entitlements...");
            return;
        }

        // Force check purchases before attempting to buy
        ShowTemporaryMessage("Checking purchases...");
        if (buyButton) buyButton.interactable = false;

        EntitlementsManager.Instance.ForceCheckPurchases(hasFullUnlock =>
        {
            if (hasFullUnlock)
            {
                Debug.Log("[IAP-Debug] User already owns full game. Showing owned message.");
                ShowAlreadyOwnedMessage();
                if (buyButton) buyButton.interactable = false;
                return;
            }

            if (!productUI || !productUI.ProductReady)
            {
                Debug.LogError("[IAP-Debug] Cannot purchase – ProductUI not ready "
                               + $"(productUI null? {productUI == null}, ProductReady: {productUI?.ProductReady ?? false})");
                ShowTemporaryMessage("Product information not available yet.");
                if (buyButton) buyButton.interactable = true;
                return;
            }

#if UNITY_EDITOR
            Debug.Log("[IAP-Debug] Simulated purchase succeeded in Editor");
            EntitlementsManager.Instance?.MarkPurchasedLocally();
            if (buyButton) buyButton.interactable = true;
#else
            string sku = productUI.FirstSku;
            Debug.Log($"[IAP-Debug] Launching checkout flow for SKU: {sku}");
            
            IAP.LaunchCheckoutFlow(sku).OnComplete(OnCheckout);
#endif
        });
    }

    // ------------------------------------------------------------------------
    // CALLBACKS
    // ------------------------------------------------------------------------
    private void OnCheckout(Message<Purchase> msg)
    {
        Debug.Log($"[IAP-Debug] OnCheckout called. IsError: {msg.IsError}");

        // Re-enable buy button
        if (buyButton) buyButton.interactable = true;

        if (msg.IsError)
        {
            var error = msg.GetError();
            Debug.LogError($"[IAP-Debug] Checkout failed. Error Code: {error.Code}, Message: {error.Message}");

            // Check if it's a user cancellation
            if (error.Code == 1971020) // User cancelled
            {
                Debug.Log("[IAP-Debug] User cancelled purchase");
                ShowTemporaryMessage("Purchase cancelled");
            }
            else
            {
                ShowTemporaryMessage($"Purchase failed: {error.Message}");
            }
            return;
        }

        Debug.Log($"[IAP-Debug] Purchase successful – unlocking game. SKU: {msg.Data.Sku}");
        EntitlementsManager.Instance?.MarkPurchasedLocally();
        ShowTemporaryMessage("Purchase successful! Thank you!");
    }

    // ------------------------------------------------------------------------
    // UI helpers
    // ------------------------------------------------------------------------
    private void RefreshUI(bool unlocked)
    {
        if (statusLabel)
            statusLabel.text = unlocked ? "Full Game Unlocked" : "Demo Mode";

        if (buyButton)
            buyButton.interactable = !unlocked && entitlementsReady;

        if (alreadyOwnedPanel && unlocked)
            alreadyOwnedPanel.SetActive(true);
    }

    private void ShowAlreadyOwnedMessage()
    {
        if (alreadyOwnedPanel)
        {
            alreadyOwnedPanel.SetActive(true);
        }
        else
        {
            ShowTemporaryMessage("You already own the full game!");
        }
    }

    private void ShowTemporaryMessage(string message)
    {
        if (statusLabel)
        {
            string originalText = statusLabel.text;
            statusLabel.text = message;
            StartCoroutine(RestoreTextAfterDelay(originalText, 3f));
        }
    }

    private IEnumerator RestoreTextAfterDelay(string originalText, float delay)
    {
        yield return new WaitForSeconds(delay);
        if (statusLabel)
            statusLabel.text = originalText;
    }

    private void OnDestroy()
    {
        if (EntitlementsManager.Instance)
            EntitlementsManager.Instance.OnFullUnlockChanged -= RefreshUI;
    }
}