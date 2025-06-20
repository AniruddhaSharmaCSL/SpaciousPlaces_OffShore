using Oculus.Interaction;
using Oculus.Interaction.Input;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Oculus.Haptics;

public class OVRHaptics : MonoBehaviour
{
    public HapticClip hapticClip;

    [Range(0,2.5f)]
    public float duration;
    [Range(0,1f)]
    public float amplitude;
    [Range(0,1f)]
    public float frequency;

    private HapticClipPlayer clipPlayer;

    // Start is called before the first frame update
    void Start()
    {
        clipPlayer = new HapticClipPlayer(hapticClip);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    // This method is called when the drum collides with another object
    private void OnCollisionEnter(Collision collision)
    {
        // Check which controller caused the collision
        // Assuming the collider is attached to the drum and the hands have a tag "Hand"

        // Print the name of the collided GameObject to the log
        Debug.Log("Collided with: " + collision.gameObject.name);

        //if (collision.gameObject.CompareTag("Hand"))
        //{
            // Get the controller that caused the collision
            OVRInput.Controller controller = OVRInput.Controller.None;
            
            if (collision.gameObject.name == "LeftHand")
            {
                controller = OVRInput.Controller.LTouch;
            }
            else if (collision.gameObject.name == "RightHand")
            {
                controller = OVRInput.Controller.RTouch;
            }

            // Trigger the haptic feedback
            TriggerHaptics(controller);
       // }
    }

    public void TriggerHaptics(OVRInput.Controller controller)
    {
        if (hapticClip)
        {
            if(controller == OVRInput.Controller.RTouch)    
            {
                clipPlayer.Play(Oculus.Haptics.Controller.Right);
            }
            else if(controller == OVRInput.Controller.LTouch)
            {
                clipPlayer.Play(Oculus.Haptics.Controller.Left);
            }
        }
    }
        //else
        //StartCoroutine(TriggerHapticsRoutine(controller));
    //}

    public IEnumerator TriggerHapticsRoutine(OVRInput.Controller controller)
    {
        OVRInput.SetControllerVibration(frequency, amplitude, controller);
        yield return new WaitForSeconds(duration);
        OVRInput.SetControllerVibration(0, 0, controller);

    }
}
