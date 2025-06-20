//© Dicewrench Designs LLC 2024-2025
//All Rights Reserved
//Last Owned by: Allen White (allen@dicewrenchdesigns.com)

using UnityEngine;

/// <summary>
/// A <see cref="MonoBehaviour"/> that allows you to Play a
/// <see cref="ParticleSystem"/> when a collision is detected
/// by the <see cref="TriggerTopCollisions"/> class.  If you don't
/// need to move a <see cref="ParticleSystem"/> or want to easily 
/// Emit nested Child Systems this is the Component to use.
/// </summary>
/// 

namespace SpaciousPlaces
{
    public class TriggerParticlePlayer : MonoBehaviour
    {
        [Header("Particle Settings")]
        [SerializeField]
        private ParticleSystem _targetParticle;

        [Header("Collider Settings")]
        [SerializeField]
        private InstrumentCollision _collisionSource;

        [SerializeField]
        [Tooltip("The minimum relative linear velocity of a detected Collision to play.")]
        private float _minimumVelocity = 0.0f;

        public InstrumentCollision CollisionSource
        {
            get { return _collisionSource; }
            set { _collisionSource = value; }
        }

        private void OnEnable()
        {
            if (_collisionSource == null)
            {
                this.enabled = false;
            }
            else
            {
                _collisionSource.OnValidCollisionDetected += HandleValidCollision;
            }
        }

        private void OnDisable()
        {
            if (_collisionSource != null)
            {
                _collisionSource.OnValidCollisionDetected -= HandleValidCollision;
            }
        }

        private void HandleValidCollision(float velocity, float volume, Collider other)
        {
            if (_targetParticle == null)
                return;

            if (velocity >= _minimumVelocity)
            {
                //if we're still playing go ahead and stop emitting
                //so we can play again if needed
                if (_targetParticle.isPlaying)
                    _targetParticle.Stop(withChildren: true, ParticleSystemStopBehavior.StopEmitting);
                _targetParticle.Play(true);
            }
        }
    }
}
