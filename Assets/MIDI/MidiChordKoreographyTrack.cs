using ProximaWebSocketSharp;
using SonicBloom.Koreo;
using SonicBloom.Koreo.Demos;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;

#if !(UNITY_4_5 || UNITY_4_6 || UNITY_4_7 || UNITY_5_0)
// This attribute adds the class to the Assets/Create menu so that it may be
//	instantiated. [Requires Unity 5.1.0 and up.]
[CreateAssetMenuAttribute(fileName = "New MidiChordKoreographyTrack", menuName = "Midi Chord Koreography Track")]
#endif
[Serializable]
public partial class MidiChordKoreographyTrack : KoreographyTrackBase
{
    [HideInInspector]
    [SerializeField]
    protected List<MIDIChordPayload> _MIDIChordPayloads;
    [HideInInspector]
    [SerializeField]
    protected List<int> _MIDIChordPayloadIdxs;
}

#if UNITY_EDITOR

public partial class MidiChordKoreographyTrack : IMIDIConvertible
{
    /// <summary>
    /// Converts the passed in MIDI events into KoreographyEvents with payload of type
    /// <see cref="MIDIChordPayload"/>. The Payload stores midi chord info for pitch quantizing. Any previously existing events will be overwritten.
    /// </summary>
    /// <param name="events">The list of raw <see cref="KoreoMIDIEvent"/>s to convert.</param>

    /// <summary>
    /// Dictionary to keep track of the start sample so we can add to the note value if there are multiple notes at the same time
    /// </summary>
    private Dictionary<int, KoreographyEvent> _sampleStartEventMap = new Dictionary<int, KoreographyEvent>();

    public void ConvertMIDIEvents(List<KoreoMIDIEvent> events)
    {
        UnityEditor.Undo.RecordObject(this, "Convert MIDI Events");

        List<KoreoMIDIEvent> customEvents = new List<KoreoMIDIEvent>();
        this.RemoveAllEvents();
        _sampleStartEventMap.Clear();

        foreach (KoreoMIDIEvent midiEvent in events)
        {
            int startSample = midiEvent.startSample;

            if (_sampleStartEventMap.ContainsKey(startSample))
            {
                KoreographyEvent existingEvent = _sampleStartEventMap[startSample];
                MIDIChordPayload existingPayload = existingEvent.Payload as MIDIChordPayload;
                if (existingPayload != null)
                {
                    existingPayload.NoteVals = existingPayload.NoteVals.Append(midiEvent.note).ToArray();
                }
            }
            else
            {
                KoreographyEvent newEvt = new KoreographyEvent();
                newEvt.StartSample = startSample;

                MIDIChordPayload pl = new MIDIChordPayload();

                Debug.Log("note: " + midiEvent.note.ToString());

                pl.NoteVals = new int[] {midiEvent.note};
                newEvt.Payload = pl;
                this.AddEvent(newEvt);
                _sampleStartEventMap.Add(startSample, newEvt);
            }
        }

        EditorUtility.SetDirty(this);
    }
}
#endif
