using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace SpaciousPlaces
{
    public class FireballManager : MonoBehaviour
    {
        [SerializeField] private Transform _fireballHandTrackingOrigin;
        [SerializeField] private Transform _fireballControllerOrigin;
        [SerializeField] private bool _rightHand = false;
        [SerializeField] private Rigidbody _handRigidBody;

        private ObjectPool _pool;
        VelocityEstimator _velocityEstimator;

        private void Awake()
        {
            _pool = GetComponent<ObjectPool>();
            _velocityEstimator = _handRigidBody.GetComponent<VelocityEstimator>();
        }

        public void SpawnFireball()
        {
            if (_pool == null)
            {
                Debug.Log("Fireball pool is null");
                return;
            }

            GameObject fireball = _pool.GetPooledObject();

            if (fireball != null)
            {
                fireball.transform.parent = transform.parent;

                fireball.SetActive(true);

                ProjectileLauncher launcher = fireball.GetComponent<ProjectileLauncher>();

                if (launcher != null)
                {
                    launcher.FireballOrigin = OVRPlugin.GetHandTrackingEnabled() ? _fireballHandTrackingOrigin : _fireballControllerOrigin;
                    float velocity = _velocityEstimator.GetVelocityEstimate().magnitude;
                    float adjustedVelocity = Mathf.InverseLerp(0f, 4.0f, velocity) * 40f;
                    launcher.MinTravelRate = adjustedVelocity;
                    launcher.MaxTravelRate = adjustedVelocity;
                    launcher.RightHand = OVRPlugin.GetHandTrackingEnabled() ? _rightHand : false;
                    launcher.OnImpactComplete.AddListener(HandleImpact);
                    launcher.QueueFire();
                }
            }
            else
            {
                Debug.Log("Fireball pool empty");
            }
        }

        private void HandleImpact(GameObject fireball)
        {
            ProjectileLauncher launcher = fireball.GetComponent<ProjectileLauncher>();
            if (launcher != null)
            {
                launcher.OnImpactComplete.RemoveListener(HandleImpact);
            }

            fireball.SetActive(false);
        }
    }
}
