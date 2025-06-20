using SpaciousPlaces;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using Oculus.Interaction.HandGrab;
using UnityEngine.Rendering.Universal;
using VRUIP;
using static ModeManager;

public class ControlPanelManager : MonoBehaviour
{
    public static ControlPanelManager Instance;
    [SerializeField] private GameObject confirmationPanel;
    [SerializeField] private Button homeButton;
    [SerializeField] private Button settingButton;
    [SerializeField] private Button modeButton;
    [SerializeField] private Button yesButton;
    [SerializeField] private Button noButton;
    [SerializeField] private GameObject grabToggle;
    [SerializeField] private TextMeshProUGUI gameModeText;
    [SerializeField] private GameObject grabIndicator;

    [SerializeField] private GameObject settingPanel;
    [SerializeField] private ModeManager modeManager = null;

    [SerializeField] private Sprite instrumentIcon;
    [SerializeField] private Sprite creativeIcon;
    [SerializeField] private Sprite breathingIcon;
    [SerializeField] private Sprite grabOnIcon;
    [SerializeField] private Sprite grabOffIcon;
    [SerializeField] private GameObject grabDisabledIcon;

    [SerializeField] private Image grabDefaultButton;


    [SerializeField] private GameObject InstrumentMode;
    [SerializeField] private GameObject BreathingMode;

    private HandGrabInteractor[] handGrabInteractors;
    private GameMode currentMode;
    private string currentModeText = "Instrument";
    private bool isGrabOn = false;
    private bool homeButtonPressed = false;

    private void Awake() {
        if (Instance == null) {
            Instance = this;
        }
    }

    void Start()
    {
        settingPanel.SetActive(false);
        AddListerners();

        handGrabInteractors = FindObjectsByType<HandGrabInteractor>(sortMode: FindObjectsSortMode.None);

        bool currentState = OVRPlugin.GetHandTrackingEnabled();
        grabToggle.GetComponent<ButtonController>().interactable = currentState;
        grabToggle.GetComponent<Button>().interactable = currentState;

        foreach (var handGrabInteractor in handGrabInteractors) {
            handGrabInteractor.enabled = false;
        }
    }

    private void OnEnable() {
        if (MoodRegistrationManager.Instance != null)
        {
            modeManager = MoodRegistrationManager.Instance.GetModeManager();
            DetectAndSetCurrentMode();
        }
    }
    private void AddListerners() {
        homeButton.onClick.AddListener(EnableConfirmationPanel);
        settingButton.onClick.AddListener(ToggleSettingPanels);
        modeButton.onClick.AddListener(ToggleMode);
        yesButton.onClick.AddListener(ToHomeScene);
        noButton.onClick.AddListener(CancelConfirmation);
        grabToggle.GetComponent<Button>().onClick.AddListener(GrabToggle);
    }

    private void DetectAndSetCurrentMode() {
        currentMode = modeManager.CurrentMode;
        if (currentMode == GameMode.Instrument) {
            Debug.Log("Current Mode: " + currentMode);
            modeButton.transform.GetChild(1).GetComponent<Image>().sprite = instrumentIcon;
        }
        else if (currentMode == GameMode.Creative) {
            Debug.Log("Current Mode: " + currentMode);

            modeButton.transform.GetChild(1).GetComponent<Image>().sprite = creativeIcon;
        }
        else if (currentMode == GameMode.Breathing) {
            Debug.Log("Current Mode: " + currentMode);

            modeButton.transform.GetChild(1).GetComponent<Image>().sprite = breathingIcon;
        }

    }

    private void EnableConfirmationPanel() {

        if (!confirmationPanel.activeSelf) {
           confirmationPanel.SetActive(true);
            //settingPanel.SetActive(false);
        }
        else {
            confirmationPanel.SetActive(false);
            //settingPanel.SetActive(true);
        }
    }

    private void ToggleSettingPanels() {
        Debug.Log("Toggling setting panel visibility");
        if (!settingPanel.activeSelf) {
            settingPanel.SetActive(true);
            //confirmationPanel.SetActive(false);
        }
        else {
            settingPanel.SetActive(false);
            //confirmationPanel.SetActive(true);
        }
    }

    private void ToggleMode() {
        if (modeManager != null)
        {
            modeManager.CycleModes();
            DetectAndSetCurrentMode();
        }
    }


    private void ToHomeScene() {
        confirmationPanel.SetActive(false);
        homeButton.interactable = false;
        settingButton.interactable = false;
        modeButton.interactable = false;
        grabToggle.GetComponent<Button>().interactable = false;
        grabToggle.GetComponent<ButtonController>().interactable = false;
        MoodRegistrationManager.Instance.ShowEndPanel();
    }

    private void CancelConfirmation() {
        confirmationPanel.SetActive(false);
    }

    private void GrabToggle() {

        if (isGrabOn) {
            Debug.Log("Grab toggled off");
            isGrabOn = false;
            grabDefaultButton.sprite = grabOffIcon;
        }
        else {
            Debug.Log("Grab toggled on");
            isGrabOn = true;
            grabDefaultButton.sprite = grabOnIcon;
        }
        Debug.Log("Grab toggle is " + isGrabOn);
        handGrabInteractors = FindObjectsByType<HandGrabInteractor>(sortMode: FindObjectsSortMode.None);
        foreach (var handGrabInteractor in handGrabInteractors) {
            handGrabInteractor.enabled = isGrabOn;
            Debug.Log("Interactor: " + handGrabInteractor.name + " Active: " + handGrabInteractor.enabled);
        }
    }

    public void setGameModeText(string txt) {
        currentModeText = txt;
    }

    public void toggleControlPanel() {

        if (SceneManager.GetActiveScene().name == SceneUtils.Names.Main) {
            if (!gameObject.activeSelf) {
                gameObject.SetActive(true);
            }
            else {
                gameObject.SetActive(false);
            }
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (modeManager == null)
        {
            if (MoodRegistrationManager.Instance != null)
            {
                modeManager = MoodRegistrationManager.Instance.GetModeManager();
                DetectAndSetCurrentMode();
            }
        }

        bool currentState = OVRPlugin.GetHandTrackingEnabled();
        grabToggle.GetComponent<ButtonController>().interactable = currentState;
        grabToggle.GetComponent<Button>().interactable = currentState;
        grabDisabledIcon.SetActive(!currentState);
    }
}
