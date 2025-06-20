
//** Gameshard Studio **\\
                // Bio Lab Card Game Template \\
                             //THIS SCRIPT USED FOR VENT ACTIONS

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VentsClick : MonoBehaviour
{

    public GameObject Vent1;       // Vent 1 Gameobject
    public GameObject Vent2;       // Vent 2 Gameobject
    public GameObject Vent3;       // Vent 3 Gameobject
    public GameObject Vent4;       // Vent 4 Gameobject

    public AudioSource ventAudio;        // Vent Click Audiosource
    public AudioClip ventClickSound;   // Vent Click Audioclip.

    public ParticleSystem ventSmoke1;         // Vent1 Smoke particle.
    public ParticleSystem ventSmoke2;         // Vent2 Smoke particle.
    public ParticleSystem ventSmoke3;         // Vent3 Smokeparticle.
    public ParticleSystem ventSmoke4;         // Vent4 Smoke particle.

    int counter = 0;

    /// Find Gameobjects & GameComponents
    void Start()
    {
        ventAudio = GetComponent<AudioSource>();            // Find vent audio source. 
        Vent1 = GameObject.Find("Vent 1");      // Find Vent1.
        Vent2 = GameObject.Find("Vent 2");      // Find Vent2.
        Vent3 = GameObject.Find("Vent 3");      // Find Vent3.
        Vent4 = GameObject.Find("Vent 4");      // Find Vent4.
    }

    IEnumerator VentPlay1()
    {
        yield return new WaitForSeconds(3.0f); 
        ventSmoke1.GetComponent<ParticleSystem>().Play();
        Vent1.GetComponent<Animator>().Play("FanAnimation");
    }

    IEnumerator VentPlay2()
    {
        yield return new WaitForSeconds(3.0f);  
        ventSmoke2.GetComponent<ParticleSystem>().Play();
        Vent2.GetComponent<Animator>().Play("FanAnimation");
    }

    IEnumerator VentPlay3()
    {
        yield return new WaitForSeconds(3.0f);  
        ventSmoke3.GetComponent<ParticleSystem>().Play();
        Vent3.GetComponent<Animator>().Play("FanAnimation");
    }

    IEnumerator VentPlay4()
    {
        yield return new WaitForSeconds(3.0f);  
        ventSmoke4.GetComponent<ParticleSystem>().Play();     
        Vent4.GetComponent<Animator>().Play("FanAnimation");
    }

    /// If Counts reached, vents broken.
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {   // Detect Mouse Click

            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);      // Ray for detect different colliders
            RaycastHit hit;
  

            if (Physics.Raycast(ray, out hit))
            {
                if (hit.transform.name == "Vent 1")
                {
                    
                        if (counter <= 9)
                        {
                            Vent1.GetComponent<Animator>().Play("FanStop");  // Play Animation
                            counter++;                                                          // If detect player click on vent1, make count +1.
                            ventAudio.PlayOneShot(ventClickSound);                              // Play Sound
                            ventSmoke1.GetComponent<ParticleSystem>().Stop();
                            StartCoroutine("VentPlay1");
                        }

                        if (counter == 9)
                        {                  // If vent click counter reached 9 destroy the Vent1. You can change count number.
                            Vent1.GetComponent<Animator>().Play("VentBroken");
                            counter = 0;
                        }

                }
                

                if (hit.transform.name == "Vent 2")
                {
                    if (counter <= 9)
                    {
                        Vent2.GetComponent<Animator>().Play("FanStop");  // Play Animation
                        counter++;                                                          // If detect player click on vent2, make count +1.
                        ventAudio.PlayOneShot(ventClickSound);                              // Play Sound
                        ventSmoke2.GetComponent<ParticleSystem>().Stop();
                        StartCoroutine("VentPlay2");
                    }

                    if (counter == 9)
                    {                  // If vent click counter reached 9 destroy the Vent 2. You can change count number.

                        Vent2.GetComponent<Animator>().Play("VentBroken");
                        counter = 0;
                    }
                    
                }

                if (hit.transform.name == "Vent 3")
                {
                    if (counter <= 9)
                    {
                        Vent3.GetComponent<Animator>().Play("FanStop");  // Play Animation
                        counter++;                                                          // If detect player click on vent3, make count +1.
                        ventAudio.PlayOneShot(ventClickSound);                              // Play Sound
                        ventSmoke3.GetComponent<ParticleSystem>().Stop();
                        StartCoroutine("VentPlay3");
                    }

                    if (counter == 9)
                    {                  // If vent click counter reached 9 destroy the Vent3. You can change count number.

                        Vent3.GetComponent<Animator>().Play("VentBroken");
                        counter = 0;
                    }
                    
                }

                if (hit.transform.name == "Vent 4")
                {
                    if (counter <= 9)
                    {
                        Vent4.GetComponent<Animator>().Play("FanStop");  // Play Animation
                        counter++;                                                          // If detect player click on vent4, make count +1.
                        ventAudio.PlayOneShot(ventClickSound);                              // Play Sound
                        ventSmoke4.GetComponent<ParticleSystem>().Stop();
                        StartCoroutine("VentPlay4");
                    }

                    if (counter == 9)
                    {                  // If vent click counter reached 9 destroy the Vent4. You can change count number.

                        Vent4.GetComponent<Animator>().Play("VentBroken");
                        counter = 0;
                    }
                    
                }
            }
        }
    }
}