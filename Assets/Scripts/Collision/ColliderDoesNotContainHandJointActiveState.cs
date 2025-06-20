

using Oculus.Interaction.Input;
using UnityEngine;
using UnityEngine.Assertions;

namespace Oculus.Interaction.PoseDetection
{
    /// <summary>
    /// Test if hand joint is not inside generic collider and updates its active state
    /// based on that test. We could trigger-based testing, but if the hand disappears
    /// during one frame, we will not get a trigger exit event (which means we require
    /// manual testing in Update anyway to accomodate that edge case).
    /// </summary>
    public class ColliderDoesNotContainHandJointActiveState : MonoBehaviour, IActiveState
    {
        [SerializeField, Interface(typeof(IHand))]
        private UnityEngine.Object _hand;
        private IHand Hand;

        [SerializeField]
        private Collider[] _entryColliders;

        [SerializeField]
        private Collider[] _exitColliders;

        [SerializeField]
        private HandJointId _jointToTest = HandJointId.HandWristRoot;

        public bool Active { get; private set; }

        private bool _active = false;

        protected virtual void Awake()
        {
            Hand = _hand as IHand;
            Active = false;
        }

        protected virtual void Start()
        {
            this.AssertField(Hand, nameof(Hand));
            this.AssertCollectionField(_entryColliders, nameof(_entryColliders));
            this.AssertCollectionField(_exitColliders, nameof(_exitColliders));
        }

        protected virtual void Update()
        {
            if (Hand.GetJointPose(_jointToTest, out Pose jointPose))
            {
                Active = !JointPassesTests(jointPose);
            }
            else
            {
                Active = true;
            }
        }

        private bool JointPassesTests(Pose jointPose)
        {
            bool passesCollisionTest;

            if (_active)
            {
                passesCollisionTest = IsPointWithinColliders(jointPose.position,
                    _exitColliders);
            }
            else
            {
                passesCollisionTest = IsPointWithinColliders(jointPose.position,
                    _entryColliders);
            }

            _active = passesCollisionTest;
            return passesCollisionTest;
        }

        private bool IsPointWithinColliders(Vector3 point, Collider[] colliders)
        {
            foreach (var collider in colliders)
            {
                if (!Collisions.IsPointWithinCollider(point, collider))
                {
                    return false;
                }
            }
            return true;
        }

        #region Inject

        public void InjectAllColliderContainsHandJointActiveState(IHand hand, Collider[] entryColliders,
            Collider[] exitColliders, HandJointId jointToTest)
        {
            InjectHand(hand);
            InjectEntryColliders(entryColliders);
            InjectExitColliders(exitColliders);
            InjectJointToTest(jointToTest);
        }

        public void InjectHand(IHand hand)
        {
            _hand = hand as UnityEngine.Object;
            Hand = hand;
        }

        public void InjectEntryColliders(Collider[] entryColliders)
        {
            _entryColliders = entryColliders;
        }

        public void InjectExitColliders(Collider[] exitColliders)
        {
            _exitColliders = exitColliders;
        }

        public void InjectJointToTest(HandJointId jointToTest)
        {
            _jointToTest = jointToTest;
        }

        #endregion
    }
}
