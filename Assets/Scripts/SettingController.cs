using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using VRUIP;

public class SettingController : MonoBehaviour
{
    public static SettingController instance;

    [SerializeField] private Button volume;
    [SerializeField] private Button quantization;
    [SerializeField] private GameObject volumePanel;
    [SerializeField] private GameObject quantizationPanel;

    private void Awake() {
        if (instance == null)
            instance = this;
    }
    
    // Start is called before the first frame update
    void Start()
    {
       volume.onClick.AddListener(ToggleVolumePanel);
       quantization.onClick.AddListener(ToggleQuantizationPanel);
    }

    private void ToggleVolumePanel() {
        volumePanel.SetActive(true);
        quantizationPanel.SetActive(false);
        volume.transform.GetChild(2).gameObject.SetActive(true);
        quantization.transform.GetChild(2).gameObject.SetActive(false);
    }
    private void ToggleQuantizationPanel() { 
        volumePanel.SetActive(false);
        quantizationPanel.SetActive(true);
        volume.transform.GetChild(2).gameObject.SetActive(false);
        quantization.transform.GetChild(2).gameObject.SetActive(true);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
