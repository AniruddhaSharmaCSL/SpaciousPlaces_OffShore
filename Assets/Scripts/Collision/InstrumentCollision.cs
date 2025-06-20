using UnityEngine;
using SonicBloom.Koreo;
using System.Collections;
using Oculus.Haptics;

namespace SpaciousPlaces
{
    [RequireComponent(typeof(BeatQuantizer))]
    public class InstrumentCollision : MonoBehaviour
    {
        private BeatQuantizer beatQuantizer;
        private PitchQuantizer pitchQuantizer;

        private AudioSourcePool audioSourcePool; // OR
        private Sampler sampler;

        private float maxVolume;

        // Tolerance for comparing directions. A smaller number requires a more precise hit.
        [SerializeField]
        private float angleTolerance = 45f;

        [SerializeField]
        private bool onlyTriggerFromTop = true;

        // The first float is the velocity, the second is the normalized volume
        public System.Action<float, float, Collider> OnValidCollisionDetected;
        //public System.Action<float, Collider> OnValidCollisionDetected;

        private Collider lastLeftValidCollider;
        private Collider lastRightValidCollider;
        private Collider lastNonTriggerValidCollider;

        [Header("Haptics")]
        private HapticClip hapticClip;

        [Range(0.0f, 1.0f)]
        private float amplitude = 1.0f;

        [Range(-1.0f, 1.0f)]
        private float frequency = 1.0f;

        // The maximum amplitude of where haptic ampltidue hits 1.0
        [SerializeField]
        [Range(0.0f, 1.0f)]
        private float hapticAmplitudeMax = 0.7f;

        private HapticClipPlayer clipPlayer;

        [Header("Test/Debug")]
        [SerializeField] bool autoPlay = false;
        [SerializeField] public bool enableRaycast = false;

        public int offsetPitch = 0;
        [SerializeField] bool enableNonTriggerColliders = false;
        [SerializeField] bool velocitySensitive = true;

        private bool canProcessCollision = false;

        void Start()
        {
            audioSourcePool = GetComponent<AudioSourcePool>();
            sampler = GetComponentInParent<Sampler>();
            beatQuantizer = GetComponent<BeatQuantizer>();
            beatQuantizer.OnPlay.AddListener(PlayIfNeeded);

            pitchQuantizer = GetComponent<PitchQuantizer>();

            if (audioSourcePool != null) // Audio Prefab max vol get
            {
                AudioSource baseAudioSource = audioSourcePool.BaseAudioSource();

                if (baseAudioSource != null)
                {
                    maxVolume = baseAudioSource.volume;
                }
            }
            else if (sampler != null) // OR sampler max vol get
            {
                AudioSource samplerBaseAudioSource = sampler.gameObject.GetComponent<AudioSource>();

                if (samplerBaseAudioSource != null)
                {
                    maxVolume = samplerBaseAudioSource.volume;
                }
            }

            SetHaptics(hapticClip, frequency, amplitude);

            StartCoroutine(DelayCollisionProcessing());
        }

        public void SetHaptics(HapticClip hapticClip, float frequency, float amplitude)
        {
            if (hapticClip != null)
            {
                this.hapticClip = hapticClip;
                this.frequency = frequency;
                this.amplitude = amplitude;

                clipPlayer = new HapticClipPlayer(hapticClip);
                clipPlayer.amplitude = amplitude;
                clipPlayer.frequencyShift = frequency;
            }
        }

        public void ResetColliders()
        {
            lastLeftValidCollider = null;
            lastRightValidCollider = null;
        }
        private void PlayIfNeeded(KoreographyEvent koreoEvent)
        {
            if (autoPlay)
            {
                if (audioSourcePool != null)
                {
                    var audioSource = audioSourcePool.NextAudioSource();

                    if (pitchQuantizer != null)
                    {
                        audioSource.pitch = pitchQuantizer.GetQuantizedPitch();
                    }

                    audioSource.PlayScheduled(beatQuantizer.NextPlayTime());
                }
                else if (sampler != null)
                {
                    sampler.PlayScheduled(this, 0.7f, beatQuantizer.NextPlayTime());
                }
            }
        }

