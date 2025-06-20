using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HideOnPause : MonoBehaviour
{
    [SerializeField] GameObject[] ObjectsToHide;
    private void OnApplicationPause(bool pause)
    {
        foreach (GameObject obj in ObjectsToHide) 
        {
            obj.SetActive(!pause);
        }
    }

    private void OnApplicationFocus(bool focus)
    {
      foreach (GameObject obj in ObjectsToHide)
      {
           obj.SetActive(focus);
      }
    }
}
