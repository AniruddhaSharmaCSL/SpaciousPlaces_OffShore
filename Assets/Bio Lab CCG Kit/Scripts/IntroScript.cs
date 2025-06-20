
//** Gameshard Studio **\\
                   // Bio Lab Card Game Template \\
                                  //THIS SCRIPT USED FOR INTRO SCENE

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using System;

public class IntroScript : MonoBehaviour {

	public GameObject LoadingCircle; // Loading Sprite
	public GameObject PressAnyKey;   // Press Any Key Text
	public GameObject FadePlane;     // Fade Effect Plane After Click 
	public GameObject GameMusic;     // Intro Scene Music
    public GameObject menuManager;
    public LoadingScreen myLoadScript;


	void Start()
	{
	//	LoadingCircle = GameObject.Find ("LoadingCircle");  // LOAD TIME CIRCLE SPRITE
	//	PressAnyKey = GameObject.Find ("PressAnyKey");      // ANY KEY GAME OBJECT
	//	FadePlane = GameObject.Find ("FadePlane");          // FADE TO BLACK SPRITE
	//	GameMusic = GameObject.Find ("Game Music");          // FIRST SCENE BACKGROUND MUSIC 
		PressAnyKey.SetActive (false);                      // Any Key Game Object Set Disable at first.
		StartCoroutine("WaitLoadscreen");                   // Wait After the click screen coroutine.
        Cursor.visible = false;
    }

	   IEnumerator WaitLoadscreen()
	{
		yield return new WaitForSeconds (4.0f);  // Disable the loading icon after 4 seconds
		LoadingCircle.SetActive (false);         // Disable Loading Circle
		PressAnyKey.SetActive (true);            // Show Press Any Key Text After Loading Circle is Disabled.
	}

      public void Update()
	{
		if(PressAnyKey.activeSelf)   // Detect any key press
		{


			if(Input.anyKeyDown) {

                GameObject menuManager = GameObject.Find("FirstScreen_MenuManager");
                LoadingScreen loadAccess = menuManager.GetComponent<LoadingScreen>();
                loadAccess.LoadLevel();
                //	StartCoroutine("WaitTheAnotherseconds");                            /// If any key or mouse click detected, time coroutine is started.
                FadePlane.GetComponent<Animator> ().Play ("MenuFadeOut");            /// Screen fade effect before scene change. 
				GameMusic.GetComponent<Animator>().Play ("MusicFadeOut");    /// If click any button, background music fade out until the scne changes.
                
			}
		}
	}
        /// Wait time for fade to black effect animation after the key press.
	  //  IEnumerator WaitTheAnotherseconds()
	// {
		//yield return new WaitForSeconds (2.0f);
		//SceneManager.LoadScene ("Main Menu");   // Load Main Menu Scene After 2 Seconds
	// }

    public void Exit()
    {
        Application.Quit();
    }

}