        private void HitDrum(Collider lastValidCollider, float volume, float vel)
        {
            if (lastValidCollider == null)
            {
                return;
            }

            if (audioSourcePool == null && sampler != null)
            {
                if (beatQuantizer.GetBeatDivision() == BeatDivision.None)
                {
                    sampler.PlayOneShot(this, volume);

                    if (OnValidCollisionDetected != null)
                        OnValidCollisionDetected.Invoke(vel, volume, lastValidCollider);
                    return; //avoid double fire
                }
                else
                {
                    var nextPlayTime = beatQuantizer.NextPlayTime();

                    if (nextPlayTime != -1)
                    {
                        sampler.PlayScheduled(this, volume, nextPlayTime);
                    }
                    else
                    {
                        sampler.PlayOneShot(this, volume);
                    }

                    if (OnValidCollisionDetected != null)
                        OnValidCollisionDetected.Invoke(vel, volume, lastValidCollider);
                    return;
                }
            }
            else
            {
                var audioSource = audioSourcePool.NextAudioSource();

                if (offsetPitch < 0.0f || offsetPitch > 0.0f)
                {
                    audioSource.pitch = Mathf.Pow(2, offsetPitch) / 12;
                }

                if (pitchQuantizer != null)
                {
                    audioSource.pitch = pitchQuantizer.GetQuantizedPitch();
                }

                if (beatQuantizer.GetBeatDivision() == BeatDivision.None)
                {
                    audioSource.PlayOneShot(audioSource.clip, volume);

                    if (OnValidCollisionDetected != null)
                        OnValidCollisionDetected.Invoke(vel, volume, lastValidCollider);
                    return; //avoid double fire
                }
                else
                {
                    var nextPlayTime = beatQuantizer.NextPlayTime();
                    audioSource.volume = volume;

                    if (nextPlayTime != -1)
                    {
                        audioSource.PlayScheduled(nextPlayTime);
                    }
                    else
                    {
                        audioSource.PlayOneShot(audioSource.clip);
                    }

                    if (OnValidCollisionDetected != null)
                        OnValidCollisionDetected.Invoke(vel, volume, lastValidCollider);
                }
            }
        }

