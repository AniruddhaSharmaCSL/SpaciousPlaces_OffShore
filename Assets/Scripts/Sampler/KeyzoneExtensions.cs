using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace SpaciousPlaces
{
    public static class KeyzoneExtensions
    {
        private static Dictionary<(InstrumentCollision, string), Dictionary<int, int>> colliderMicRoundRobinState =
            new Dictionary<(InstrumentCollision, string), Dictionary<int, int>>();

        public static Keyzone FindClosestKeyzone(string micPosition, List<Keyzone> keyzones, int midiNote, int velocity, InstrumentCollision collider, bool randomRoundRobin = false)
        {
            if (keyzones == null || keyzones.Count == 0)
                return null;

            // First, filter by note range
            var validKeyzones = keyzones.Where(k =>
                midiNote >= k.MinNote.ToMidiNoteNumber() &&
                midiNote <= k.MaxNote.ToMidiNoteNumber())
                .ToList();

            if (validKeyzones.Count == 0)
                return null;

            // Find all keyzones that contain this velocity
            var matchingVelocityKeyzones = validKeyzones.Where(k =>
                velocity >= k.MinVelocity &&
                velocity <= k.MaxVelocity)
                .ToList();

            // If we found keyzones with matching velocity, use those
            if (matchingVelocityKeyzones.Count > 0)
            {
                if (!randomRoundRobin)
                {
                    var stateKey = (collider, micPosition);

                    // Initialize state for this collider/mic position if it doesn't exist
                    if (!colliderMicRoundRobinState.ContainsKey(stateKey))
                    {
                        colliderMicRoundRobinState[stateKey] = new Dictionary<int, int>();
                    }

                    // Group keyzones by their velocity ranges first
                    var velocityGroups = matchingVelocityKeyzones
                        .GroupBy(k => (k.MinVelocity, k.MaxVelocity))
                        .ToList();

                    // Find the specific velocity group this note belongs to
                    var velocityGroup = velocityGroups
                        .First(g => velocity >= g.Key.MinVelocity && velocity <= g.Key.MaxVelocity);

                    int velocityHash = velocityGroup.Key.GetHashCode();

                    // Initialize counter for this velocity layer if needed
                    if (!colliderMicRoundRobinState[stateKey].ContainsKey(velocityHash))
                    {
                        colliderMicRoundRobinState[stateKey][velocityHash] = 0;
                    }

                    // Get current index for this velocity layer
                    int currentIndex = colliderMicRoundRobinState[stateKey][velocityHash];

                    // Get all keyzones in this velocity group and sort by round robin order
                    var orderedKeyzones = velocityGroup.OrderBy(k => k.RoundRobinOrder).ToList();

                    while (currentIndex > orderedKeyzones.Count)
                    {
                        currentIndex--;
                    }

                    // Get the keyzone at the current index
                    var selectedKeyzone = orderedKeyzones[currentIndex];

                    // Debug.Log($"[{micPosition}] selected keyzone: {selectedKeyzone.AudioFileName} for velocity {velocity} at index {currentIndex} of {orderedKeyzones.Count}");

                    // Increment the counter for next time, wrapping around if necessary
                    colliderMicRoundRobinState[stateKey][velocityHash] =
                        (currentIndex + 1) % orderedKeyzones.Count;

                    return selectedKeyzone;
                }
                else
                {
                    int index = UnityEngine.Random.Range(0, matchingVelocityKeyzones.Count);
                    return matchingVelocityKeyzones[index];
                }
            }

            // If no exact velocity match, find the closest velocity layer
            var closestKeyzone = validKeyzones
                .OrderBy(k =>
                {
                    float velMid = (k.MinVelocity + k.MaxVelocity) / 2f;
                    return Mathf.Abs(velMid - velocity);
                })
                .FirstOrDefault();

            return closestKeyzone;
        }

        /// <summary>
        /// Groups keyzones by their round robin order for a specific velocity layer
        /// </summary>
        public static IEnumerable<IGrouping<int, Keyzone>> GroupByRoundRobin(this IEnumerable<Keyzone> keyzones)
        {
            return keyzones.GroupBy(k => k.RoundRobinOrder);
        }

        /// <summary>
        /// Gets all unique velocity ranges from a collection of keyzones
        /// </summary>
        public static IEnumerable<(int min, int max)> GetVelocityRanges(this IEnumerable<Keyzone> keyzones)
        {
            return keyzones
                .Select(k => (k.MinVelocity, k.MaxVelocity))
                .Distinct();
        }

        /// <summary>
        /// Resets the round-robin state for a specific collider.
        /// </summary>
        public static void ResetRoundRobin(InstrumentCollision collider)
        {
            var keysToRemove = colliderMicRoundRobinState.Keys
                .Where(k => k.Item1 == collider)
                .ToList();

            foreach (var key in keysToRemove)
            {
                colliderMicRoundRobinState.Remove(key);
            }
        }

        /// <summary>
        /// Resets all round-robin states.
        /// </summary>
        public static void ResetAllRoundRobins()
        {
            colliderMicRoundRobinState.Clear();
        }
    }
}