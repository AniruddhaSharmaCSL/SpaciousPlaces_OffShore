
//** Gameshard Studio **\\
                   // Bio Lab Card Game Art Template \\
                             //THIS SCRIPT USED FOR PNEUMATIC ARMS ACTION

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PneumaticsAction : MonoBehaviour
{

    public GameObject yellowArm;    // Yellow Penumatic Arm Gameobject
    public GameObject whiteArm;     // White Penumatic Arm Gameobject
    public GameObject emergencyLights; // Emergency Signal for Penumatic Arm

    public AudioClip robotarm1;  // Yellow Pneumatic Arm Audio 1
    public AudioClip robotarm2;  // White Pneumatic Arm Audio 1
    public AudioClip robotarm3;  // Yellow Pneumatic Arm Audio 2
    public AudioClip robotarm4;  // Yellow Pneumatic Arm Audio 3

    public AudioSource robotAudio; // Yellow Pneumatic AudioSource
    public AudioSource robotAudio2; // White Pneumatic AudioSource

    public Material[] material;  // Pneumatic Signal Light Materials

    public Renderer rend1;      // White Signal 1
    public Renderer rend2;      // White Signal 2
    public Renderer rend3;      // White Signal 3
    public Renderer rend4;      // Yellow Signal 1
    public Renderer rend5;      // Yellow Signal 2
    public Renderer rend6;      // Yellow Signal 3

    Animator anim;
    Animator anim2;

    /// Find Gameobjects & Components.
	void Start()
    {
        yellowArm = GameObject.Find("Pneumatic Arm Yellow");   // Find Yellow Arm Game Object in Hierarchy
        whiteArm = GameObject.Find("Pneumatic Arm White");     // Find White Arm Game Object in Hierarchy

        robotAudio = GetComponent<AudioSource>();   // Find White Arm AudioSource
        robotAudio2 = GetComponent<AudioSource>();  // Find Yellow Arm AudioSource
        anim = yellowArm.GetComponent<Animator>();  // Find Yellow Arm Animator
        anim2 = whiteArm.GetComponent<Animator>();  // Find White Arm Animator

        rend1 = GameObject.Find("signal1").GetComponent<Renderer>();      // Find White Signal 1
        rend2 = GameObject.Find("signal2").GetComponent<Renderer>();      // Find White Signal 2
        rend3 = GameObject.Find("signal3").GetComponent<Renderer>();      // Find White Signal 3
        rend4 = GameObject.Find("signal4").GetComponent<Renderer>();      // Find Yellow Signal 1
        rend5 = GameObject.Find("signal5").GetComponent<Renderer>();      // Find Yellow Signal 2
        rend6 = GameObject.Find("signal6").GetComponent<Renderer>();      // Find Yellow Signal 3

        rend1.enabled = true;                      //White Signal 1 Renderer enabled
        rend1.sharedMaterial = material[1];        //Material 1 is Green - Material 0 is Red
        rend2.enabled = true;                      //White Signal 2 Renderer enabled
        rend2.sharedMaterial = material[1];        //Material 1 is Green - Material 0 is Red
        rend3.enabled = true;                      //White Signal 3 Renderer enabled
        rend3.sharedMaterial = material[1];        //Material 1 is Green - Material 0 is Red
        rend4.enabled = true;                      //Yellow Signal 1 Renderer enabled
        rend4.sharedMaterial = material[0];        //Material 1 is Green - Material 0 is Red
        rend5.enabled = true;                      //Yellow Signal 2 Renderer enabled
        rend5.sharedMaterial = material[0];        //Material 1 is Green - Material 0 is Red
        rend6.enabled = true;                      //Yellow Signal 3 Renderer enabled
        rend6.sharedMaterial = material[0];        //Material 1 is Green - Material 0 is Red
    }

    IEnumerator Signal1()
    {
        yield return new WaitForSeconds(2.00f);
        rend1.sharedMaterial = material[0];
        rend2.sharedMaterial = material[0];
        rend3.sharedMaterial = material[0];
        rend4.sharedMaterial = material[1];
        rend5.sharedMaterial = material[1];
        rend6.sharedMaterial = material[1];
    }
    IEnumerator Signal2()
    {
        yield return new WaitForSeconds(3.00f);
        rend1.sharedMaterial = material[1];
        rend2.sharedMaterial = material[1];
        rend3.sharedMaterial = material[1];
        rend4.sharedMaterial = material[0];
        rend5.sharedMaterial = material[0];
        rend6.sharedMaterial = material[0];
    }


    /// If Click On Arms Box Colliders, Play Pneumatic Arms Animations and Audios.
	void Update()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);      // Ray for detect different colliders
        RaycastHit hit;

        if (Input.GetMouseButtonDown(0))   // Detect Left Mouse Click
        {
            if (Physics.Raycast(ray, out hit))
            {
                if (hit.transform.name == "Pneumatic Arm Yellow")
                {
                    if (this.anim.GetCurrentAnimatorStateInfo(0).IsName("Idle"))    // If Yellow Arm Animator State is Idle
                    {
                        yellowArm.GetComponent<Animator>().Play("YellowPneumaticArmAction1");  // Play PneumaticAnimation 1
                        robotAudio.PlayOneShot(robotarm1, 1.0F);                               // Play Yellow Arm Sound 1
                        emergencyLights.GetComponent<Animator>().Play("EmergencySignal");

                    }

                    if (this.anim.GetCurrentAnimatorStateInfo(0).IsName("YellowPneumaticArmAction1"))    // If Yellow Arm Animator State is; PneumaticAnimation 1 is Played
                    {
                        yellowArm.GetComponent<Animator>().Play("YellowPneumaticArmAction2");            // Play Yellow Arm PneumaticAnimation 2
                        robotAudio.PlayOneShot(robotarm3, 1.0F);                                         // Play Yellow Arm Sound 2
                        StartCoroutine("Signal1");

                    }

                    if (this.anim2.GetCurrentAnimatorStateInfo(0).IsName("Finish"))     // If White Arm Animator State is; Finish
                    {

                        yellowArm.GetComponent<Animator>().Play("YellowPneumaticArmAction3");   // Play Yellow Arm PneumaticAnimation 3
                        robotAudio.PlayOneShot(robotarm4, 1.0F);                                // Play Yellow Arm Sound 3
                        whiteArm.GetComponent<Animator>().Play("Stop");                         // Set White Arm State is Stop
                     
                    }

                    if (this.anim.GetCurrentAnimatorStateInfo(0).IsName("YellowPneumaticArmAction3"))   // If Animator State is; PneumaticAnimation 1 is Played
                    {
                        yellowArm.GetComponent<Animator>().Play("YellowPneumaticArmAction4");           // Play Yellow Arm PneumaticAnimation 4
                        robotAudio.PlayOneShot(robotarm1, 1.0F);                                        // Play Yellow Arm Sound 1
                    }

                    if (this.anim.GetCurrentAnimatorStateInfo(0).IsName("YellowPneumaticArmAction4"))    // If Yellow Arm Animator State is
                    {
                        yellowArm.GetComponent<Animator>().Play("YellowPneumaticArmAction5"); 
                        robotAudio.PlayOneShot(robotarm3, 1.0F);
                        StartCoroutine("Signal1");
                    }

                    if (this.anim2.GetCurrentAnimatorStateInfo(0).IsName("Finish2"))
                    {
                        yellowArm.GetComponent<Animator>().Play("YellowPneumaticArmAction6");
                        robotAudio.PlayOneShot(robotarm4, 1.0F);
                        whiteArm.GetComponent<Animator>().Play("Stop");
                    }

                    if (this.anim.GetCurrentAnimatorStateInfo(0).IsName("YellowPneumaticArmAction6"))
                    {
                        whiteArm.GetComponent<Animator>().Play("Stop");
                    }
                }

                if (hit.transform.name == "Pneumatic Arm White")
                {
                    if (this.anim.GetCurrentAnimatorStateInfo(0).IsName("Barrel1"))
                    {
                        yellowArm.GetComponent<Animator>().Play("StopYellow");  // Play Animation
                        whiteArm.GetComponent<Animator>().Play("WhitePneumaticArmAction1");  // Play Animation
                        robotAudio2.PlayOneShot(robotarm2, 1.0F);          // Play Sound
                        StartCoroutine("Signal2");

                    }

                    if (this.anim.GetCurrentAnimatorStateInfo(0).IsName("Barrel2"))
                    {
                        yellowArm.GetComponent<Animator>().Play("StopYellow2");  // Play Animation
                        whiteArm.GetComponent<Animator>().Play("WhitePneumaticArmAction2");  // Play Animation
                        robotAudio2.PlayOneShot(robotarm2, 1.0F);          // Play Sound
                        StartCoroutine("Signal2");
                    }

                    //    else if (this.anim.GetCurrentAnimatorStateInfo(0).IsName("Finish"))
                    //    {
                    //        whiteArm.GetComponent<Animator>().Play("Stop");
                    //    }

                }

            }

        }

    }
}