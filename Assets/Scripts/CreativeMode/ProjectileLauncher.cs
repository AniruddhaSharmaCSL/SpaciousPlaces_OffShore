
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Events;

namespace SpaciousPlaces
{
    public class ProjectileLauncher : MonoBehaviour
    {
        [Header("Visuals References")]
        [SerializeField]
        private GameObject _projectileViz;
        private Rigidbody _projectileRigidbody = null;
        private Rigidbody ProjectileRigidbody
        {
            get
            {
                if (_projectileRigidbody == null)
                    _projectileRigidbody = GetComponent<Rigidbody>();
                return _projectileRigidbody;
            }
        }

        FireworksManager fireworksManager;

        BeatQuantizationManager beatQuantizationManager;

        [SerializeField]
        private TrailRenderer _trailRenderer;

        [SerializeField]
        private ParticleSystem _impactParticle;

        [SerializeField]
        private ParticleSystem _swirlsParticle;

        [SerializeField]
        private Renderer _rockRenderer;

        [Header("Flight Behaviour")]
        [SerializeField]
        public float MinTravelRate = 4.0f;
        [SerializeField]
        public float MaxTravelRate = 10.0f;

        [SerializeField]
        private float _maxFlightTime = 2.0f;

        [SerializeField]
        private float _fireballUpwardAngle = 20.0f;

        [SerializeField]
        private float _fireballHorizontalAngle = 20.0f;

        [SerializeField]
        private bool _restrictFireballAngle = false;

        [Header("Launch Data")]
        public Transform FireballOrigin;
        public bool RightHand = false;

        private Coroutine _flightRoutine;
        private Vector3 _launchPosition;
        private Vector3 _launchDirection;
        private float _flightTimeRemaining;
        private ProjectileState _projectileState = ProjectileState.None;

        [Header("Events")]
        public UnityEvent<GameObject> OnImpactComplete;

        private enum ProjectileState
        {
            None,
            ReadyToLaunch,
            Flying
        }

        [Header("Quantization")]
        [SerializeField]
        private BeatQuantizer _impactQuantizer;

        [Header("Audio")]
        [SerializeField]
        private AudioSource _fireBallAudioSource;
        [SerializeField]
        private AudioSource _impactAudioSource;

        private void OnEnable()
        {
            beatQuantizationManager = FindObjectOfType<BeatQuantizationManager>();

            fireworksManager = GetComponent<FireworksManager>();
            Color color = fireworksManager.PrimaryFireworksColor();

            ParticleSystem p = _projectileViz.GetComponent<ParticleSystem>();

            var main = p.main;
            main.startColor = color;

            var swirlMain = _swirlsParticle.main;
            swirlMain.startColor = color;

            var colorModule = p.colorOverLifetime;
            colorModule.color = new ParticleSystem.MinMaxGradient(color, Color.clear);

            GetComponent<Renderer>().material.color = fireworksManager.PrimaryFireworksColor();

            _trailRenderer.material.SetColor("_FarColor", color);

            Gradient g = _trailRenderer.colorGradient;
            for (int i = 0; i < g.colorKeys.Length; i++)
            {
                g.colorKeys[i].color = color;
            }
            _rockRenderer.material.SetColor("_RimColor", color);

            _projectileViz.gameObject.SetActive(false);
        }

        public void LaunchProjectile()
        {
            if (_projectileState == ProjectileState.ReadyToLaunch)
            {
                _launchPosition = FireballOrigin.position;

                if (!OVRPlugin.GetHandTrackingEnabled())
                {
                    _launchDirection = FireballOrigin.forward;

                }
                else if (!RightHand)
                {
                    _launchDirection = FireballOrigin.up;
                }
                else
                {
                    _launchDirection = -FireballOrigin.up;
                }

                var projectileTransform = ProjectileRigidbody.transform;
                projectileTransform.position = _launchPosition;

                Quaternion lookRotation = Quaternion.LookRotation(_launchDirection, FireballOrigin.right);

                if (!OVRPlugin.GetHandTrackingEnabled())
                {
                    projectileTransform.rotation = lookRotation;
                }
                else
                {
                    Quaternion upwardlTilt = Quaternion.AngleAxis(RightHand ? -_fireballUpwardAngle : _fireballUpwardAngle, -Vector3.right);
                    Quaternion horizontalTilt = Quaternion.AngleAxis(-_fireballHorizontalAngle, Vector3.up);
                    projectileTransform.rotation = lookRotation * upwardlTilt * horizontalTilt;
                }

                if (!_restrictFireballAngle || projectileTransform.forward.y > 0f)
                {
                    ProjectileRigidbody.transform.position = projectileTransform.position;
                    ProjectileRigidbody.transform.rotation = projectileTransform.rotation;

                    _projectileViz.gameObject.SetActive(true);

                    _projectileState = ProjectileState.Flying;

                    _flightTimeRemaining = _maxFlightTime;
                    _flightRoutine = StartCoroutine(DoFlight());

                    _fireBallAudioSource.PlayOneShot(_fireBallAudioSource.clip, _fireBallAudioSource.volume);

                    _impactQuantizer.StartQuantize();
                }
                else
                {
                    // fireball angle is not within range
                    _projectileViz.gameObject.SetActive(false);
                    _trailRenderer.Clear();
                    _projectileState = ProjectileState.None;
                }
            }
        }

        public void QueueFire()
        {
            _projectileState = ProjectileState.ReadyToLaunch;

            if (!beatQuantizationManager.QuantizeEnabled) // Launch immediately if no quantization
            {
                LaunchProjectile();
            }
        }

        //this is an expensive pattern and not ideal... should have a 
        //more data oriented approach if there are going to be lots of 
        //projectiles
        private IEnumerator DoFlight()
        {
            _trailRenderer.Clear();
            _projectileViz.gameObject.SetActive(true);
            ProjectileRigidbody.WakeUp();
            Physics.autoSyncTransforms = true;

            float travelRate = Random.Range(MinTravelRate, MaxTravelRate);

            //move the thing forward
            while (_flightTimeRemaining > 0)
            {
                float frameTime = Time.deltaTime;
                _flightTimeRemaining -= frameTime;

                Vector3 currentPos = ProjectileRigidbody.position;
                currentPos += ProjectileRigidbody.transform.forward * (travelRate * frameTime);
                ProjectileRigidbody.transform.position = (currentPos);
                Physics.SyncTransforms();

                yield return null;
            }

            // explode if not triggered by collision or quantizer
            if (_projectileState == ProjectileState.Flying)
            {
                fireworksManager.PlayFireworks();
            }
            PlayImpact();
        }

        public void PlayImpact()
        {
            if (_projectileState == ProjectileState.Flying)
            {
                _impactAudioSource.PlayOneShot(_impactAudioSource.clip, _impactAudioSource.volume);

                _impactQuantizer.StopQuantize();

                _impactParticle.transform.position = ProjectileRigidbody.transform.position;
                _impactParticle.transform.rotation = ProjectileRigidbody.transform.rotation;

                _impactParticle.Play(withChildren: true);

                _trailRenderer.Clear();

                _projectileState = ProjectileState.None;
                _projectileViz.gameObject.SetActive(false);

                StartCoroutine(HandlePostImpact(10f));
            }
        }

        private IEnumerator HandlePostImpact(float delay)
        {
            yield return new WaitForSeconds(delay);

            if (OnImpactComplete != null)
                OnImpactComplete.Invoke(gameObject);
        }
    }
}