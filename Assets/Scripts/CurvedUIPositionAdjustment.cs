using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CurvedUIPositionAdjustment : MonoBehaviour
{
    [SerializeField] private GameObject curvedUIMesh;

    private float startingZPosition;
    private bool positionAdjusted = false;

    private void Start() 
    {
        startingZPosition = gameObject.transform.localPosition.z;
    }

    void Update()
    {
        // Adjust z position to compensate for CurvedUI 
        if (!positionAdjusted && gameObject.transform.localPosition.z != startingZPosition - curvedUIMesh.transform.localPosition.z)
        {
            gameObject.transform.localPosition = 
            new Vector3(gameObject.transform.localPosition.x, gameObject.transform.localPosition.y, startingZPosition - curvedUIMesh.transform.localPosition.z);
            positionAdjusted = true;
        }
    }
}
