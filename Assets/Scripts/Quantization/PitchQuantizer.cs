using UnityEngine;
using SonicBloom.Koreo;
using System;
using System.Collections.Generic;
using System.Linq;

namespace SpaciousPlaces
{
    public class PitchQuantizer : MonoBehaviour
    {
        /// <summary>
        /// Koreo event id to listen for acceptable notes.
        /// </summary>
        private String koreoEventId = "MidiChords";

        /// <summary>
        /// Base note of the sample
        /// </summary>
        private MusicalNote baseNote;

        /// <summary>
        /// Minimum note of the sample
        /// </summary>
        private MusicalNote minNote;

        /// <summary>
        /// Maximum note of the sample
        /// </summary>
        private MusicalNote maxNote;

        /// <summary>
        /// If note should be quantized to the nearest lower or nearest higher note in the scale
        /// </summary>
        bool favorAscending = false;

        public bool ShowDebug = false;


        public int closestNote = 0;
        // fallback note?

        private float quantizedAudioSourcePitch = 1.0f;
        private Koreography koreography;
        private string notesString = "";

        public void Initialize(MusicalNote rootNote, MusicalNote minNote, MusicalNote maxNote, string koreoEventId)
        {
            this.baseNote = rootNote;
            this.minNote = minNote;
            this.maxNote = maxNote;

            this.koreoEventId = koreoEventId;
            closestNote = rootNote;
        }

        private void Start()
        {
            Koreographer.Instance.RegisterForEvents(koreoEventId, onPitchEvent);
        }

        private void onPitchEvent(KoreographyEvent evt)
        {
            if (minNote == null || maxNote == null || baseNote == null)
            {
                Debug.Log("No notes set for quantization");
                return;
            }

            int[] notes = evt.GetMIDIChordValues();

            notesString = PitchQuantizer.GetScaleDebugText(notes);

            // Debug.Log(gameObject.name + " Pitches: " + notesString + " sampleTime: " + evt.StartSample);

            int baseNoteInt = baseNote.ToMidiNoteNumber();
            int minNoteInt = minNote.ToMidiNoteNumber();
            int maxNoteInt = maxNote.ToMidiNoteNumber();

            closestNote = QuantizeToScale(baseNoteInt,
                notes,
                favorAscending,
                minNoteInt,
                maxNoteInt);



            //Debug.Log(gameObject.name + " closest note: " + closestNote + " " + MidiNoteConverter.MidiNoteToString(closestNote));

            quantizedAudioSourcePitch = MidiChangeToRatio(closestNote, baseNote.ToMidiNoteNumber());
        }

        private static int QuantizeToScale(int midiNote, int[] scale, bool favorAscending, int minNote, int maxNote)
        {
            // Build the scale for all MIDI note octaves
            var fullScale = new List<int>();

            // Generate notes for all MIDI octaves (0-127)
            for (int octave = 0; octave <= 10; octave++)  // Goes to octave 10 to include the last few notes of MIDI range
            {
                int octaveBase = octave * 12;
                foreach (int note in scale)
                {
                    int fullNote = octaveBase + (note % 12);
                    if (fullNote <= 127)  // Ensure we don't exceed MIDI range
                    {
                        fullScale.Add(fullNote);
                    }
                }
            }

            // Sort the scale
            fullScale.Sort();

            // Filter to notes within the specified range
            var candidatesInRange = fullScale.Where(note => note >= minNote && note <= maxNote).ToList();

            // If no notes were found in the range, return -1
            if (!candidatesInRange.Any())
            {
                //Debug.Log($"No notes found within range [{minNote}, {maxNote}] for note {midiNote} in scale: {string.Join(", ", fullScale)}" );
                return -1;
            }

            // Find the closest note
            var candidates = candidatesInRange
                .OrderBy(note => Math.Abs(note - midiNote))
                .ThenBy(note => favorAscending ? note : -note)
                .ToArray();

            int quantizedNote = candidates.First();

            // Debug messages
            /*  Debug.Log($"Original Note: {midiNote} Quantized Note: {quantizedNote}");
              Debug.Log($"Full Scale across all octaves: {string.Join(", ", fullScale)}");
              Debug.Log($"Candidates in range: {string.Join(", ", candidatesInRange)}");
              Debug.Log($"Search Range: [{minNote}, {maxNote}]");*/

            return quantizedNote;
        }

        public float GetQuantizedPitch()
        {
            return quantizedAudioSourcePitch;
        }

        public string GetNotesString()
        {
            return notesString;
        }

        public static int[] ExpandScaleAcrossOctaves(int[] oneOctaveScale)
        {
            // Create an array to store all MIDI notes that fit within 0-127
            int[] fullScale = new int[128];
            int index = 0;

            // Replicate the one-octave scale across multiple octaves (0 to 127 MIDI range)
            for (int octave = 0; octave <= 10; octave++)
            {
                foreach (int note in oneOctaveScale)
                {
                    int midiNote = note + (octave * 12);
                    if (midiNote <= 127)
                    {
                        fullScale[index++] = midiNote;
                    }
                }
            }

            // Resize the array to remove any unused elements
            Array.Resize(ref fullScale, index);
            return fullScale;
        }

        /// <summary>
        /// Takes two midi notes returns the ratio of the frequencies.
        /// </summary>
        /// <returns>The ratio of the two notes.</returns>
        public static float MidiChangeToRatio(int note1, int note2)
        {
            int midiNoteDifference = note1 - note2;
            return Mathf.Pow(2, (1.0f * midiNoteDifference) / 12);
        }

        public static string GetScaleDebugText(int[] notes)
        {
            string notesString = "";

            for (int i = 0; i < notes.Length; i++)
            {
                notesString += MidiNoteConverter.MidiNoteToString(notes[i]) + ",";
            }

            return notesString;
        }
    }
}

