using SonicBloom.Koreo;
using SonicBloom.Koreo.Demos;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEditor;
using UnityEngine;


/// <summary>
/// Extension Methods for the <see cref="KoreographyEvent"/> class that add
/// <see cref="MIDIPayload"/>-specific functionality.
/// </summary>
public static class MIDIChordPayloadEventExtensions
{
    #region KoreographyEvent Extension Methods

    /// <summary>
    /// Determines if the payload is of type <see cref="MIDIChordPayload"/>.
    /// </summary>
    /// <returns><c>true</c> if the payload is of type <see cref="MIDIChordPayload"/>;
    /// otherwise, <c>false</c>.</returns>
    public static bool HasMIDIChordPayload(this KoreographyEvent koreoEvent)
    {
        return (koreoEvent.Payload as MIDIChordPayload) != null;
    }

    /// <summary>
    /// Retrieves the MIDI note values from the Payload
    /// <see cref="MIDIPayload"/> type.
    /// </summary>
    /// <param name="koreoEvent">The <c>this</c> <see cref="KoreographyEvent"/>.</param>
    public static int[] GetMIDIChordValues(this KoreographyEvent koreoEvent)
    {
        MIDIChordPayload pl = koreoEvent.Payload as MIDIChordPayload;
        if (pl != null)
        {
            return pl.NoteVals;
        }

        return null;
    }

    #endregion
}

[System.Serializable]
public class MIDIChordPayload : IPayload
{
    #region Fields

    [SerializeField]
    [Tooltip("The raw MIDI note values. Range: [0, 127].")]
    int[] mNotes;

    #endregion
    #region Properties

    /// <summary>
    /// Gets or sets the MIDI Note values [0, 127].
    /// </summary>
    /// <value>The MIDI Note values.</value>
    public int[] NoteVals
    {
        get
        {
            return mNotes;
        }
        set
        {
            mNotes = value;
        }
    }

    #endregion
    #region Standard Methods

    /// <summary>
    /// This is used by the Koreography Editor to create the Payload type entry
    /// in the UI dropdown.
    /// </summary>
    /// <returns>The friendly name of the class.</returns>
    public static string GetFriendlyName()
    {
        return "MIDI Chords";
    }

    #endregion
    #region IPayload Interface

#if UNITY_EDITOR

    static GUIContent noteTooltipContent = new GUIContent("", "Notes");

    /// <summary>
    /// Used for drawing the GUI in the Editor Window (possibly scene overlay?).  Undo is
    /// supported.
    /// </summary>
    /// <returns><c>true</c>, if the Payload was edited in the GUI, <c>false</c>
    /// otherwise.</returns>
    /// <param name="displayRect">The <c>Rect</c> within which to perform GUI drawing.</param>
    /// <param name="track">The Koreography Track within which the Payload can be found.</param>
    /// <param name="isSelected">Whether or not the Payload (or the Koreography Event that
    /// contains the Payload) is selected in the GUI.</param>
    public bool DoGUI(Rect displayRect, KoreographyTrackBase track, bool isSelected)
    {
        bool bDidEdit = false;
        Color originalBG = GUI.backgroundColor;
        GUI.backgroundColor = isSelected ? Color.green : originalBG;

        EditorGUI.BeginChangeCheck();
        {
            float width = displayRect.width / 2;

            Rect rect = new Rect(displayRect);
            rect.xMax = rect.xMin + width;
            
            string notesLabel = "";
            for (int i = 0; i < NoteVals.Length; i++)
            {
                notesLabel += NoteVals[i];

                if (i < NoteVals.Length - 1 && NoteVals.Length > 1)
                {
                    notesLabel += ", ";
                }
            }

            GUI.Label(rect, notesLabel);
            GUI.Box(rect, noteTooltipContent, GUIStyle.none);   // Tooltip

            rect.xMin = rect.xMax;
            rect.xMax = rect.xMin + width;
        }
        if (EditorGUI.EndChangeCheck())
        {
            Undo.RecordObject(track, "MIDI Payload Changed");

            bDidEdit = true;
        }

        GUI.backgroundColor = originalBG;
        return bDidEdit;
    }

    /// <summary>
    /// Used to determine the Payload's desired width for rendering in certain contexts
    /// (e.g. in Peek UI). Return <c>0</c> to indicate a default width.
    /// </summary>
    /// <returns>The desired width for UI rendering or <c>0</c> to use the default.</returns>
    public float GetDisplayWidth()
    {
        return 0f;  // Use default.
    }

#endif

    /// <summary>
    /// Returns a copy of the current object, including the pertinent parts of
    /// the payload.
    /// </summary>
    /// <returns>A copy of the Payload object.</returns>
    public IPayload GetCopy()
    {
        MIDIChordPayload newPL = new MIDIChordPayload();

        newPL.NoteVals = NoteVals;

        return newPL;
    }

    #endregion
}
