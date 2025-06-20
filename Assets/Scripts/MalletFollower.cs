using UnityEngine;

public class MalletParticleFollower : MonoBehaviour
{
    [Header("References")]
    [Tooltip("The transform of the mallet's end point where particles should follow.")]
    public Transform malletEnd;

    private void Start()
    {
        // Validate the references
        if (malletEnd == null)
        {
            Debug.LogError("Mallet End is not assigned! Please assign the mallet's end Transform.");
        }
    }

    private void Update()
    {
        if (malletEnd != null)
        {
            // Make the particle system follow the position of the mallet's end
            transform.position = malletEnd.position;

            // Optional: Rotate the particle system to align with the mallet's rotation
            transform.rotation = malletEnd.rotation;
        }
    }
}
