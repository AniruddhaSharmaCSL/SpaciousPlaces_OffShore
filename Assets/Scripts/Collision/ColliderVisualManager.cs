using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColliderVisualManager : MonoBehaviour
{
    [SerializeField] private List<MeshRenderer> _renderers;

    [SerializeField] private bool showRenderers = false;

    private bool isHandTrackingEnabled;

    private void Start()
    {
        isHandTrackingEnabled = OVRPlugin.GetHandTrackingEnabled();

        UpdateRenderers();
    }

    private void UpdateRenderers()
    {
        if (showRenderers)
        {
            EnableRenderers();
        }
        else
        {
            DisableRenderers();
        }
    }

    private void Update()
    {
        if (isHandTrackingEnabled != OVRPlugin.GetHandTrackingEnabled())
        {
            isHandTrackingEnabled = OVRPlugin.GetHandTrackingEnabled();

            UpdateRenderers();
        }
    }

    public void EnableRenderers()
    {
        showRenderers = true;

        foreach (var renderer in _renderers)
        {
            renderer.enabled = true;
        }
    }

    public void DisableRenderers()
    {
        showRenderers = false;

        foreach (var renderer in _renderers)
        {
            renderer.enabled = false;
        }
    }
}
