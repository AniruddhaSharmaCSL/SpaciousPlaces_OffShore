using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireworksManager : MonoBehaviour
{
    [SerializeField] List<GameObject> fireworks;
     
    private readonly float minDistance = 6.0f;  // Minimum distance required from launch position
    //serialized field was being set at runtime, made this private
    //[SerializeField] private float minHeight = 0.1f; // Minimum height required from launch position

    private ParticleSystem fireworksParticleSystem;
    private Vector3 launchPosition;

    private void OnEnable()
    {
        // select random firework
        int randomIndex = Random.Range(0, fireworks.Count);
        GameObject firework = fireworks[randomIndex];
        
        // instantiate firework
        GameObject fireworkInstance = Instantiate(firework, transform.position, Quaternion.identity, transform);
        fireworksParticleSystem = fireworkInstance.GetComponent<ParticleSystem>();
        launchPosition = transform.position;  // Store initial position as launch position
    }

    //the fireball (bomb) part of the firework always plays, this affects the flowery part of the firework
    public void PlayFireworks()
    {
        float distanceFromLaunch = Vector3.Distance(launchPosition, transform.position);
        
        //not using a min height anymore - let them fire anywhere
        //if (transform.position.y > minHeight && distanceFromLaunch >= minDistance)
        //the distance check is not always keeping the firework from exploding into the player
        //may need to put a limit on the size allowed in the particle system in the future

        if (distanceFromLaunch >= minDistance)
        {
            //Debug.Log($"Firework played successfully at distance: {distanceFromLaunch:F2} units");
            fireworksParticleSystem.Play();
        }
        else
        {
            //Debug.Log($"Firework not played - Too close to launch position. Current distance: {distanceFromLaunch:F2}, Required minimum: {minDistance:F2} units");
            //else
             //   Debug.Log($"Firework not played - height {transform.position.y} is below minimum height:{minHeight}f");
        }
    }

    public Color PrimaryFireworksColor()
    {
        return fireworksParticleSystem.main.startColor.color;
    }
}
