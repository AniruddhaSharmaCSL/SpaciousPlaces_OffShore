using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RefreshRate : MonoBehaviour
{
    void Start()
    {
        Unity.XR.Oculus.Performance.TrySetDisplayRefreshRate(80f);
        OVRPlugin.foveatedRenderingLevel = OVRPlugin.FoveatedRenderingLevel.HighTop;
    }
}
