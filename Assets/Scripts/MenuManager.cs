using Oculus.Interaction.HandGrab;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class MenuManager : MonoBehaviour
{
    public static MenuManager instance;

    [Header("Hand tracking grab")]
    [SerializeField] GameObject grabToggle;
    [SerializeField] GameObject grabText;

    private HandGrabInteractor[] handGrabInteractors = new HandGrabInteractor[0];

    private bool handTrackingEnabled;

    private void Awake() {
        if (instance == null)
            instance = this;

        transform.parent.gameObject.SetActive(false);
    }

    public void SetGrabToggle(Toggle grabTG , TextMeshProUGUI grabTt) {
        grabToggle = grabTG.gameObject;
        grabText = grabTt.gameObject; 
    }

    public GameObject getSettingPanel() {
        Debug.LogError(transform.parent.gameObject.name);
        return transform.parent.gameObject; 
    }
    private void Start()
    {
        handGrabInteractors = FindObjectsByType<HandGrabInteractor>(sortMode: FindObjectsSortMode.None);

        handTrackingEnabled = OVRPlugin.GetHandTrackingEnabled();

        grabToggle.SetActive(handTrackingEnabled);
        grabText.SetActive(handTrackingEnabled);
        
        foreach (var handGrabInteractor in handGrabInteractors)
        {
            handGrabInteractor.gameObject.SetActive(false);
        }
    }
    private void Update()
    {
        bool currentHandTrackingState = OVRPlugin.GetHandTrackingEnabled();

        if (handTrackingEnabled != currentHandTrackingState)
        {
            handTrackingEnabled = currentHandTrackingState;
            grabToggle.SetActive(handTrackingEnabled);
            grabText.SetActive(handTrackingEnabled);
        }
    }

    public void OnGrabToggleChanged(bool value)
    {
        foreach (var handGrabInteractor in handGrabInteractors)
        {
            handGrabInteractor.gameObject.SetActive(value);
        }
    }
}
