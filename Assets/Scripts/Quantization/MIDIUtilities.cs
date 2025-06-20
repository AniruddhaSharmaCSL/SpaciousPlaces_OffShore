using UnityEngine;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace SpaciousPlaces
{
    public static class MidiConstants
    {
        public const int MIN_MIDI_NOTE = 0;
        public const int MAX_MIDI_NOTE = 127;
        public const int NOTES_PER_OCTAVE = 12;
        public const int MIDI_OCTAVE_OFFSET = 1; // MIDI note 0 is in octave -1
    }

    [Serializable]
    public enum NoteName { A, B, C, D, E, F, G }

    [Serializable]
    public enum Accidental { Natural, Flat, Sharp }

    public static class MidiNoteConverter
    {
        private static readonly Regex NoteRegex = new Regex(@"^([A-G][#b]?)(-?\d+)$", RegexOptions.Compiled);

        public static string MidiNoteToString(int midiNote, bool preferSharps = true)
        {
            if (!IsValidMidiNote(midiNote))
                return "-1";

            var note = new MusicalNote(midiNote);
            return note.DisplayName(preferSharps);
        }

        public static int StringToMidiNote(string noteStr)
        {
            try
            {
                var note = new MusicalNote(noteStr);
                return note.ToMidiNoteNumber();
            }
            catch (ArgumentException)
            {
                return -1;
            }
        }

        public static bool IsValidMidiNote(int midiNote) =>
            midiNote >= MidiConstants.MIN_MIDI_NOTE && midiNote <= MidiConstants.MAX_MIDI_NOTE;

        // Helper method to get all valid notes in a MIDI range
        public static IEnumerable<string> GetNotesInRange(int startMidi, int endMidi, bool preferSharps = true)
        {
            for (int i = startMidi; i <= endMidi; i++)
            {
                if (IsValidMidiNote(i))
                {
                    yield return MidiNoteToString(i, preferSharps);
                }
            }
        }
    }

    [Serializable]
    public class MusicalNote : IComparable<MusicalNote>
    {
        private static readonly Dictionary<string, int> NOTE_TO_MIDI = new Dictionary<string, int>
        {
            {"C", 0}, {"C#", 1}, {"Db", 1},
            {"D", 2}, {"D#", 3}, {"Eb", 3},
            {"E", 4}, {"Fb", 4}, {"E#", 5},
            {"F", 5}, {"F#", 6}, {"Gb", 6},
            {"G", 7}, {"G#", 8}, {"Ab", 8},
            {"A", 9}, {"A#", 10}, {"Bb", 10},
            {"B", 11}, {"Cb", 11}, {"B#", 0}
        };

        private static readonly (string Natural, string Sharp, string Flat)[] MIDI_TO_NOTE = new[]
        {
            ("C", "", ""), // 0
            ("C#", "", "Db"), // 1
            ("D", "", ""), // 2
            ("D#", "", "Eb"), // 3
            ("E", "", "Fb"), // 4
            ("F", "", ""), // 5
            ("F#", "", "Gb"), // 6
            ("G", "", ""), // 7
            ("G#", "", "Ab"), // 8
            ("A", "", ""), // 9
            ("A#", "", "Bb"), // 10
            ("B", "", "") // 11
        };

        [SerializeField] private NoteName note;
        [SerializeField] private Accidental accidental;
        [Range(0, 8)][SerializeField] private int octave;

        public NoteName Note => note;
        public Accidental Accidental => accidental;
        public int Octave => octave;

        public MusicalNote(int midiNote)
        {
            if (!MidiNoteConverter.IsValidMidiNote(midiNote))
            {
                throw new ArgumentOutOfRangeException(nameof(midiNote),
                    $"MIDI note must be between {MidiConstants.MIN_MIDI_NOTE} and {MidiConstants.MAX_MIDI_NOTE}");
            }

            octave = CalculateOctave(midiNote);
            int noteInOctave = midiNote % MidiConstants.NOTES_PER_OCTAVE;
            (note, accidental) = GetNoteAndAccidental(noteInOctave);
        }

        public MusicalNote(string noteString)
        {
            if (string.IsNullOrEmpty(noteString))
                throw new ArgumentException("Note string cannot be empty");

            Match match = Regex.Match(noteString, @"^([A-G][#b]?)(-?\d+)$");
            if (!match.Success)
                throw new ArgumentException($"Invalid note format: {noteString}");

            string notePart = match.Groups[1].Value;
            string octavePart = match.Groups[2].Value;

            if (!NOTE_TO_MIDI.TryGetValue(notePart, out int noteValue))
                throw new ArgumentException($"Invalid note: {notePart}");

            octave = int.Parse(octavePart);
            (note, accidental) = GetNoteAndAccidental(noteValue);
        }

        public int ToMidiNoteNumber()
        {
            int baseNote = NOTE_TO_MIDI[$"{note}{(accidental == Accidental.Natural ? "" : accidental == Accidental.Sharp ? "#" : "b")}"];
            int midiNumber = (octave + MidiConstants.MIDI_OCTAVE_OFFSET) * MidiConstants.NOTES_PER_OCTAVE + baseNote;

            return MidiNoteConverter.IsValidMidiNote(midiNumber) ? midiNumber :
                throw new InvalidOperationException("Resulting MIDI note is out of range");
        }

        public string DisplayName(bool preferSharps = true)
        {
            int noteIndex = ToMidiNoteNumber() % MidiConstants.NOTES_PER_OCTAVE;
            var (natural, sharp, flat) = MIDI_TO_NOTE[noteIndex];

            string noteName = preferSharps ?
                (!string.IsNullOrEmpty(sharp) ? sharp : natural) :
                (!string.IsNullOrEmpty(flat) ? flat : natural);

            return $"{noteName}{octave}";
        }

        public int CompareTo(MusicalNote other)
        {
            if (other == null) return 1;
            return ToMidiNoteNumber().CompareTo(other.ToMidiNoteNumber());
        }

        private static int CalculateOctave(int midiNote)
        {
            return (midiNote / MidiConstants.NOTES_PER_OCTAVE) - MidiConstants.MIDI_OCTAVE_OFFSET;
        }

        private static (NoteName note, Accidental accidental) GetNoteAndAccidental(int noteInOctave)
        {
            var (natural, sharp, flat) = MIDI_TO_NOTE[noteInOctave];

            NoteName noteName = Enum.Parse<NoteName>(natural[0].ToString());
            Accidental acc = natural.Length > 1 ?
                (natural[1] == '#' ? Accidental.Sharp : Accidental.Flat) :
                Accidental.Natural;

            return (noteName, acc);
        }

        public static implicit operator int(MusicalNote note) => note.ToMidiNoteNumber();
        public static explicit operator MusicalNote(int midiNote) => new MusicalNote(midiNote);
    }
}