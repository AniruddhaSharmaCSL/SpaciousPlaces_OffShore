
//** Gameshard Studio **\\
                 // Bio Lab Card Game Template \\
                              //THIS SCRIPT USED FOR SURGERY LIGHT ACTION

using UnityEngine;
using System.Collections;

public class SurgeryLightAction : MonoBehaviour
{

    public AudioClip surgeryLightClick;    // Surgery Light Audio Clip
    public AudioSource surgeryAudio;      // Surgery Light AudioSource
    public GameObject surgeryLight;      // Find Surgery Light Object

    void Start()
    {
        surgeryAudio = GetComponent<AudioSource>();            // Find Surgery audio source. 
    }

    void OnMouseDown()
    {
 
        surgeryLight.GetComponent<Animator>().Play("SurgeryLight");
        surgeryAudio.PlayOneShot(surgeryLightClick);
    }

}