using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Trigger : MonoBehaviour
{

    public float hitForce = 2f; // Modify this to control how much the drum moves

    private Vector3 originalPosition;
    private AudioSource audioSource;

    void Start()
    {
        // Get the AudioSource component attached to the object
        audioSource = GetComponent<AudioSource>();

        originalPosition = transform.localPosition;

        Debug.Log("Trigger Script Started");
    }

    void OnCollisionEnter(Collision collision)
    {
        Debug.Log("Conga collision occured");
        Debug.Log("Tag: " + collision.gameObject.tag);
        if(audioSource != null)
            audioSource.Play();
        
        // Check if the colliding object is the OVRHand (you might need a specific tag or identifier)
        if (collision.gameObject.name.Contains("Hand"))
        {
            // Play the sound
            //audioSource.Play();
            // Calculate velocity
            float velocity = collision.relativeVelocity.magnitude;

            // Play sound with volume based on velocity
            if (audioSource != null)
            {
                audioSource.volume = Mathf.Clamp(velocity / 10, 0, 1);
                audioSource.Play();
            }
            
       // Move drum slightly. Since you're moving the entire GameObject, use transform.
            StartCoroutine(MoveDrum());
            
            // Optionally adjust pitch based on Koreographer or other methods here

            // Flash effect
            // Implement shader or material change for flash effect
            
            // Reset drum position after a delay
            Invoke(nameof(ResetDrumPosition), 0.2f); // Adjust time as needed
        }

   IEnumerator MoveDrum()
    {
        float moveDuration = 0.2f; // Total duration for the down and up movement
        float elapsedTime = 0;

        Vector3 downPosition = originalPosition + Vector3.down * hitForce;

        // Move down
        while (elapsedTime < moveDuration / 2)
        {
            transform.localPosition = Vector3.Lerp(originalPosition, downPosition, (elapsedTime / (moveDuration / 2)));
            elapsedTime += Time.deltaTime;
            yield return null;
        }

        // Reset elapsedTime for the movement back up
        elapsedTime = 0;

        // Move up
        while (elapsedTime < moveDuration / 2)
        {
            transform.localPosition = Vector3.Lerp(downPosition, originalPosition, (elapsedTime / (moveDuration / 2)));
            elapsedTime += Time.deltaTime;
            yield return null;
        }

        // Ensure the drum is exactly at the original position
        transform.localPosition = originalPosition;
    }

        void ResetDrumPosition()
        {
           transform.localPosition = originalPosition;
        }
    }
}