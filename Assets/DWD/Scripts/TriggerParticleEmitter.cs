//© Dicewrench Designs LLC 2024
//All Rights Reserved
//Last Owned by: Allen White (allen@dicewrenchdesigns.com)

using UnityEngine;

/// <summary>
/// A <see cref="MonoBehaviour"/> that allows you to Emit
/// <see cref="ParticleSystem"/>s when a collision is detected
/// by the <see cref="TriggerTopCollisions"/> class.  
/// </summary>
/// 
namespace SpaciousPlaces
{
    public class TriggerParticleEmitter : MonoBehaviour
    {
        [Header("Particle Settings")]
        [SerializeField]
        private ParticleSystem _targetParticle;

        [SerializeField]
        private EmissionSource _particleEmissionSource;

        [Space]


        [SerializeField]
        private int _minParticlesToSpawn;
        [SerializeField]
        private int _maxParticlesToSpawn;

        private int EmissionCount { get { return UnityEngine.Random.Range(_minParticlesToSpawn, _maxParticlesToSpawn); } }

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

        private enum EmissionSource
        {
            Root,
            Collision
        }

        //working params to avoid garbage
        private ParticleSystem.EmitParams _emitterParams;

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
                switch (_particleEmissionSource)
                {
                    case EmissionSource.Root:
                        _emitterParams.position = Vector3.zero;
                        break;
                    case EmissionSource.Collision:
                        _emitterParams.position = other.ClosestPoint(transform.position) - _targetParticle.transform.position;
                        break;
                }

                _targetParticle.Emit(_emitterParams, EmissionCount);
            }
        }
    }
}
