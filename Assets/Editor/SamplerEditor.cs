/*using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.Linq;
using UnityEngine.Audio;

namespace SpaciousPlaces.Editor
{
    [CustomEditor(typeof(Sampler))]
    public class SamplerEditor : UnityEditor.Editor
    {
        private Vector2 mainScrollPosition;

        private Dictionary<int, bool> groupCollapseStates = new Dictionary<int, bool>();

        // Serialized properties
        private SerializedProperty keyzonesProperty;
        private SerializedProperty quantizePitchProperty;

        // Piano roll constants
        private const float BUTTON_HEIGHT = 30f;
        private const float PADDING = 10f;
        private const float KEY_WIDTH = 32f;
        private const float KEYBOARD_HEIGHT = 60f;
        private const float KEYZONE_HEIGHT = 60f;
        private const float MIN_WINDOW_WIDTH = 800f;
        private const float HANDLE_WIDTH = 8f;
        private const float INFO_COLUMN_WIDTH = 210f; // Width of the new info column
        private const int LOWEST_NOTE = 21;  // A0
        private const int HIGHEST_NOTE = 96; // C7
        private readonly Color[] KEYZONE_COLORS = new Color[] {
            new Color(1, 0.4f, 0.4f, 0.5f),
            new Color(0.4f, 1, 0.4f, 0.5f),
            new Color(0.4f, 0.4f, 1, 0.5f),
            new Color(1, 1, 0.4f, 0.5f),
            new Color(0.4f, 1, 1, 0.5f),
            new Color(1, 0.4f, 1, 0.5f)
        };

        private Vector2 scrollPosition;
        private static readonly string[] NOTE_NAMES = { "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B" };

        // Drag state
        private int draggedKeyzoneIndex = -1;
        private bool isDraggingMin = false;
        private bool isDraggingMax = false;

        private void OnEnable()
        {
            keyzonesProperty = serializedObject.FindProperty("keyzones");
            quantizePitchProperty = serializedObject.FindProperty("quantizePitch");
        }
        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            // Space and title
            EditorGUILayout.Space(10);
            EditorGUILayout.LabelField("Keyzone Piano Roll", EditorStyles.boldLabel);

            // Add Import Configuration and Clear All Keyzones buttons
            EditorGUILayout.BeginHorizontal();

            if (GUILayout.Button("Import Configuration", GUILayout.Height(BUTTON_HEIGHT)))
            {
                string path = EditorUtility.OpenFilePanel("Select Configuration File", "", "json");
                if (!string.IsNullOrEmpty(path))
                {
                    Sampler sampler = (Sampler)target;
                    sampler.LoadConfiguration(path);
                }
            }

            GUI.backgroundColor = new Color(1f, 0.7f, 0.7f);
            if (GUILayout.Button("Clear All Keyzones", GUILayout.Height(BUTTON_HEIGHT)))
            {
                if (EditorUtility.DisplayDialog("Clear All Keyzones",
                    "Are you sure you want to clear all keyzones? This action cannot be undone.",
                    "Clear", "Cancel"))
                {
                    keyzonesProperty.ClearArray();
                    serializedObject.ApplyModifiedProperties();
                }
            }
            GUI.backgroundColor = Color.white;

            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space(PADDING);

            // Skip multi-object editing
            if (targets.Length > 1)
            {
                EditorGUILayout.HelpBox("Multi-object editing of keyzone mappings is not supported.", MessageType.Info);
                DrawDefaultInspector();
                return;
            }

            // Scrollable content rendering
            float viewportHeight = 400f;  // Fixed viewport height
            float totalWidth = (HIGHEST_NOTE - LOWEST_NOTE + 1) * KEY_WIDTH;
            float contentHeight = keyzonesProperty.arraySize * KEYZONE_HEIGHT;

            // Info column header (fixed position)
            Rect totalRect = EditorGUILayout.GetControlRect(GUILayout.Height(viewportHeight));
            Rect infoHeaderRect = new Rect(totalRect.x, totalRect.y, INFO_COLUMN_WIDTH, KEYBOARD_HEIGHT);

            // Draw the info column header
            DrawInfoColumnHeader(infoHeaderRect);

            // Piano keyboard header (scrollable horizontally)
            Rect keyboardHeaderRect = new Rect(
                totalRect.x + INFO_COLUMN_WIDTH,
                totalRect.y,
                totalRect.width - INFO_COLUMN_WIDTH,
                KEYBOARD_HEIGHT
            );

            // Scrollable area for horizontal piano scrolling
            Rect keyboardScrollRect = new Rect(
                totalRect.x + INFO_COLUMN_WIDTH,
                totalRect.y,
                totalRect.width - INFO_COLUMN_WIDTH,
                KEYBOARD_HEIGHT
            );

            Rect keyboardContentRect = new Rect(0, 0, totalWidth, KEYBOARD_HEIGHT);

            scrollPosition.x = GUI.HorizontalScrollbar(
                new Rect(
                    totalRect.x + INFO_COLUMN_WIDTH,
                    totalRect.y + KEYBOARD_HEIGHT - 10, // Adjust scrollbar position
                    totalRect.width - INFO_COLUMN_WIDTH,
                    10
                ),
                scrollPosition.x, // Current scroll position
                keyboardScrollRect.width, // Viewport size
                0, // Minimum scroll value
                totalWidth // Maximum scroll value
            );

            // Draw the horizontally scrollable piano keyboard
            GUI.BeginGroup(keyboardScrollRect);
            Rect keyboardVisibleRect = new Rect(-scrollPosition.x, 0, totalWidth, KEYBOARD_HEIGHT);
            DrawKeyboard(keyboardVisibleRect);
            GUI.EndGroup();

            // Info column content (scrollable vertically)
            Rect infoContentRect = new Rect(
                totalRect.x,
                totalRect.y + KEYBOARD_HEIGHT,
                INFO_COLUMN_WIDTH,
                viewportHeight - KEYBOARD_HEIGHT
            );
            DrawInfoColumnContent(infoContentRect);

            // Piano roll grid and keyzones (scrollable in both directions)
            Rect scrollViewRect = new Rect(
                totalRect.x + INFO_COLUMN_WIDTH,
                totalRect.y + KEYBOARD_HEIGHT,
                totalRect.width - INFO_COLUMN_WIDTH,
                viewportHeight - KEYBOARD_HEIGHT
            );

            Rect gridContentRect = new Rect(0, 0, totalWidth, contentHeight);

            scrollPosition = GUI.BeginScrollView(
                scrollViewRect,
                scrollPosition,
                gridContentRect,
                true,  // Horizontal scrollbar
                true   // Vertical scrollbar
            );

            DrawGrid(gridContentRect);
            DrawKeyzones(gridContentRect);

            GUI.EndScrollView();

            EditorGUILayout.PropertyField(keyzonesProperty, true);

            if (GUI.changed)
            {
                serializedObject.ApplyModifiedProperties();
            }
        }


        private void DrawInfoColumnHeader(Rect headerRect)
        {
            // Draw the background of the header
            EditorGUI.DrawRect(headerRect, new Color(0.3f, 0.3f, 0.3f));

            // Draw the header title
            Rect labelRect = new Rect(
                headerRect.x + 8f,  // Add padding to the left
                headerRect.y + 8f,  // Add padding to the top
                headerRect.width - 16f, // Subtract padding from the width
                headerRect.height - 16f // Subtract padding from the height
            );

            GUIStyle headerStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                normal = { textColor = Color.white },
                alignment = TextAnchor.MiddleLeft,
                fontSize = 12
            };

            EditorGUI.LabelField(labelRect, "Sample Info", headerStyle);
        }


        private void DrawInfoColumnContent(Rect infoColumnRect)
        {
            // Draw background for the info column
            Rect backgroundRect = new Rect(
                infoColumnRect.x,
                infoColumnRect.y,
                INFO_COLUMN_WIDTH,
                infoColumnRect.height
            );
            EditorGUI.DrawRect(backgroundRect, new Color(0.2f, 0.2f, 0.2f));

            // Align rows with the current scroll position
            float scrollOffsetY = scrollPosition.y; // Adjust for vertical scroll
            float visibleHeight = infoColumnRect.height;

            for (int i = 0; i < keyzonesProperty.arraySize; i++)
            {
                float rowY = (i * KEYZONE_HEIGHT) - scrollOffsetY;

                // Skip rows not visible within the current scroll view
                if (rowY + KEYZONE_HEIGHT < 0 || rowY > visibleHeight)
                    continue;

                Rect rowRect = new Rect(
                    infoColumnRect.x,
                    infoColumnRect.y + rowY,
                    INFO_COLUMN_WIDTH,
                    KEYZONE_HEIGHT
                );

                // Draw alternating background
                EditorGUI.DrawRect(rowRect, i % 2 == 0 ?
                    new Color(0.22f, 0.22f, 0.22f) :
                    new Color(0.25f, 0.25f, 0.25f));

                // Draw colored strip on the left
                Rect stripRect = new Rect(rowRect.x, rowRect.y, 4f, rowRect.height);
                EditorGUI.DrawRect(stripRect, KEYZONE_COLORS[i % KEYZONE_COLORS.Length]);

                // Additional property rendering as before
                var audioClipProp = GetKeyzoneProperty(i, "audioClip");
                string clipName = audioClipProp != null && audioClipProp.objectReferenceValue != null
                    ? (audioClipProp.objectReferenceValue as AudioClip).name
                    : "No Clip";

                // Base text style
                var textStyle = new GUIStyle(EditorStyles.label)
                {
                    normal = { textColor = Color.white },
                    fontSize = 10,
                    padding = new RectOffset(8, 4, 2, 2)
                };

                // Name (bold)
                Rect nameRect = new Rect(rowRect.x + 8f, rowRect.y + 4f, INFO_COLUMN_WIDTH - 12f, 16f);
                var boldStyle = new GUIStyle(textStyle) { fontStyle = FontStyle.Bold };
                EditorGUI.LabelField(nameRect, clipName, boldStyle);

                // Additional field rendering (e.g., root note, velocity)...
            }
        }


        private void DrawKeyboard(Rect rect)
        {
            float xPos = rect.x;

            for (int note = LOWEST_NOTE; note <= HIGHEST_NOTE; note++)
            {
                Rect keyRect = new Rect(xPos, rect.y, KEY_WIDTH, rect.height);
                bool isBlackKey = IsBlackKey(note);

                EditorGUI.DrawRect(keyRect, isBlackKey ? Color.black : Color.white);
                EditorGUI.DrawRect(
                    new Rect(keyRect.x, keyRect.y, 1, keyRect.height),
                    Color.gray
                );

                string noteName = GetNoteName(note);
                var style = new GUIStyle(EditorStyles.label)
                {
                    normal = { textColor = isBlackKey ? Color.white : Color.black },
                    alignment = TextAnchor.LowerCenter
                };

                EditorGUI.LabelField(keyRect, noteName, style);
                xPos += KEY_WIDTH;
            }
        }

        private void DrawGrid(Rect rect)
        {
            float xPos = rect.x;

            // Draw vertical grid lines
            for (int note = LOWEST_NOTE; note <= HIGHEST_NOTE; note++)
            {
                EditorGUI.DrawRect(
                    new Rect(xPos, rect.y, 1, rect.height),
                    IsBlackKey(note) ? new Color(0.7f, 0.7f, 0.7f) : new Color(0.9f, 0.9f, 0.9f)
                );
                xPos += KEY_WIDTH;
            }

            // Draw horizontal grid lines
            for (int i = 0; i <= keyzonesProperty.arraySize; i++)
            {
                float yPos = rect.y + (i * KEYZONE_HEIGHT);
                EditorGUI.DrawRect(
                    new Rect(rect.x, yPos, rect.width, 1),
                    new Color(0.8f, 0.8f, 0.8f)
                );
            }

            // Draw root note columns
            for (int i = 0; i < keyzonesProperty.arraySize; i++)
            {
                var rootNote = GetKeyzoneProperty(i, "rootNote");
                if (rootNote != null)
                {
                    int rootMidiNote = CalculateMidiNoteFromProps(rootNote);
                    float rootX = NoteToX(rect, rootMidiNote);

                    // Draw root note column highlight
                    Color rootHighlight = new Color(1f, 1f, 0.8f, 0.2f);
                    Rect rootColumnRect = new Rect(
                        rootX,
                        rect.y + (i * KEYZONE_HEIGHT),
                        KEY_WIDTH,
                        KEYZONE_HEIGHT
                    );
                    EditorGUI.DrawRect(rootColumnRect, rootHighlight);
                }
            }
        }

        private void DrawKeyzones(Rect rect)
        {
            if (keyzonesProperty == null || keyzonesProperty.arraySize == 0) return;

            for (int i = 0; i < keyzonesProperty.arraySize; i++)
            {
                try
                {
                    var keyzoneProperty = keyzonesProperty.GetArrayElementAtIndex(i);
                    Keyzone keyzone = keyzoneProperty.objectReferenceValue as Keyzone;
                    if (keyzone == null)
                    {
                        Debug.LogError($"Keyzone at index {i} is null");
                        continue;
                    }

                    // Create a SerializedObject for the keyzone
                    SerializedObject keyzoneObject = new SerializedObject(keyzone);

                    var rootNoteProp = GetKeyzoneProperty(i, "rootNote");
                    var minNoteProp = GetKeyzoneProperty(i, "minNote");
                    var maxNoteProp = GetKeyzoneProperty(i, "maxNote");

                    if (rootNoteProp == null || minNoteProp == null || maxNoteProp == null)
                    {
                        Debug.LogError($"Could not find required properties for keyzone {i}");
                        continue;
                    }

                    // Now we can use FindPropertyRelative since we're working with the MusicalNote class
                    var rootNote = rootNoteProp.FindPropertyRelative("note");
                    var rootAccidental = rootNoteProp.FindPropertyRelative("accidental");
                    var rootOctave = rootNoteProp.FindPropertyRelative("octave");

                    var minNote = minNoteProp.FindPropertyRelative("note");
                    var minAccidental = minNoteProp.FindPropertyRelative("accidental");
                    var minOctave = minNoteProp.FindPropertyRelative("octave");

                    var maxNote = maxNoteProp.FindPropertyRelative("note");
                    var maxAccidental = maxNoteProp.FindPropertyRelative("accidental");
                    var maxOctave = maxNoteProp.FindPropertyRelative("octave");

                    // Calculate MIDI notes using the MusicalNote properties
                    int minMidiNote = CalculateMidiNoteFromComponents(
                        minNote.enumValueIndex,
                        minAccidental.enumValueIndex,
                        minOctave.intValue
                    );
                    int maxMidiNote = CalculateMidiNoteFromComponents(
                        maxNote.enumValueIndex,
                        maxAccidental.enumValueIndex,
                        maxOctave.intValue
                    );
                    int rootMidiNote = CalculateMidiNoteFromComponents(
                        rootNote.enumValueIndex,
                        rootAccidental.enumValueIndex,
                        rootOctave.intValue
                    );

                    Debug.Log($"Keyzone {i}: Min={GetNoteName(minMidiNote)} ({minMidiNote}), Max={GetNoteName(maxMidiNote)} ({maxMidiNote}), Root={GetNoteName(rootMidiNote)} ({rootMidiNote})");


                    float startX = NoteToX(rect, minMidiNote);
                    float endX = NoteToX(rect, maxMidiNote);
                    float width = endX - startX + KEY_WIDTH;
                    float yPos = rect.y + (i * KEYZONE_HEIGHT);

                    Color keyzoneColor = KEYZONE_COLORS[i % KEYZONE_COLORS.Length];
                    Color handleColor = new Color(0.2f, 0.2f, 0.2f, 0.8f);

                    // Draw main keyzone area (now using full height since velocity area is removed)
                    Rect keyzoneRect = new Rect(startX, yPos, width, KEYZONE_HEIGHT);
                    EditorGUI.DrawRect(keyzoneRect, keyzoneColor);

                    // Draw note range handles
                    Rect leftHandle = new Rect(startX - HANDLE_WIDTH / 2, yPos, HANDLE_WIDTH, KEYZONE_HEIGHT);
                    Rect rightHandle = new Rect(endX + KEY_WIDTH - HANDLE_WIDTH / 2, yPos, HANDLE_WIDTH, KEYZONE_HEIGHT);
                    EditorGUI.DrawRect(leftHandle, handleColor);
                    EditorGUI.DrawRect(rightHandle, handleColor);

                    // Draw root note line
                    float rootX = NoteToX(rect, rootMidiNote);
                    Rect rootLineRect = new Rect(
                        rootX - 1,
                        yPos,
                        2,
                        KEYZONE_HEIGHT
                    );
                    EditorGUI.DrawRect(rootLineRect, Color.black);

                    // Update tooltip
                    if (keyzoneRect.Contains(Event.current.mousePosition))
                    {
                        var audioClipProp = GetKeyzoneProperty(i, "audioClip");
                        string clipName = audioClipProp != null && audioClipProp.objectReferenceValue != null ?
                            (audioClipProp.objectReferenceValue as AudioClip).name : "No Clip";

                        string tooltipText = $"Clip: {clipName}\n" +
                            $"Range: {GetNoteName(minMidiNote)} - {GetNoteName(maxMidiNote)}\n" +
                            $"Root: {GetNoteName(rootMidiNote)}";

                        Rect tooltipRect = new Rect(Event.current.mousePosition.x, Event.current.mousePosition.y - 60, 200, 55);
                        Color tooltipColor = keyzoneColor;
                        tooltipColor.a = 0.95f;
                        EditorGUI.DrawRect(tooltipRect, tooltipColor);
                        GUI.Box(tooltipRect, "", new GUIStyle { border = new RectOffset(1, 1, 1, 1) });
                        EditorGUI.LabelField(tooltipRect, tooltipText, new GUIStyle(EditorStyles.label)
                        {
                            normal = { textColor = Color.white },
                            padding = new RectOffset(8, 8, 8, 8),
                            wordWrap = true,
                            fontSize = 11,
                            fontStyle = FontStyle.Bold
                        });
                        Repaint();
                    }

                    Event e = Event.current;
                    if (e.type == EventType.MouseDown && e.button == 0)
                    {
                        if (leftHandle.Contains(e.mousePosition))
                        {
                            draggedKeyzoneIndex = i;
                            isDraggingMin = true;
                            e.Use();
                        }
                        else if (rightHandle.Contains(e.mousePosition))
                        {
                            draggedKeyzoneIndex = i;
                            isDraggingMax = true;
                            e.Use();
                        }
                    }

                    // Important: If we modified any values, apply them
                    if (GUI.changed)
                    {
                        keyzoneObject.ApplyModifiedProperties();
                    }
                }
                catch (System.Exception e)
                {
                    Debug.LogError($"Error processing keyzone {i}: {e.Message}\n{e.StackTrace}");
                }
            }
        }

        private void HandleDragging(Rect totalRect)
        {
            Event e = Event.current;
            if (e.type == EventType.MouseDrag && draggedKeyzoneIndex != -1)
            {
                var keyzoneProperty = keyzonesProperty.GetArrayElementAtIndex(draggedKeyzoneIndex);
                Keyzone keyzone = keyzoneProperty.objectReferenceValue as Keyzone;
                if (keyzone == null) return;

                SerializedObject keyzoneObject = new SerializedObject(keyzone);
                float mouseX = e.mousePosition.x;

                if (isDraggingMin || isDraggingMax)
                {
                    int newNote = XToNote(totalRect, mouseX);
                    newNote = Mathf.Clamp(newNote, LOWEST_NOTE, HIGHEST_NOTE);

                    if (isDraggingMin)
                    {
                        var minNote = GetKeyzoneProperty(draggedKeyzoneIndex, "minNote");
                        var maxNote = GetKeyzoneProperty(draggedKeyzoneIndex, "maxNote");
                        int maxMidiNote = CalculateMidiNoteFromProps(maxNote);
                        if (newNote <= maxMidiNote)
                        {
                            UpdateNotePropertyFromMidi(minNote, newNote);
                        }
                    }
                    else if (isDraggingMax)
                    {
                        var minNote = GetKeyzoneProperty(draggedKeyzoneIndex, "minNote");
                        var maxNote = GetKeyzoneProperty(draggedKeyzoneIndex, "maxNote");
                        int minMidiNote = CalculateMidiNoteFromProps(minNote);
                        if (newNote >= minMidiNote)
                        {
                            UpdateNotePropertyFromMidi(maxNote, newNote);
                        }
                    }

                    keyzoneObject.ApplyModifiedProperties();
                }

                serializedObject.ApplyModifiedProperties();
                e.Use();
                Repaint();
            }
            else if (e.type == EventType.MouseUp)
            {
                draggedKeyzoneIndex = -1;
                isDraggingMin = false;
                isDraggingMax = false;
            }
        }
        private float NoteToX(Rect rect, int midiNote)
        {
            // Calculate the x-position relative to the piano roll's left edge (C1)
            float noteIndex = Mathf.Max(0, midiNote - LOWEST_NOTE);
            return rect.x + (noteIndex * KEY_WIDTH);
        }

        private int XToNote(Rect rect, float x)
        {
            // Convert x-position back to MIDI note number, ensuring we don't go below C1
            float noteIndex = (x - rect.x) / KEY_WIDTH;
            return Mathf.Max(LOWEST_NOTE, Mathf.RoundToInt(noteIndex) + LOWEST_NOTE);
        }

        private void UpdateNotePropertyFromMidi(SerializedProperty musicalNoteProp, int midiNote)
        {
            int octave = (midiNote / 12) - 1;
            int noteInOctave = midiNote % 12;

            // Convert MIDI note number to musical note properties
            int noteIndex = 0;
            int accidental = 0;

            switch (noteInOctave)
            {
                case 0: noteIndex = 2; accidental = 0; break; // C
                case 1: noteIndex = 2; accidental = 2; break; // C#
                case 2: noteIndex = 3; accidental = 0; break; // D
                case 3: noteIndex = 3; accidental = 2; break; // D#
                case 4: noteIndex = 4; accidental = 0; break; // E
                case 5: noteIndex = 5; accidental = 0; break; // F
                case 6: noteIndex = 5; accidental = 2; break; // F#
                case 7: noteIndex = 6; accidental = 0; break; // G
                case 8: noteIndex = 6; accidental = 2; break; // G#
                case 9: noteIndex = 0; accidental = 0; break; // A
                case 10: noteIndex = 0; accidental = 2; break; // A#
                case 11: noteIndex = 1; accidental = 0; break; // B
            }

            musicalNoteProp.FindPropertyRelative("note").enumValueIndex = noteIndex;
            musicalNoteProp.FindPropertyRelative("accidental").enumValueIndex = accidental;
            musicalNoteProp.FindPropertyRelative("octave").intValue = octave;
        }

        private bool IsBlackKey(int midiNote)
        {
            int noteInOctave = midiNote % 12;
            return new[] { 1, 3, 6, 8, 10 }.Contains(noteInOctave);
        }

        private string GetNoteName(int midiNote)
        {
            int noteInOctave = midiNote % 12;
            int octave = (midiNote / 12) - 1; // Adjust here if necessary
            return $"{NOTE_NAMES[noteInOctave]}{octave}";
        }

        private int CalculateMidiNoteFromProps(SerializedProperty musicalNoteProp)
        {
            var noteProp = musicalNoteProp.FindPropertyRelative("note");
            var accidentalProp = musicalNoteProp.FindPropertyRelative("accidental");
            var octaveProp = musicalNoteProp.FindPropertyRelative("octave");

            // NoteName enum: A=0, B=1, C=2, D=3, E=4, F=5, G=6
            // Semitone offsets relative to C
            int[] semitoneOffsets = { 9, 11, 0, 2, 4, 5, 7 }; // A, B, C, D, E, F, G

            int semitone = semitoneOffsets[noteProp.enumValueIndex];

            // Adjust for the accidental (Natural=0, Flat=1, Sharp=2)
            if (accidentalProp.enumValueIndex == 1) // Flat
            {
                semitone -= 1;
            }
            else if (accidentalProp.enumValueIndex == 2) // Sharp
            {
                semitone += 1;
            }

            return 12 * (octaveProp.intValue + 1) + semitone;
        }

        private int CalculateMidiNoteFromComponents(int noteIndex, int accidentalIndex, int octave)
        {
            // NoteName enum: A=0, B=1, C=2, D=3, E=4, F=5, G=6
            // Semitone offsets relative to C
            int[] semitoneOffsets = { 9, 11, 0, 2, 4, 5, 7 }; // A, B, C, D, E, F, G

            int semitone = semitoneOffsets[noteIndex];

            // Adjust for the accidental (Natural=0, Flat=1, Sharp=2)
            if (accidentalIndex == 1) // Flat
            {
                semitone -= 1;
            }
            else if (accidentalIndex == 2) // Sharp
            {
                semitone += 1;
            }

            return 12 * (octave + 1) + semitone;
        }

        private SerializedProperty GetKeyzoneProperty(int index, string propertyName)
        {
            var keyzoneProperty = keyzonesProperty.GetArrayElementAtIndex(index);
            if (keyzoneProperty == null) return null;

            // Get the Keyzone ScriptableObject reference
            Keyzone keyzone = keyzoneProperty.objectReferenceValue as Keyzone;
            if (keyzone == null) return null;

            // Create SerializedObject for the keyzone
            SerializedObject keyzoneObject = new SerializedObject(keyzone);
            return keyzoneObject.FindProperty(propertyName);
        }
    }
}*/