
//** Gameshard Studio **\\
             // BioLab Card Game Template \\
                           //THIS SCRIPT USED FOR MENU EVENT SYSTEM FOR KEYBOARD CONTROL

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class MenuEventSystem : MonoBehaviour {

    public EventSystem EventSystm;

    private GameObject KeepSelected;

	// Use this for initialization
	void Start ()
    {
        KeepSelected = EventSystm.firstSelectedGameObject;
	}
	
	// Update is called once per frame
	void Update ()
    {
	if(EventSystm.currentSelectedGameObject != KeepSelected)
        {
            if (EventSystm.currentSelectedGameObject == null)
                EventSystm.SetSelectedGameObject(KeepSelected);

            else
            {
                KeepSelected = EventSystm.currentSelectedGameObject;
            }
        }
        
	}
}
