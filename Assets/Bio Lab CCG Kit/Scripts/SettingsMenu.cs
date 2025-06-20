
//** Gameshard Studio **\\
                   // Bio Lab Card Game Template \\
                              //THIS SCRIPT USED FOR SETTINGS MENU ACTIONS

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;
using System.IO;
using UnityEngine.Events;
using UnityEngine.SceneManagement;
using System.Linq;

public class SettingsMenu : MonoBehaviour {

    public AudioMixer masterMixer;       // Main Mixer
    public AudioMixer fxMixer;           // FX Mixer
    public AudioMixer musicMixer;        // Music Mixer
    public Dropdown resolutionDropdown;  // Resolution Dropdown Menu
    public AudioClip menubuttonsound;    // Button Sound
    public AudioClip clickbutton;        // Button Click Sound
    public AudioSource menuAudio;        // Button Audiosource
    public GameObject OptionsMenu;       // Options Menu
    public GameObject settingsMenu;      // Settings Menu 
    public Resolution[] resolutions;     // Resolutions
    public MenuSettings menuSettings;    // Menu Settings
    public Button closeButton;           // Close & Save Button
    public Dropdown gameQualityDropdown; // Quality Dropdown Menu
    public Slider masterVolumeSlider;    // Master Volume Slider
    public Slider musicVolumeSlider;     // Music Volume Slider
    public Slider soundfxVolumeSlider;   // Sound Fx VolumeSlider
    public Toggle fullScreenToggle;
    public GameObject menuManager;
    public Image fpsImage;
    public Text fpsTxt;
    public Canvas settingsMenuCanvas;

    public GameObject fpsCounter = null;


    void Start()
    {

        OptionsMenu.SetActive(false);                        // If settings menu is active, close options menu.
        settingsMenuCanvas = GameObject.Find("SettingsMenu").GetComponent<Canvas>();

        menuAudio = GetComponent<AudioSource>();
        fpsTxt = GameObject.FindWithTag("FPSOn").GetComponent<Text>();


        if (GameObject.FindWithTag("FPSImage") != null)
        {
            fpsImage = GameObject.FindWithTag("FPSImage").GetComponent<Image>();
        }

     
    }

    public void ContinueButton(int sceneIndex)

    {
        SceneManager.LoadScene(sceneIndex);
    }
    

    void OnEnable()
    {
       
        menuSettings = new MenuSettings();

        resolutionDropdown.onValueChanged.AddListener(delegate { SetResolution(); });

        closeButton.onClick.AddListener(delegate { CloseSettingsMenu(); });


        resolutions = Screen.resolutions;
        foreach (Resolution resolution in resolutions)
        {
            
            resolutionDropdown.options.Add(new Dropdown.OptionData(resolution.ToString()));
        }

        LoadSettings();
    }       

    public void SetResolution()
    {

        Screen.SetResolution(resolutions[resolutionDropdown.value].width, resolutions[resolutionDropdown.value].height, Screen.fullScreen);
        menuSettings.resolutionIndex = resolutionDropdown.value;
        
    }

    public void ClickSoundPlay()
    {
        menuAudio.PlayOneShot(clickbutton, 0.7f);
    }

    public void FpsOnOff()
    {
        fpsTxt.enabled = !fpsTxt.enabled;
        fpsImage.enabled = !fpsImage.enabled;
         
    }

    public void SetVsyncOn()
    {
        QualitySettings.vSyncCount = 1;
    }

    public void SetVsyncOff()
    {
        QualitySettings.vSyncCount = 0;
    }

    public void SetMasterVolume(float masterVolume)
    {
        masterMixer.SetFloat("MasterVolume", masterVolume);  // Change master volume with slider.
        menuSettings.soundmasterVolume = masterVolumeSlider.value;
    }

    public void SetMusicVolume(float musicVolume)
    {
        musicMixer.SetFloat("MusicVolume", musicVolume);    // Change music volume with slider.
        menuSettings.musicVolume = musicVolumeSlider.value;
    }

    public void SetFxVolume(float fxVolume)
    {
        fxMixer.SetFloat("FxVolume", fxVolume);          // Change fx volume with slider.
        menuSettings.soundfxVolume = soundfxVolumeSlider.value;
    }

    public void SetQuality(int qualityIndex)
    {
        
        QualitySettings.SetQualityLevel(qualityIndex);
        menuSettings.qualityIndex = gameQualityDropdown.value;

    }

    public void SetFullScreen(bool isFullscreen)
    {
        Screen.fullScreen = isFullscreen;                // ON/OFF Fullscreen.
      //  menuAudio.PlayOneShot(menubuttonsound);          // Button Sound.
      if(Screen.fullScreen)
        {
            Screen.fullScreenMode = FullScreenMode.ExclusiveFullScreen;
        }
      else
        {
            Screen.fullScreenMode = FullScreenMode.FullScreenWindow;
        }

    }

    public void CloseSettingsMenu()
    {

        settingsMenuCanvas.enabled = false;                   // Close settings menu.
        OptionsMenu.SetActive(true);                                           // Activate options menu if settings menu is closed.                 
        menuAudio.PlayOneShot(menubuttonsound);                                // Button Sound.
       
        SaveSettings();                                                        // Save Setings
    }

    public void SaveSettings()  // Save Data
    {
        string jsonData = JsonUtility.ToJson(menuSettings, true);
        File.WriteAllText(Application.persistentDataPath + "/menusettings.json", jsonData);
    }

    public void LoadSettings()   // Load Data
    {
        menuSettings = JsonUtility.FromJson<MenuSettings>(File.ReadAllText(Application.persistentDataPath + "/menusettings.json"));

        resolutionDropdown.value = menuSettings.resolutionIndex;
        gameQualityDropdown.value = menuSettings.qualityIndex;
        masterVolumeSlider.value = menuSettings.soundmasterVolume;
        musicVolumeSlider.value = menuSettings.musicVolume;
        soundfxVolumeSlider.value = menuSettings.soundfxVolume;
        
        resolutionDropdown.RefreshShownValue();

    }

    void Awake()
    {

        DontDestroyOnLoad(this.fpsCounter);
        DontDestroyOnLoad(this.settingsMenu);
        DontDestroyOnLoad(this.menuManager);

        if (FindObjectsOfType(GetType()).Length > 1)
        {

            Destroy(this.fpsCounter);
            Destroy(this.settingsMenu);
            Destroy(this.menuManager);

        }
    }
}