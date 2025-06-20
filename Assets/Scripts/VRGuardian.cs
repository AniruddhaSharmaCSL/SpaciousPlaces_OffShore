using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class VRGuardian : MonoBehaviour
{
    [Header("References")]
    [SerializeField]private Transform cameraRig;
    [SerializeField]private Transform centerEyeAnchorTransform;
    [SerializeField]private GameObject guardRailPrefab;
    [SerializeField]private float radius;
    [SerializeField]private Button recenterButton;
    [SerializeField]private GameObject recenterPopup;
    [SerializeField]private bool useTimeScale = false;

    private Vector3 center = new Vector3(0.624228001f, -0.949000001f, 0.0635861531f);

    private Vector3 resetPos;

    private GameObject guardRail;
    //private Material guardRailMaterial;
    private bool isRecentering = false;
    private Coroutine recenterRoutine;
    private Vector3 offSetVector;

    void Start() {
        guardRail = Instantiate(guardRailPrefab, guardRailPrefab.transform.position, Quaternion.identity);

        SetGuardrailAlpha(0f);

        resetPos = centerEyeAnchorTransform.position;

        recenterButton.onClick.AddListener(RecenterPos);
    }

    private void RecenterPos() {

        Vector3 offset = offSetVector;

        Debug.Log("Recenter Pos: " + offset);

        recenterPopup.SetActive(false);

        if (useTimeScale) {
            Time.timeScale = 1f;
        }

        recenterRoutine = StartCoroutine(SmoothRecenter(offset));
    }

    /*    void Update() {
            Vector2 cameraXZ = new Vector2(centerEyeAnchorTransform.position.x, centerEyeAnchorTransform.position.z);
            Vector2 centerXZ = new Vector2(center.x, center.z);
            float distance = Vector2.Distance(cameraXZ, centerXZ);
            float distanceRatio = Mathf.Clamp01(distance / radius);

            // Update guardrail alpha based on distance
            SetGuardrailAlpha(distanceRatio);

            if (distance > radius && !isOutside) {
                isOutside = true;
            }

            if (isOutside) {
                float force = Mathf.Pow(distanceRatio, 2);

                Vector3 direction = (centerEyeAnchorTransform.position - center);
                direction.y = 0f;

                Vector3 push = -direction.normalized * Time.deltaTime * force * 5f;

                cameraRig.position += new Vector3(push.x, 0f, push.z);

                if (distanceRatio < 0.01f) {
                    isOutside = false;
                }
                isOutside = false;
            }

        }*/

    void Update() {
        Vector2 centerXZ = new Vector2(center.x, center.z);
        Vector2 eyeXZ = new Vector2(centerEyeAnchorTransform.position.x, centerEyeAnchorTransform.position.z);
        Vector2 camRigXZ = new Vector2(cameraRig.position.x, cameraRig.position.z);

        Vector3 distanceCamEye = cameraRig.position - centerEyeAnchorTransform.position;
        float distance = Vector2.Distance(eyeXZ, centerXZ);
        float distanceRatio = Mathf.Clamp01(distance / radius);


        SetGuardrailAlpha(distanceRatio);

        if (distance > radius) {
            //recenterRoutine = StartCoroutine(SmoothRecenter(resetPos + centerEyeAnchorTransform.position));
            Vector3 offsetDirection = resetPos - centerEyeAnchorTransform.position;
            Debug.Log("Distance: " + distance + " Radius: " + radius + " Offset Direction: " + offsetDirection);
            if (!recenterPopup.activeSelf) {
                EnableRecenterPopup(centerEyeAnchorTransform.position + offsetDirection);
            }
        }
        else {
            recenterPopup.SetActive(false);
        }
    }

    private void EnableRecenterPopup(Vector3 offset) {

        if (useTimeScale) {
            Time.timeScale = 0f;
        }

        offSetVector = offset;
        Vector3 newPosition = centerEyeAnchorTransform.position + centerEyeAnchorTransform.forward * 1.3f;

        recenterPopup.transform.position = newPosition;
        recenterPopup.transform.rotation = Quaternion.LookRotation(centerEyeAnchorTransform.forward);


        recenterPopup.SetActive(true);
    }

    IEnumerator SmoothRecenter(Vector3 offset) {
        // = new Vector3(10f, 10f, 10f);

        float duration = 5f;
        float elapsed = 0f;

        Vector3 startPosition = cameraRig.position;
        Vector3 targetPosition = offset;

        while (elapsed < duration) {
            elapsed += Time.deltaTime;
            float t = elapsed / duration;
            float easedT = 1f - Mathf.Pow(1f - t, 3); // Ease-out cubic

            cameraRig.position = Vector3.Lerp(startPosition, targetPosition, easedT);
            yield return null;
        }

        cameraRig.position = targetPosition;
        isRecentering = false;
        recenterRoutine = null;
    }

    void SetGuardrailAlpha(float t) {
        float il = Mathf.InverseLerp(0.6f, 1.0f, t);

        float curvedAlpha = Mathf.Pow(il, 2);

        for (int i = 0; i < guardRail.transform.childCount - 1; i++) {
            var particleSystem = guardRail.transform.GetChild(i).GetComponent<ParticleSystem>();
            if (particleSystem == null) return;

            var mainModule = particleSystem.main;
            Color currentColor = mainModule.startColor.color;

            currentColor.a = curvedAlpha;
            mainModule.startColor = currentColor;
        }
    }
    void OnDrawGizmos() {
        Gizmos.color = Color.green;
        Gizmos.DrawWireSphere(center, radius);
    }
}
