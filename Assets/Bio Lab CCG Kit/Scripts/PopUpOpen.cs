///** Gameshard Studio **\\
                   // Battle Royale Card Game Template \\
//THIS SCRIPT USED FOR OPTIONS POP UP MENU ACTIVATE

using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class PopUpOpen : MonoBehaviour {

	public GameObject optionsmenuPopup;      // Options Menu

    public AudioClip menubuttonsound1;       // Menu Button Sound

    public AudioSource menubuttonAudio;      // Menu Button Audio Clip


    /// Find Component
	void Start()
	{	
		menubuttonAudio = GetComponent<AudioSource> ();     // Audiosource 
	}

	public void PopOpen()
	{
		
			if (optionsmenuPopup.activeInHierarchy == true) {        // Check Options Menu Object - If Active -- > Set disable
				optionsmenuPopup.SetActive (false);                 
			}
			else 
			{
				optionsmenuPopup.SetActive (true);                  // Check Options Menu Object - If Disabled -- > Set active
                menubuttonAudio.PlayOneShot (menubuttonsound1, 0.8F);     // Play Sound
		    }
	
   }

}