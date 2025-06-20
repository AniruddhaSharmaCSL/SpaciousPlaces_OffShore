using Meta.XR.MRUtilityKit;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

namespace SpaciousPlaces
{
    public class DrumHand : MonoBehaviour
    {
        #region Constants
        #endregion

        #region Static Variables

        // All BoneId's we need to check for (fingertips) and their respective hitbox multipliers
        private static Dictionary<OVRSkeleton.BoneId, float> fingertipMultipliers = new Dictionary<OVRSkeleton.BoneId, float>()
        {
            {OVRSkeleton.BoneId.Hand_ThumbTip, 1f },
            {OVRSkeleton.BoneId.Hand_IndexTip, .9f },
            {OVRSkeleton.BoneId.Hand_MiddleTip, 1f },
            {OVRSkeleton.BoneId.Hand_RingTip, .9f },
            {OVRSkeleton.BoneId.Hand_PinkyTip, .75f },
        };

        #endregion

        #region Public Variables

        public bool enableDrum = true;

        #endregion

        #region Private Variables

        // Fingertip Prefab to set in inspector
        [SerializeField] private GameObject fingertipPrefab;

        // OVRHand used for hand scale
        private OVRHand hand;

        // OVRSkeleton used for getting all bones and their transforms
        private OVRSkeleton skeleton;

        // Keeping a list of my fingertips in case I need to access them later
        private List<Fingertip> fingertips;

        #endregion

        #region Unity Methods

        // Start is called before the first frame update
        IEnumerator Start()
        {
            hand = GetComponent<OVRHand>();
            skeleton = GetComponent<OVRSkeleton>();

            // Wait for all bones to be created before attempting to create fingertip colliders. Requires at least one instance of each hand being tracked (must wait for user here)
            while (skeleton.Bones.Count == 0)
            {
                yield return null;
            }

            // Create the fingertip colliders
            fingertips = new List<Fingertip>();
            foreach (var bone in skeleton.Bones)
            {
                Debug.Log("checking fingertip collider to " + bone.Id.ToString());

                // If this bone is a finger tip
                if (fingertipMultipliers.ContainsKey(bone.Id))
                {
                    Debug.Log("applying fingertip collider to " + bone.Id.ToString());
                    GameObject.Instantiate(fingertipPrefab, bone.Transform);
                    // Add a fingertip component to each fingertip and save for later access
                    Fingertip ft = bone.Transform.GetComponentInChildren<Fingertip>();
                    ft.drumHand = this;
                    ft.CalibrateFingertip(bone, hand, fingertipMultipliers[bone.Id]);
                    fingertips.Add(ft);

                }
            }
        }

        // Update is called once per frame
        void Update()
        {

        }

        #endregion
    }
}
