
//** Gameshard Studio **\\
                   // Bio Lab Card Game Template \\
                                 //THIS SCRIPT USED FOR END TURN BUTTON ACTION

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EndTurnButton : MonoBehaviour {

	public GameObject endTurnButton;      // End Turn Button
	public AudioClip endTurnSound;        // End Turn Audioclip
	public AudioSource endTurnAudio;      // End Turn Audiosource
	public ParticleSystem buttonSparks;   // End Turn Button Particle
    public GameObject enemyTurnText;      // Enemy Turn Text
    public GameObject endTurnText;        // End Turn Text

    public Material[] material;

    public Renderer rend1;

    /// Find GAmeobjects & Components
    void Start()
	{
		endTurnButton = GameObject.Find ("End Turn Button");      // Find End Turn Object 
		endTurnAudio = GetComponent<AudioSource> ();              // Find End Turn Button Audiosource
        enemyTurnText = GameObject.Find("Enemy Turn Text");       // Enemy Turn Text
        endTurnText = GameObject.Find("End Turn Text");           // End Turn Text
        enemyTurnText.SetActive(false);                           // Disable Enemy Turn Text When Game Started
        rend1.enabled = true;
        rend1.sharedMaterial = material[0];
    }

    IEnumerator WaitEnemyTurn()            // Enemy Turn Wait Time
    {
        yield return new WaitForSeconds(4.0f);       
        endTurnButton.GetComponent<Animator>().Play("EnemyTurnButtonAnim");
        enemyTurnText.SetActive(false);               // Disable Enemy Turn Text
        endTurnText.SetActive(true);                  // Enable End Turn Text
        endTurnButton.GetComponent<MeshCollider>().enabled = true;
        rend1.sharedMaterial = material[0];

    }

    void OnMouseOver()
	{
		if(Input.GetMouseButtonDown(0))  // Detect Mouse Click
		{
            rend1.sharedMaterial = material[1];
            endTurnButton.GetComponent<MeshCollider>().enabled = false;
			endTurnButton.GetComponent<Animator>().Play("EndTurnButtonAnim");     // Play animation.
	        buttonSparks.GetComponent<ParticleSystem>().Play();       // Play Particle System
			endTurnAudio.PlayOneShot (endTurnSound, 1.0F);              // Play End Turn Sound 
            endTurnText.SetActive(false);
            if (endTurnText.activeSelf)
            {           /// If Enemy Turn text is active, do set disable. 
				enemyTurnText.SetActive(false);
            }
            else
            {
                enemyTurnText.SetActive(true);      /// If Enemy Turn text is disabled, do set active.
				
            }

            StartCoroutine("WaitEnemyTurn");

        }

   }
}
