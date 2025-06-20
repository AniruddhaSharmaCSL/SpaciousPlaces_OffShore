using Oculus.Interaction;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionTest : MonoBehaviour
{
    private void Start()
    {
       
    }

    private void OnTriggerEnter(Collider other)
    {
        Debug.Log(gameObject.name + ": Trigger enter: " + other.gameObject.name);
    }

    private void OnCollisionEnter(Collision collision)
    {
        Debug.Log(gameObject.name + ": Collision enter: " + collision.gameObject.name);
    }
}
