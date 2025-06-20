using SpaciousPlaces;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoodInit : MonoBehaviour
{
    public static MoodInit Instance;
    [SerializeField]private MoodRegistrationPanel MoodRegistrationPanel;

    private void Awake() {
        if(Instance == null)
        {
            Instance = this;
        }
    }

    public MoodRegistrationPanel GetMoodRegistrationPanel()
    {
        if(MoodRegistrationPanel == null)
        {
            MoodRegistrationPanel = FindObjectOfType<MoodRegistrationPanel>();
        }
        return MoodRegistrationPanel;
    }
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
