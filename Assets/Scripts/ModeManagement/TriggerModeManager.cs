using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace SpaciousPlaces
{
    public class TriggerModeManager : MonoBehaviour
    {
        private Fingertip[] fingertips;

        [SerializeField]
        private List<InstrumentCollision> TriggerTopCollisions;

        [SerializeField]
        private List<CapsuleCollider> FullHandCapsuleColliders;

        [SerializeField]
        private List<CapsuleCollider> ControllerCapsuleColliders;

        [SerializeField]
        private List<GameObject> Mallets;

        // TEMP/dev, also must enable DrumHand in "[BuildingBlock] Hand Tracking Left/Right"
        [SerializeField]
        private bool EnableFingertips = false;

        private bool isHandTrackingEnabled;

        private enum HandTrackingMode
        {
            FingerTipColliders,
            FingerTipRays,
            SingleCapsuleCollider,
        }

        private HandTrackingMode handTrackingMode = HandTrackingMode.SingleCapsuleCollider;

        IEnumerator Start()
        {
            if (EnableFingertips)
            {
                yield return new WaitForSeconds(3); // delay to allow for the hand to be fully initialized TODO: progress bar
                fingertips = FindObjectsOfType<Fingertip>(true);
            }

            isHandTrackingEnabled = OVRPlugin.GetHandTrackingEnabled();

            UpdateVisualsAndColliders();
        }

        private void Update()
        {
            if (isHandTrackingEnabled != OVRPlugin.GetHandTrackingEnabled())
            {
                UpdateVisualsAndColliders();
            }
        }

        public void EnableFingertipColliders()
        {
            if (fingertips == null || !EnableFingertips)
            {
                return;
            }

            handTrackingMode = HandTrackingMode.FingerTipColliders;

            foreach (var fingertip in fingertips)
            {
                fingertip.gameObject.SetActive(true);
                fingertip.enableRaycast = false;
            }

            foreach (var triggerTopCollision in TriggerTopCollisions)
            {
                triggerTopCollision.enableRaycast = false;
                triggerTopCollision.ResetColliders();
            }

            foreach (var capsuleCollider in FullHandCapsuleColliders)
            {
                capsuleCollider.enabled = false;
            }

            foreach (var capsuleCollider in ControllerCapsuleColliders)
            {
                capsuleCollider.gameObject.SetActive(false);
            }

            foreach (var mallet in Mallets)
            {
                mallet.SetActive(false);
            }
        }

        public void EnableFingertipRays()
        {
            if (!EnableFingertips)
            {
                return;
            }

            handTrackingMode = HandTrackingMode.FingerTipRays;

            foreach (var fingertip in fingertips)
            {
                fingertip.gameObject.SetActive(true);
                fingertip.enableRaycast = true;
            }

            foreach (var triggerTopCollision in TriggerTopCollisions)
            {
                triggerTopCollision.enableRaycast = true;
                triggerTopCollision.ResetColliders();
            }

            foreach (var capsuleCollider in FullHandCapsuleColliders)
            {
                capsuleCollider.enabled = false;
            }

            foreach (var capsuleCollider in ControllerCapsuleColliders)
            {
                capsuleCollider.gameObject.SetActive(false);
            }

            foreach (var mallet in Mallets)
            {
                mallet.SetActive(false);
            }
        }

        public void EnableSingleCapsuleCollider()
        {
            handTrackingMode = HandTrackingMode.SingleCapsuleCollider;

            EnableFingertipsGameObjects(false);

            foreach (var triggerTopCollision in TriggerTopCollisions)
            {
                triggerTopCollision.enableRaycast = false;
                triggerTopCollision.ResetColliders();
            }

            foreach (var capsuleCollider in FullHandCapsuleColliders)
            {
                capsuleCollider.enabled = true;
            }

            foreach (var capsuleCollider in ControllerCapsuleColliders)
            {
                capsuleCollider.gameObject.SetActive(false);
            }

            foreach (var mallet in Mallets)
            {
                mallet.SetActive(false);
            }
        }

        public void EnableControllerColliders()
        {
            EnableFingertipsGameObjects(false);

            foreach (var triggerTopCollision in TriggerTopCollisions)
            {
                triggerTopCollision.enableRaycast = false;
                triggerTopCollision.ResetColliders();
            }

            foreach (var capsuleCollider in FullHandCapsuleColliders)
            {
                capsuleCollider.enabled = false;
            }

            foreach (var capsuleCollider in ControllerCapsuleColliders)
            {
                capsuleCollider.gameObject.SetActive(true);
            }

            foreach (var mallet in Mallets)
            {
                mallet.SetActive(true);
            }
        }

        private void EnableFingertipsGameObjects(bool enable)
        {
            if (fingertips != null)
            {
                foreach (var fingertip in fingertips)
                {
                    fingertip.gameObject.SetActive(enable);
                }
            }
        }

        private void UpdateVisualsAndColliders()
        {
            isHandTrackingEnabled = OVRPlugin.GetHandTrackingEnabled();

            if (!isHandTrackingEnabled)
            {
                EnableControllerColliders();
            }
            else
            {
                switch (handTrackingMode)
                {
                    case HandTrackingMode.FingerTipColliders:
                        EnableFingertipColliders();
                        break;
                    case HandTrackingMode.FingerTipRays:
                        EnableFingertipRays();
                        break;
                    case HandTrackingMode.SingleCapsuleCollider:
                        EnableSingleCapsuleCollider();
                        break;
                }
            }
        }
    }
}
