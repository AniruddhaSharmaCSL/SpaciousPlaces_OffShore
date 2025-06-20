using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace SpaciousPlaces
{
    [CreateAssetMenu(fileName = "New EventRelay", menuName = "ScriptableObjects/Events/Event Relay")]
    public class EventRelay : ScriptableObject
    {
        protected readonly List<UnityAction> listeners = new List<UnityAction>();

        public virtual void Raise()
        {
            for (int i = listeners.Count - 1; i >= 0; i--)
            {
                if (listeners[i] == null)
                {
                    listeners.RemoveAt(i);
                    continue;
                }

                listeners[i].Invoke();
            }
        }

        public virtual void Add(UnityAction listener)
        {
            if (!listeners.Contains(listener))
            {
                listeners.Add(listener);
            }
        }

        public virtual void Remove(UnityAction listener)
        {
            if (listeners.Contains(listener))
            {
                listeners.Remove(listener);
            }
        }
    }
}