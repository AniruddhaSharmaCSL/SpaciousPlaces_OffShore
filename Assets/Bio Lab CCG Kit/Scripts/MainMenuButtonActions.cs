
//** Gameshard Studio **\\
              // Bio Lab Card Game Template \\
                         //THIS SCRIPT USED FOR MAIN MENU BUTTON ACTIONS


using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class MainMenuButtonActions : MonoBehaviour
{
    public GameObject button_1, button_2, button_3, button_4, button_5;   // Buttons

    public Color hoverColor;                  // Button Hover Color

    public AudioSource buttonClickAudio;      // Button Audiosource
    public AudioClip buttonClickSound;        // Button Sound
    public AudioClip buttonHoverSound;        // Button Hover Sound

    public GameObject buttonHighLight1;       // Button Choosen Image 1
    public GameObject buttonHighLight2;       // Button Choosen Image 2
    public GameObject buttonHighLight3;       // Button Choosen Image 3
    public GameObject buttonHighLight4;       // Button Choosen Image 4
    public GameObject buttonHighLight5;       // Button Choosen Image 5
    public GameObject settingsMenu;           // Settings Menu
    private Canvas settingsMenuCanvas;        // Settings Menu Canvas

    public Image button1;           // Button Highliht Image 1
    public Image button2;           // Button Highliht Image 2
    public Image button3;           // Button Highliht Image 3
    public Image button4;           // Button Highliht Image 4
    public Image button5;           // Button Highliht Image 5

    void Start()
    {
        settingsMenuCanvas = GameObject.Find("SettingsMenu").GetComponent<Canvas>();    // Find Settings Menu Canvas

        button1.enabled = false;           // Find and Disable Button 1 Choosen Image
        button2.enabled = false;        // Find and Disable Button 2 Choosen Image
        button3.enabled = false;          // Find and Disable Button 3 Choosen Image
        button4.enabled = false;          // Find and Disable Button 4 Choosen Image
        button5.enabled = false;          // Find and Disable Button 5 Choosen Image
        Cursor.visible = true;
    }

    public void enterEffect1()
    {

        button1 = GameObject.Find("SelectedHighlight1").GetComponent<Image>();
        button1.enabled = true;             // Show Button 1 Choosen Image Effect
        buttonHighLight1.GetComponent<Animator>().Play("HighlightFadeIn");    // Play Button 1 Choosen Image Animation
        button_1.GetComponent<Animator>().Play("Button1");                    // Play Button 1 Animation
   
    }

    public void buttonHoverSoundPlay()
    {
        buttonClickAudio.PlayOneShot(buttonHoverSound);         // Play Button Hover Sound
    }

    public void buttonClickPlay()
    {
        buttonClickAudio.PlayOneShot(buttonClickSound);         // Play Button Click Sound
    }


    public void exitEffect1()

    {  
        buttonHighLight1.GetComponent<Animator>().Play("HighlightFadeOut");   // Play Buttons Fadeout Effect
        StartCoroutine("DelayForFade1");                                      // Start Delay Effect Coroutine

    }

    public void enterEffect2()

    {
        button2 = GameObject.Find("SelectedHighlight2").GetComponent<Image>();
        button2.enabled = true;
        buttonHighLight2.GetComponent<Animator>().Play("HighlightFadeIn");
        button_2.GetComponent<Animator>().Play("Button2");

    }

    public void exitEffect2()

    {
        
        buttonHighLight2.GetComponent<Animator>().Play("HighlightFadeOut");
        StartCoroutine("DelayForFade2");
    }

    public void enterEffect3()

    {
        button3 = GameObject.Find("SelectedHighlight3").GetComponent<Image>();
        button3.enabled = true;
        buttonHighLight3.GetComponent<Animator>().Play("HighlightFadeIn");
        button_3.GetComponent<Animator>().Play("Button3");

    }

    public void exitEffect3()

    {
        buttonHighLight3.GetComponent<Animator>().Play("HighlightFadeOut");
        StartCoroutine("DelayForFade3");
    }

    public void enterEffect4()

    {
        button4 = GameObject.Find("SelectedHighlight4").GetComponent<Image>();
        button4.enabled = true;
        buttonHighLight4.GetComponent<Animator>().Play("HighlightFadeIn");
        button_4.GetComponent<Animator>().Play("Button4");
    }

    public void exitEffect4()

    {
        buttonHighLight4.GetComponent<Animator>().Play("HighlightFadeOut");
        StartCoroutine("DelayForFade4");
    }

    public void enterEffect5()

    {
        button5 = GameObject.Find("SelectedHighlight5").GetComponent<Image>();
        button5.enabled = true;
        buttonHighLight5.GetComponent<Animator>().Play("HighlightFadeIn");
        button_5.GetComponent<Animator>().Play("Button5");
    }

    public void exitEffect5()

    {
        buttonHighLight5.GetComponent<Animator>().Play("HighlightFadeOut");
        StartCoroutine("DelayForFade5");
    }


    IEnumerator DelayForFade1()
    {
        yield return new WaitForSeconds(0.35f);  // Disable the highlight image 1
        button1.enabled = false;
    }

    IEnumerator DelayForFade2()
    {
        yield return new WaitForSeconds(0.35f);  // Disable the highlight image 2
        button2.enabled = false;
    }

    IEnumerator DelayForFade3()
    {
        yield return new WaitForSeconds(0.35f);  // Disable the highlight image 3
        button3.enabled = false;
    }

    IEnumerator DelayForFade4()
    {
        yield return new WaitForSeconds(0.35f);  // Disable the highlight image 4
        button4.enabled = false;
    }

    IEnumerator DelayForFade5()
    {
        yield return new WaitForSeconds(0.35f);  // Disable the highlight image 5
        button5.enabled = false;
    }


    public void SoloButton()
    {
        button1.GetComponent<Animator>().Play("Button1Choosed");
        SceneManager.LoadScene("Game Scene");
    }

    public void RankedButton()
    {
        SceneManager.LoadScene("Game Scene");

    }

    public void ArcadeButton()
    {
        SceneManager.LoadScene("Game Scene");

    }

    public void SettingsButton()
    {
        settingsMenuCanvas.enabled = true;

    }

    public void ExitButton()
    {
        Application.Quit();
    }


}
