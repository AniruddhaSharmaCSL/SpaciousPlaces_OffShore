//© Dicewrench Designs LLC 2024
//All Rights Reserved
//Last Owned by: Allen White (allen@dicewrenchdesigns.com)

using UnityEngine;

[RequireComponent(typeof(Collider))]
public class ProjectileCollider : MonoBehaviour
{
    public System.Action<Collision> OnCollision;

    private Collider _collider;

    public Collider Collider
    {
        get
        {
            if(_collider == null)
                _collider = GetComponent<Collider>();
            return _collider;
        }
    }


    private void OnCollisionEnter(Collision collision)
    {
        Debug.Log("Projectile Collider HIT", this);
        if(OnCollision != null) 
            OnCollision(collision);
    }
}
