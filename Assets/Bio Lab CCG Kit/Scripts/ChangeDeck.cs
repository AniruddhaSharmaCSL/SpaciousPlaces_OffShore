using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeDeck : MonoBehaviour {

    public GameObject savedDeck;

    // Use this for initialization
    void Start () {
        Cursor.visible = true;
    }
    public void DeckSavedScreen()
    {
        savedDeck.GetComponent<Animator>().Play("DeckSaved");
    }
	
	// Update is called once per frame
	void Update () {

    }
}
