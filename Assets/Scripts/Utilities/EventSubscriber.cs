using System.Collections;
using System.Collections.Generic;
using SonicBloom.Koreo;
using UnityEngine;

public class EventSubscriber : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Koreographer.Instance.RegisterForEvents("Quarter", FireEventDebugLog);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    void FireEventDebugLog(KoreographyEvent koreoEvent)
    {
        Debug.Log("Koreography Event Fired: " + koreoEvent.ToString());

        if (koreoEvent.Payload != null)
        {
            Debug.Log("payload: " + koreoEvent.Payload.ToString());
        }
    }
}
