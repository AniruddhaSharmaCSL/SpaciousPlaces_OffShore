using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterDemoControls : MonoBehaviour
{
    public TransitionalObject transition;

    bool sciFi = true;

    public void SwitchStyles()
    {
        sciFi = !sciFi;

        if(sciFi)
            transition.TriggerFadeOut();
        else
            transition.TriggerTransition();
    }
}
