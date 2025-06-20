using Meta.XR.MRUtilityKit;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;


namespace SpaciousPlaces
{
    public class Fingertip : MonoBehaviour
    {
        #region Constants
        private static float xZMultiplier = .018f;
        private static float yMultiplier = 0.015f;

        private static float colliderXOffsetLeft = .012f;
        private static float colliderXOffsetRight = -colliderXOffsetLeft;
        #endregion

        #region Static Variables

        #endregion

        #region Public Variables
        [SerializeField]
        float range = 0.1f;

        [SerializeField]
        public bool enableRaycast = false;

        public DrumHand drumHand = null;

        #endregion

        #region Private Variables

        private OVRBone bone;
        private OVRHand hand;
        private OVRSkeleton.SkeletonType handType;

        private LineRenderer lineRenderer;
        private int raycastLayerMask = 1 << 15;
        private Vector3 direction;
        #endregion


        // Start is called before the first frame update
        void Start()
        {
            lineRenderer = GetComponent<LineRenderer>();
            lineRenderer.positionCount = 2;
        }

        // Update is called once per frame
        void FixedUpdate()
        {
            direction = transform.TransformDirection(IsOnLeftHand() ? 1 : -1, 0, 0);

            if (!enableRaycast || (bone.Id != OVRSkeleton.BoneId.Hand_IndexTip && bone.Id != OVRSkeleton.BoneId.Hand_MiddleTip))
            {
                return;
            }

            lineRenderer.SetPosition(0, transform.position);
            lineRenderer.SetPosition(1, transform.position + (direction * range));

            // Debug.DrawRay(transform.position, direction * range);

            // Check if ray is still in range after a drum hit
            if (!drumHand.enableDrum)
            {
                if (Physics.Raycast(transform.position, direction, out RaycastHit hitCheck, range, raycastLayerMask))
                {
                    return;
                }
                else
                {
                    drumHand.enableDrum = true;
                }
                return;
            }

            if (Physics.Raycast(transform.position, direction, out RaycastHit hit, range, raycastLayerMask))
            {
                InstrumentCollision triggerTopCollisions = hit.collider.transform.parent.GetComponent<InstrumentCollision>();

                if (triggerTopCollisions != null)
                {
                    drumHand.enableDrum = false;
                    triggerTopCollisions.TriggerRaycastCollision(GetComponent<CapsuleCollider>(), IsOnLeftHand());
                }
            }
        }

        public void CalibrateFingertip(OVRBone currBone, OVRHand currHand, float currFingerMultiplier)
        {
            bone = currBone;
            hand = currHand;
            handType = hand.GetComponent<OVRSkeleton>().GetSkeletonType();

            float colliderXOffset = IsOnLeftHand() ? colliderXOffsetLeft : colliderXOffsetRight;

            // Modify properties of collider to reflect the finger's dimensions
            float x = hand.HandScale * xZMultiplier * currFingerMultiplier;
            float y = hand.HandScale * yMultiplier * currFingerMultiplier;
            float z = hand.HandScale * xZMultiplier * currFingerMultiplier;

            Vector3 localScale = new Vector3(x, y, z);
            Vector3 offset = new Vector3(hand.HandScale * colliderXOffset * currFingerMultiplier, 0f, 0f);

            transform.localScale = localScale;
            transform.localPosition = offset;
        }

        public bool IsOnLeftHand()
        {
            return handType == OVRSkeleton.SkeletonType.HandLeft;
            ;
        }

        public bool IsOnRightHand()
        {
            return handType == OVRSkeleton.SkeletonType.HandRight;
        }
    }
}
