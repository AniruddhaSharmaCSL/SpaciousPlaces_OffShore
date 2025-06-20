
//** Gameshard Studio **\\
                   // Bio Lab Card Game Template \\
                                      //THIS SCRIPT USED FOR CLOSE THE SETTINGS MENU

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloseButton : MonoBehaviour {

	public GameObject popUpmenu;       // Options Menu

    public GameObject settingsMenu;    // Settings Menu

    public GameObject closeButton;     // Close Button Object


  /// This Function Script Attached On Settings Menu Canvas.
    public void CloseSettingsMenu()
	{
		popUpmenu.SetActive(false);      // When pressed a settings button, options menu will disable.
        settingsMenu.SetActive(true);    // Settings menu set active.
    }
}
