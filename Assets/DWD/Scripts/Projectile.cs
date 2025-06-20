//© Dicewrench Designs LLC 2024
//All Rights Reserved
//Last Owned by: Allen White (allen@dicewrenchdesigns.com)

using System.Collections;
using UnityEngine;

//This is a really simple projectile type solution...
//I'd consider pooling this, running it all through DoTween,
//or a top level data oriented manager, etc if I was going
//to carry this all the way to Production


namespace SpaciousPlaces
{
    public class Projectile : MonoBehaviour
    {
        [Header("Visuals References")]
        [SerializeField]
        private ProjectileCollider _projectileViz;
        private Rigidbody _projectileRigidbody = null;
        private Rigidbody ProjectileRigidbody
        {
            get
            {
                if (_projectileRigidbody == null)
                    _projectileRigidbody = _projectileViz.GetComponent<Rigidbody>();
                return _projectileRigidbody;
            }
        }

        [SerializeField]
        private TrailRenderer _trailRenderer;

        [SerializeField]
        private ParticleSystem _impactParticle;

        [Header("Flight Behaviour")]
        [SerializeField]
        private float _travelRate = 4.0f;
        //rate vs. specific flight time is a specific design descision...
        //I'm doing rate for now... -AW

        [SerializeField]
        private float _maxFlightTime = 3.0f;

        [SerializeField]
        private InstrumentCollision _collisionLauncher;


        //Launch Data
        private Coroutine _flightRoutine;
        private Vector3 _launchPosition;
        private Vector3 _launchDirection;
        private float _flightTimeRemaining;
        private void OnEnable()
        {
            _projectileViz.gameObject.SetActive(false);
            if (_collisionLauncher == null)
            {
                this.enabled = false;
            }
            else
            {
                _collisionLauncher.OnValidCollisionDetected += HandleValidCollision;
            }
        }

        private void OnDisable()
        {
            if (_collisionLauncher != null)
            {
                _collisionLauncher.OnValidCollisionDetected -= HandleValidCollision;
            }
        }

        private void HandleValidCollision(float velocity, float volume, Collider other)
        {
            //Debug.Log("Got valid collision with " + collision.collider.name, this);
            _projectileViz.OnCollision += HandleProjectileCollision;
            _launchPosition = _collisionLauncher.transform.position;
            _launchDirection = _collisionLauncher.transform.up;
            _flightTimeRemaining = _maxFlightTime;
            _flightRoutine = StartCoroutine(DoFlight());
        }

        private void HandleProjectileCollision(Collision collision)
        {
            //Debug.Log("Got projectile collision with " + collision.collider.name, this);
            _projectileViz.OnCollision -= HandleProjectileCollision;
            if (_flightRoutine != null)
                StopCoroutine(_flightRoutine);
            PlayImpact();
        }

        //this is an expensive pattern and not ideal... should have a 
        //more data oriented approach if there are going to be lots of 
        //projectiles
        private IEnumerator DoFlight()
        {
            //turn the launcher off
            _collisionLauncher.gameObject.SetActive(false);

            ProjectileRigidbody.transform.position = _launchPosition;
            ProjectileRigidbody.transform.rotation = Quaternion.LookRotation(_launchDirection, _collisionLauncher.transform.right);
            _trailRenderer.Clear();
            _projectileViz.gameObject.SetActive(true);
            ProjectileRigidbody.WakeUp();
            Physics.autoSyncTransforms = true;

            //move the thing forward
            while (_flightTimeRemaining > 0)
            {
                float frameTime = Time.deltaTime;
                _flightTimeRemaining -= frameTime;

                Vector3 currentPos = ProjectileRigidbody.position;
                currentPos += ProjectileRigidbody.transform.forward * (_travelRate * frameTime);
                ProjectileRigidbody.transform.position = (currentPos);
                Physics.SyncTransforms();

                yield return null;
            }

            PlayImpact();
        }

        private void PlayImpact()
        {
            _projectileViz.gameObject.SetActive(false);
            _impactParticle.transform.position = ProjectileRigidbody.transform.position;
            _impactParticle.transform.rotation = ProjectileRigidbody.transform.rotation;

            _impactParticle.Play(withChildren: true);
            _trailRenderer.Clear();
            //turn the launcher back on
            _collisionLauncher.gameObject.SetActive(true);
        }
    }
}
