using UnityEngine;
using Oculus.Platform;
using SpaciousPlaces;

/// <summary>
/// Initializes the Meta XR Platform layer once, as early as possible.
/// Keep this in its own scene or on the first scene that loads
/// </summary>
public class PlatformInit : MonoBehaviour
{
    [Tooltip("Meta Quest App ID (from developer dashboard)")]
    [SerializeField] private string questAppID = "8410008925778451";

    private void Awake()
    {
        // Avoid duplicate initialisation if you reload the scene.
        if (!Core.IsInitialized())
        {
            Debug.Log($"[IAP‑Debug] Initializing Platform with App ID: {questAppID}");
            // Core.AsyncInitialize boots the platform services on device.
            // In the Editor it simply returns immediately.
            Core.AsyncInitialize(questAppID);
            Debug.Log("[IAP‑Harness] Platform initialized.");
        }
        else
        {
            Debug.Log("[IAP‑Debug] Platform already initialized, skipping");
        }

        //Users.GetLoggedInUser().OnComplete(OnMetaUserReceived);

    }

    //private void OnMetaUserReceived(Message<User> message) {
    //    if (!message.IsError) {
    //        AssignMetaID(message.Data.ID.ToString());
    //    }
    //    else {
    //        Debug.LogError("[MetaInit] Failed to fetch Meta User ID: " + message.GetError().Message);
    //    }
    //}

}
