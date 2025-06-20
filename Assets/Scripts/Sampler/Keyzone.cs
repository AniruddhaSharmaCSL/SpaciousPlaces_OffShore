using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using LazySquirrelLabs.MinMaxRangeAttribute;
using Sirenix.OdinInspector;
using UnityEditor;
using System.Linq;

namespace SpaciousPlaces
{
    [CreateAssetMenu(menuName = "Instrument/Keyzone")]
    public class Keyzone : MonoBehaviour
    {
        [Title("Audio Settings")]
        [HorizontalGroup("Audio", LabelWidth = 100)]
        [PreviewField(Height = 50), HideLabel]
        [SerializeField] private AudioClip audioClip;
        public AudioClip AudioClip => audioClip;

        [ShowInInspector, ReadOnly, LabelText("Audio File Name")]
        [HorizontalGroup("Audio")]
        public string AudioFileName => audioClip != null ? audioClip.name : "None";

        [VerticalGroup("Audio")]
        [SerializeField, LabelText("Mixer Group")]
        private AudioMixerGroup mixer;
        public AudioMixerGroup Mixer => mixer;

        [Title("Note Range")]
        [HorizontalGroup("Notes")]
        [LabelWidth(80)]
        [SerializeField, LabelText("Root Note")]
        private MusicalNote rootNote;
        public MusicalNote RootNote => rootNote;

        [SerializeField, LabelText("Min Note")]
        public MusicalNote MinNote;

        [SerializeField, LabelText("Max Note")]
        public MusicalNote MaxNote;

        [Title("Collision Settings")]
        [SerializeField] private string colliderGUID;
        [SerializeField] private string colliderScenePath;

        [InlineEditor(Expanded = true)]
        [SerializeField] public InstrumentCollision Collider;
       // public InstrumentCollision Collider => collider;

        [Title("Velocity Range")]
        [HorizontalGroup("Velocity"), LabelWidth(50)]
        [Range(0, 127), SerializeField, LabelText("Min")]
        private int minVelocity = 0;
        public int MinVelocity => minVelocity;

        [Range(0, 127), SerializeField, LabelText("Max")]
        private int maxVelocity = 127;
        public int MaxVelocity => maxVelocity;

        [Title("Koreo Midi Settings")]
        [SerializeField, LabelText("Koreo MIDI Event ID")]
        private string koreMidiNoteEventId = "MidiChords";
        public string KoreMidiNoteEventId => koreMidiNoteEventId;

        [Title("Additional Settings")]
        [SerializeField, LabelText("Round Robin Order")]
        private int roundRobinOrder;
        public int RoundRobinOrder => roundRobinOrder;

        [Title("Additional Settings")]
        [SerializeField, LabelText("Articulation")]
        private string articulation;
        public string Articulation => articulation;

#if UNITY_EDITOR
        // Editor-only setup method
        public void EditorSetup(
            InstrumentCollision collider,
            AudioClip clip,
            MusicalNote root,
            MusicalNote min,
            MusicalNote max,
            int minVel,
            int maxVel,
            int roundRobin,
            AudioMixerGroup mixerGroup = null,
            string articulation = "")
        {
            this.Collider = collider;
            this.audioClip = clip;
            this.rootNote = root;
            this.MinNote = min;
            this.MaxNote = max;
            this.minVelocity = minVel;
            this.maxVelocity = maxVel;
            this.roundRobinOrder = roundRobin;
            this.mixer = mixerGroup;
            this.articulation = articulation;
        }
#endif

        /// <summary>
        /// Checks if this keyzone is valid for the specified MIDI note and optionally ignores the octave.
        /// </summary>
        public bool ValidForNote(int midiNote, bool octaveAgnostic = false)
        {
            if (!octaveAgnostic)
            {
                return midiNote >= MinNote.ToMidiNoteNumber() && midiNote <= MaxNote.ToMidiNoteNumber()
                    && audioClip != null;
            }

            int noteInOctave = midiNote % 12;
            int minNoteInOctave = MinNote.ToMidiNoteNumber() % 12;
            int maxNoteInOctave = MaxNote.ToMidiNoteNumber() % 12;

            if (maxNoteInOctave >= minNoteInOctave)
            {
                return noteInOctave >= minNoteInOctave && noteInOctave <= maxNoteInOctave
                    && audioClip != null;
            }
            else
            {
                return (noteInOctave >= minNoteInOctave || noteInOctave <= maxNoteInOctave)
                    && audioClip != null;
            }
        }

        /// <summary>
        /// Checks if this keyzone is valid for a given note and velocity.
        /// </summary>
        public bool ValidForNote(int note, int velocity)
        {
            return ValidForNote(note) && velocity >= minVelocity && velocity <= maxVelocity;
        }

    }
}