        public void TriggerRaycastCollision(Collider other, bool leftHand)
        {
            if (!enableRaycast)
            {
                return;
            }

            VelocityEstimator velocityEstimator = other.gameObject.GetComponent<VelocityEstimator>();

            if (velocityEstimator == null)
            {
                // TEMP: get left velocity estimator
                // JF TODO: figure out a better way to do this
                var greatGreatGrandparent = other.transform.parent.parent.parent.parent;
                velocityEstimator = greatGreatGrandparent.GetComponentInChildren<VelocityEstimator>();
                name = greatGreatGrandparent.gameObject.name;
            }

            if (velocityEstimator != null)
            {
                Vector3 velocity = velocityEstimator.GetVelocityEstimate();

                if (!validateCollisionDirection(velocity))
                {
                    // The hand is not coming from above
                    return;
                }

                /*float angle = Vector3.Angle(validCollisionDirection, velocity);

                // If the angle is within tolerance, we consider it a valid collision
                if (angle > angleTolerance)
                {
                    return;
                }*/

                if (leftHand)
                {
                    if (lastLeftValidCollider)
                    {
                        return;
                    }
                    else
                    {
                        lastLeftValidCollider = other;
                        float volume = processVolume(velocity);
                        float vel = processVelocity(velocity);
                        HitDrum(lastLeftValidCollider, volume, vel);

                        return;
                    }
                }
                // TEMP: right hand using full hand collider
                else if (!leftHand)
                {
                    if (lastRightValidCollider)
                    {
                        return;
                    }
                    else
                    {
                        lastRightValidCollider = other;

                        var volume = processVolume(velocity);
                        var vel = processVelocity(velocity);
                        HitDrum(lastRightValidCollider, volume, vel);

                        return;
                    }
                }
                else
                {
                    // Experimental "drumstick
                    lastLeftValidCollider = other;
                }
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (!enableNonTriggerColliders)
            {
                processCollision(other);
            }
        }


        private void OnTriggerExit(Collider other)
        {
            if (enableNonTriggerColliders)
            {
                return;
            }

            if (other == lastLeftValidCollider)
            {
                lastLeftValidCollider = null;
            }
            if (other == lastRightValidCollider)
            {
                lastRightValidCollider = null;
            }
        }

        private void OnCollisionEnter(Collision collision)
        {
            // TODO separate velocity control for non-velocity sensitive mode
            if (canProcessCollision && enableNonTriggerColliders)
            {
                processCollision(collision.collider);
            }
        }

        private void OnCollisionExit(Collision collision)
        {
            if (enableNonTriggerColliders)
            {
                if (collision.collider == lastNonTriggerValidCollider)
                {
                    lastNonTriggerValidCollider = null;
                }

                if (collision.collider == lastLeftValidCollider)
                {
                    lastLeftValidCollider = null;
                }
                if (collision.collider == lastRightValidCollider)
                {
                    lastRightValidCollider = null;
                }
            }
        }
        private void processCollision(Collider other)
        {
            if (enableRaycast)
            {
                return;
            }

            // Calculate the direction from the collider to this object

            VelocityEstimator velocityEstimator = other.gameObject.GetComponent<VelocityEstimator>();
            var name = other.gameObject.name;

            Vector3 velocity = Vector3.zero;

            if (velocityEstimator != null) // Hand tracking velocity
            {
                velocity = velocityEstimator.GetVelocityEstimate();
            }

            if (name.Contains("Controller")) // Controller velocity
            {
                if (name.Contains("Left"))
                {
                    velocity = OVRInput.GetLocalControllerVelocity(OVRInput.Controller.LTouch);
                }
                else if (name.Contains("Right"))
                {
                    velocity = OVRInput.GetLocalControllerVelocity(OVRInput.Controller.RTouch);
                }
            }

            if (!validateCollisionDirection(velocity) && !enableNonTriggerColliders)
            {
                // The hand is not coming from above
                return;
            }

            if (name.Contains("Left"))
            {
                if (lastLeftValidCollider)
                {
                    return;
                }
                else
                {
                    var volume = processVolume(velocity);
                    var vel = processVelocity(velocity);

                    lastLeftValidCollider = other;
                    HitDrum(lastLeftValidCollider, volume, vel);

                    var controllers = new Oculus.Haptics.Controller[] { Oculus.Haptics.Controller.Left };
                    processHaptics(controllers, volume);

                    return;
                }
            }
            //  right hand using full hand collider
            else if (name.Contains("Right"))
            {
                if (lastRightValidCollider)
                {
                    return;
                }
                else
                {
                    var volume = processVolume(velocity);
                    var vel = processVelocity(velocity);

                    lastRightValidCollider = other;
                    HitDrum(lastRightValidCollider, volume, vel);

                    var controllers = new Oculus.Haptics.Controller[] { Oculus.Haptics.Controller.Right };
                    processHaptics(controllers, volume);

                    return;
                }
            }

            if (enableNonTriggerColliders)
            {
                if (lastNonTriggerValidCollider)
                {
                    return;
                }
                lastNonTriggerValidCollider = other;
                var volume = processVolume(velocity);
                var vel = processVelocity(velocity);

                HitDrum(other, volume, vel);

                var controllers = new Oculus.Haptics.Controller[] { Oculus.Haptics.Controller.Left, Oculus.Haptics.Controller.Right };
                processHaptics(controllers, volume);
            }
        }

        private void processHaptics(Oculus.Haptics.Controller[] controllers, float volume)
        {
            if (clipPlayer != null)
            {
                float amplitude = processHapticAmplitude(volume);
                clipPlayer.amplitude = amplitude;

                foreach (var controller in controllers)
                {
                    clipPlayer.Play(controller);
                }
            }
        }

        private float processVolume(Vector3 velocity)
        {
            float normalizedVolume = velocitySensitive ?
                Mathf.InverseLerp(0, enableRaycast ? 3.0f : 2.0f, velocity.magnitude) :
                0.7f;

            //return velocitySensitive ? Mathf.InverseLerp(0, enableRaycast ? 3.0f : 2.0f, velocity.magnitude) : 0.7f;

            // Clamp the volume to the maximum allowed value
            float clampedVolume = Mathf.Min(normalizedVolume, maxVolume);

            //Debug.Log("clamped volume: " +  clampedVolume + " | base volume: " + normalizedVolume + " | max volume: " + maxVolume);

            return clampedVolume;
        }

        private float processVelocity(Vector3 vel)                                        
        {
            float maxMag = enableRaycast ? 3f : 2f;                                        
            float normalizedVelocity = Mathf.InverseLerp(0f, maxMag, vel.magnitude);

            //Debug.Log("Raw Velocity: " + vel + " | Normalized velocity: " + normalizedVelocity); // + " | base volume: " + normalizedVolume + " | max volume: " + maxVolume);

            return normalizedVelocity;
        }

        private float processHapticAmplitude(float volume)
        {
            return Mathf.InverseLerp(0, hapticAmplitudeMax, volume);
        }

        private IEnumerator DelayCollisionProcessing()
        {
            canProcessCollision = false;

            // TODO progress bar or other visual indicator
            yield return new WaitForSeconds(1.0f);

            // Allow future collisions to be processed after the delay to avoid accidental hits at start
            canProcessCollision = true;
        }

        private bool validateCollisionDirection(Vector3 direction)
        {
            if (onlyTriggerFromTop == false)
            {
                return true;
            }

            return !(direction.y >= 0);
        }
    }
}
