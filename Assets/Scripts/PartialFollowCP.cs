using SpaciousPlaces;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PartialFollowCP : MonoBehaviour
{
    [Header("Position Offset")]
    [SerializeField] private Transform target;
    [SerializeField] private Vector3 xyzOffset;

    [Header("Rotation Offset")]
    [SerializeField] private Vector3 rotationOffset; // New rotation offset

    private void OnEnable() {
        if (SceneLoader.Instance != null)
        {
            target = SceneLoader.Instance.getCenterEyeAnchor();
        }
    }

    private void LateUpdate()
    {
        if (target == null)
        {
            if (SceneLoader.Instance != null)
            {
                target = SceneLoader.Instance.getCenterEyeAnchor();
            }
            return;
        }
        OnlyRotatePanel();
    }

    private void MovePanel()
    {
        // Apply position offset rotated only on Y-axis
        Quaternion yRotationOnly = Quaternion.Euler(0, target.eulerAngles.y, 0);
        Vector3 rotatedOffset = yRotationOnly * xyzOffset;
        transform.position = target.position + rotatedOffset;

        // Apply Y-rotation + rotationOffset
        Quaternion finalRotation = Quaternion.Euler(0, target.eulerAngles.y, 0) * Quaternion.Euler(rotationOffset);
        transform.rotation = finalRotation;
    }

    private void OnlyRotatePanel()
    {
        // Calculate direction to target on the horizontal plane only
        Vector3 direction = target.position - transform.position;
        direction.y = 0f; // ignore vertical difference

        // Only rotate if the direction is not too small
        if (direction.sqrMagnitude > 0.001f)
        {
            Quaternion targetRotation = Quaternion.LookRotation(-direction);
            transform.rotation = targetRotation;
        }
    }
}
