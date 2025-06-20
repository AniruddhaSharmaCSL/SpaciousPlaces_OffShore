using SpaciousPlaces;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InteractorManager : MonoBehaviour
{
    [SerializeField] EventRelay OnIntroStartEvent = null;
    [SerializeField] EventRelay OnIntroCompleteEvent = null;

    [SerializeField] GameObject[] objectToHideOnIntro = new GameObject[0];

    void Awake()
    {
        OnIntroStartEvent.Add(OnIntroStart);
        OnIntroCompleteEvent.Add(OnIntroComplete);
    }

    private void OnDestroy()
    {
        OnIntroStartEvent?.Remove(OnIntroStart);
        OnIntroCompleteEvent?.Remove(OnIntroComplete);
    }
    private void OnIntroStart()
    {
        foreach (var obj in objectToHideOnIntro)
        {
            obj.SetActive(false);
        }
    }

    private void OnIntroComplete()
    {
        foreach (var obj in objectToHideOnIntro)
        {
            obj.SetActive(true);
        }
    }
}
