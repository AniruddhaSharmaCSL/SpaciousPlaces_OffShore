
//** Gameshard Studio **\\
                   // CCG Game Template \\
                              //THIS SCRIPT USED FOR OPTIONS MENU ACTIONS

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class OptionsMenu : MonoBehaviour {

	public Color normalColor;                 // Button Normal Color
    public GameObject optionsMenu;            // Options Menu
    public GameObject settingsMenu;           // Settings Menu
    public GameObject button_1, button_2, button_3, button_4;   // Buttons
    public Color hoverColor;                  // Button Hover Color
    public AudioSource buttonClickAudio;      // Button Audiosource
    public AudioClip buttonClickSound;        // Button Sound
    public AudioSource buttonHoverAudio;
    public AudioClip buttonHoversound;

	RaycastHit ObjectHitByMouseRaycast;       // Raycast

    public GameObject youLoseScreen;
    public Canvas settingsMenuCanvas;

    bool soundplayed1;
    bool soundplayed2;
    bool soundplayed3;
    bool soundplayed4;

    void Start()
    {
        Cursor.visible = true;

        soundplayed1 = false;
        soundplayed2 = false;
        soundplayed3 = false;
        soundplayed4 = false;

        youLoseScreen.SetActive(false);
        settingsMenu = GameObject.Find("SettingsMenu");
        settingsMenuCanvas = GameObject.Find("SettingsMenu").GetComponent<Canvas>();
    }

    public void showGameOver()
    {
        youLoseScreen.SetActive(true);
    }

    public void ContinueButton(int sceneIndex)
    {
        SceneManager.LoadScene(sceneIndex);
    }

    void Update () 
{

	Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

	if (Physics.Raycast(ray.origin, ray.direction, out ObjectHitByMouseRaycast, 150))
	{

			if (ObjectHitByMouseRaycast.collider.gameObject.name == "ResumeButton") {
          
                if (optionsMenu.activeSelf) {
                    
					button_1.GetComponent<Renderer> ().material.SetColor ("_Color", hoverColor);
					button_1.GetComponent<Animator> ().Play ("Menubuttonanimation");
                    if (!soundplayed1)
                    {
                        buttonHoverAudio.PlayOneShot(buttonHoversound);
                        soundplayed1 = true;
                    }
                    if (Input.GetMouseButtonDown(0))
                    {
                        buttonClickAudio.PlayOneShot(buttonClickSound);
                        optionsMenu.SetActive(false);     
                    }
                }
			}

            else {
				if (optionsMenu.activeSelf) {
					button_1.GetComponent<Renderer> ().material.SetColor ("_Color", normalColor);
					button_1.GetComponent<Animator> ().Play ("Normal");
                    soundplayed1 = false;
				}
			}

			if (ObjectHitByMouseRaycast.collider.gameObject.name == "GiveUpButton") {
				if (optionsMenu.activeSelf) {
                    
                    button_2.GetComponent<Renderer> ().material.SetColor ("_Color", hoverColor);
					button_2.GetComponent<Animator> ().Play ("Menubuttonanimation");
                    if (!soundplayed2)
                    {
                        buttonHoverAudio.PlayOneShot(buttonHoversound);
                        soundplayed2 = true;
                    }

                    if (Input.GetMouseButtonDown(0))
                    {
                        buttonClickAudio.PlayOneShot(buttonClickSound);
                        youLoseScreen.SetActive(true);
                        optionsMenu.SetActive(false);
                    }
                }
			}

            else {
				if (optionsMenu.activeSelf) {
					button_2.GetComponent<Renderer> ().material.SetColor ("_Color", normalColor);
					button_2.GetComponent<Animator> ().Play ("Normal");
                    soundplayed2 = false;
				}
			}

			if (ObjectHitByMouseRaycast.collider.gameObject.name == "SettingsButton") {
				if (optionsMenu.activeSelf) {
                    
                    button_3.GetComponent<Renderer> ().material.SetColor ("_Color", hoverColor);
					button_3.GetComponent<Animator> ().Play ("Menubuttonanimation");
                    if (!soundplayed3)
                    {
                        buttonHoverAudio.PlayOneShot(buttonHoversound);
                        soundplayed3 = true;
                    }
                    if (Input.GetMouseButtonDown(0))
                    {
                        buttonClickAudio.PlayOneShot(buttonClickSound);
                        settingsMenuCanvas.enabled = true;            
                    }
				}
			}

            else {
				if (optionsMenu.activeSelf) {
					button_3.GetComponent<Renderer> ().material.SetColor ("_Color", normalColor);
					button_3.GetComponent<Animator> ().Play ("Normal");
                    soundplayed3 = false;
                }
			}

			if (ObjectHitByMouseRaycast.collider.gameObject.name == "ExitButton") {
				if (optionsMenu.activeSelf) {
                   
                    button_4.GetComponent<Renderer> ().material.SetColor ("_Color", hoverColor);
					button_4.GetComponent<Animator> ().Play ("Menubuttonanimation");
                    if (!soundplayed4)
                    {
                        buttonHoverAudio.PlayOneShot(buttonHoversound);
                        soundplayed4 = true;
                    }

                    if (Input.GetMouseButtonDown(0))
                    {
                        buttonClickAudio.PlayOneShot(buttonClickSound);
                        SceneManager.LoadScene("Main Scene");                       
                    }
                }
			}

            else {
				if (optionsMenu.activeSelf) {
					button_4.GetComponent<Renderer> ().material.SetColor ("_Color", normalColor);
					button_4.GetComponent<Animator> ().Play ("Normal");
                    soundplayed4 = false;
                }
			}

            if(Input.GetKeyDown(KeyCode.Escape))
            {
                if(optionsMenu.activeInHierarchy == true)
                {
                    optionsMenu.SetActive(false);
                }
                else
                {
                    optionsMenu.SetActive(true);

                }
            }
		}
	}
}