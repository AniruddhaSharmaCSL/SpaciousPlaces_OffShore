using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Sirenix.OdinInspector;
using UnityEditor;
using System.Linq;
using Oculus.Haptics;


namespace SpaciousPlaces
{
    [RequireComponent(typeof(AudioSource))]
    public class Sampler : MonoBehaviour
    {
        [Title("General Settings", bold: true, horizontalLine: true)]

        public List<Keyzone> Keyzones;

        [Header("Haptics")]
        [SerializeField]
        private HapticClip hapticClip;

        [SerializeField]
        [Range(0.0f, 1.0f)]
        private float amplitude = 1.0f;

        [SerializeField]
        [Range(-1.0f, 1.0f)]
        private float frequency = 1.0f;

        [Title("Debug Settings", bold: true, horizontalLine: true)]
        [SerializeField, LabelText("Debug UI Prefab")]
        private GameObject debugUIPrefab;

        [SerializeField] private HorizontalLayoutGroup horizontalLayoutGroup;

        [ToggleLeft]
        [SerializeField, LabelText("Show Debug Text")]
        private bool showDebugText = false;

        [HideInInspector]
        public string[] micPositions;

        private Vector2 scrollPosition = Vector2.zero;         // Horizontal scroll position

        // Runtime Dictionaries
        private Dictionary<Keyzone, PitchQuantizer> keyzoneToPitchQuantizer = new Dictionary<Keyzone, PitchQuantizer>();
        private Dictionary<InstrumentCollision, List<Keyzone>> instrumentCollisionToKeyzones = new Dictionary<InstrumentCollision, List<Keyzone>>();
        private Dictionary<string, SamplerDebugUI> micPositionToDebugUI = new Dictionary<string, SamplerDebugUI>();
        private Dictionary<Keyzone, Queue<AudioSource>> keyzoneToAudioSources = new Dictionary<Keyzone, Queue<AudioSource>>();
        private const int MAX_OVERLAPPING_NOTES = 10;

        private void Awake()
        {
            InitializeSampler();
        }

        [Button(ButtonSizes.Medium), GUIColor(0.5f, 0.8f, 1.0f)]
        public void AutoAssignColliders()
        {
            var instrumentColliders = GetComponentsInChildren<InstrumentCollision>()
                .OrderBy(c => c.transform.GetSiblingIndex())
                .ToArray();

            if (instrumentColliders.Length == 0)
            {
                Debug.LogWarning("No InstrumentCollision components found.");
                return;
            }

            // Group keyzones by root note
            var groupedKeyzones = Keyzones
                .GroupBy(k => k.RootNote.ToMidiNoteNumber())
                .OrderBy(g => g.Key)
                .ToList();

            int colliderIndex = 0;
            foreach (var group in groupedKeyzones)
            {
                if (colliderIndex >= instrumentColliders.Length) break;

                var collider = instrumentColliders[colliderIndex];
                foreach (var keyzone in group)
                {
                    keyzone.Collider = collider;
                }

                colliderIndex++;
            }
 

            if (colliderIndex < instrumentColliders.Length)
            {
                Debug.LogWarning($"Unused colliders: {instrumentColliders.Length - colliderIndex}");
            }
        }

        [Button(ButtonSizes.Medium), GUIColor(1.0f, 0.4f, 0.4f)]
        public void ClearKeyzonesAndMicPositions()
        {
            if (Keyzones != null && Keyzones.Count > 0)
            {
                Keyzones.Clear();
                keyzoneToPitchQuantizer.Clear();
                instrumentCollisionToKeyzones.Clear();

                Debug.Log("All keyzones cleared.");
            }
            else
            {
                Debug.LogWarning("No keyzones to clear.");
            }

            micPositions = null;
        }

        private void InitializeSampler()
        {
            var baseAudioSource = GetComponent<AudioSource>();
            var instrumentColliders = GetComponentsInChildren<InstrumentCollision>();

            foreach (var keyzone in Keyzones)
            {
                if (keyzone.Collider != null)
                {
                    // Create pitch quantizer
                    var pitchQuantizer = keyzone.Collider.gameObject.AddComponent<PitchQuantizer>();
                    pitchQuantizer.Initialize(keyzone.RootNote, keyzone.MinNote, keyzone.MaxNote, keyzone.KoreMidiNoteEventId);
                    keyzoneToPitchQuantizer[keyzone] = pitchQuantizer;

                    var audioSourceQueue = new Queue<AudioSource>();

                    for (int i = 0; i < MAX_OVERLAPPING_NOTES; i++)
                    {
                        // Create dedicated audio source
                        var audioSourceGO = new GameObject($"AudioSource_{keyzone.name}");

                        audioSourceGO.transform.parent = transform;
                        var audioSource = audioSourceGO.AddComponent<AudioSource>();

                        // Set haptics
                        keyzone.Collider.SetHaptics(hapticClip, frequency, amplitude);

                        // Copy settings from base audio source
                        audioSource.outputAudioMixerGroup = keyzone.Mixer;
                        audioSource.playOnAwake = false;
                        audioSource.clip = keyzone.AudioClip;

                        audioSource.volume = baseAudioSource.volume;
                        audioSource.spatialBlend = baseAudioSource.spatialBlend;
                        audioSource.spread = baseAudioSource.spread;
                        audioSource.dopplerLevel = baseAudioSource.dopplerLevel;
                        audioSource.rolloffMode = baseAudioSource.rolloffMode;
                        audioSource.minDistance = baseAudioSource.minDistance;
                        audioSource.maxDistance = baseAudioSource.maxDistance;

                        audioSource.panStereo = baseAudioSource.panStereo;
                        audioSource.priority = baseAudioSource.priority;
                        audioSource.reverbZoneMix = baseAudioSource.reverbZoneMix;

                        audioSource.bypassEffects = baseAudioSource.bypassEffects;
                        audioSource.bypassListenerEffects = baseAudioSource.bypassListenerEffects;
                        audioSource.bypassReverbZones = baseAudioSource.bypassReverbZones;

                        audioSourceQueue.Enqueue(audioSource);
                    }

                    keyzoneToAudioSources[keyzone] = audioSourceQueue;

                    // Add to collision mapping
                    if (!instrumentCollisionToKeyzones.ContainsKey(keyzone.Collider))
                    {
                        instrumentCollisionToKeyzones[keyzone.Collider] = new List<Keyzone>();
                    }
                    instrumentCollisionToKeyzones[keyzone.Collider].Add(keyzone);
                }
            }

            if (showDebugText && debugUIPrefab != null)
            {
                foreach (string micPosition in micPositions)
                {
                    if (!micPositionToDebugUI.ContainsKey(micPosition))
                    {
                        GameObject debugUIInstance = Instantiate(debugUIPrefab, horizontalLayoutGroup.transform);
                        debugUIInstance.name = $"Debug UI - {micPosition}";

                        var debugUI = debugUIInstance.GetComponent<SamplerDebugUI>();
                        micPositionToDebugUI.Add(micPosition, debugUI);
                    }
                }
            }

            Debug.Log("Keyzone setup done: " + Keyzones.Count);
        }

        // Track drag state
        static int activeKeyzoneIndex = -1;
        static bool isDraggingMin = false;
        static bool isDraggingMax = false;
        static float dragStartX = 0;
        static int dragStartNote = 0;

        [OnInspectorGUI]
        private void DrawPianoRollAndGrid()
        {
#if UNITY_EDITOR
            const int keysInOctave = 12;
            const int totalKeys = 88; // Full piano roll (A0 to C8)
            const int lowestNote = 0; // C-2
            const float keyWidth = 20f; // Width of each key
            const float pianoHeight = 50f; // Height of the piano keyboard
            const float rowHeight = 140f; // Height for each keyzone row
            const float labelsColumnWidth = 200f; // Width of the labels column
            const int visibleRows = 5; // Number of visible keyzone rows at a time
            const float visibleKeysWidth = 450f; // Visible width for the piano/grid area

            float totalPianoWidth = totalKeys * keyWidth;
            float visibleGridHeight = visibleRows * rowHeight;
            float totalGridHeight = Keyzones.Count * rowHeight;

            // Add spacing before the piano roll
            EditorGUILayout.Space(10);

            // Reserve space for the visible area
            Rect totalArea = GUILayoutUtility.GetRect(
                labelsColumnWidth + visibleKeysWidth,
                pianoHeight + visibleGridHeight,
                GUILayout.MaxWidth(labelsColumnWidth + visibleKeysWidth),
                GUILayout.MinWidth(labelsColumnWidth + visibleKeysWidth)
            );

            // Draw main background
            EditorGUI.DrawRect(totalArea, new Color(0.1f, 0.1f, 0.1f, 0.2f));

            // Draw fixed piano header background
            Rect pianoHeaderArea = new Rect(totalArea.x, totalArea.y, totalArea.width, pianoHeight);
            EditorGUI.DrawRect(pianoHeaderArea, new Color(0.2f, 0.2f, 0.2f, 1f));

            // Draw fixed labels column background
            EditorGUI.DrawRect(
                new Rect(totalArea.x, totalArea.y + pianoHeight, labelsColumnWidth, totalArea.height - pianoHeight),
                new Color(0.2f, 0.2f, 0.2f, 1f)
            );

            // Create clipped area for piano keys that stays fixed at top but scrolls horizontally
            GUI.BeginGroup(new Rect(totalArea.x + labelsColumnWidth, totalArea.y, visibleKeysWidth, pianoHeight));

            // Draw piano keys offset by horizontal scroll position
            for (int i = 0; i < totalKeys; i++)
            {
                Rect keyRect = new Rect(i * keyWidth - scrollPosition.x, 0, keyWidth, pianoHeight);

                // Only draw keys that are visible
                if (keyRect.x + keyRect.width >= 0 && keyRect.x <= visibleKeysWidth)
                {
                    bool isBlackKey = IsBlackKey(i % keysInOctave);
                    EditorGUI.DrawRect(keyRect, isBlackKey ? Color.black : Color.white);
                    GUI.Box(keyRect, GUIContent.none);

                    string noteName = GetNoteName(lowestNote + i);
                    var style = new GUIStyle(EditorStyles.label)
                    {
                        alignment = TextAnchor.MiddleCenter,
                        normal = { textColor = isBlackKey ? Color.white : Color.black }
                    };
                    EditorGUI.LabelField(keyRect, noteName, style);
                }
            }

            GUI.EndGroup();

            // Create the clip area for the labels
            GUI.BeginGroup(new Rect(totalArea.x, totalArea.y + pianoHeight, labelsColumnWidth, totalArea.height - pianoHeight));

            // Draw labels in fixed column - offset by scroll position to sync with grid
            for (int i = 0; i < Keyzones.Count; i++)
            {
                float rowY = (i * rowHeight) - scrollPosition.y;

                // Only draw visible labels
                if (rowY + rowHeight > 0 && rowY < totalArea.height - pianoHeight)
                {
                    var keyzone = Keyzones[i];

                    // Draw colored vertical line
                    Rect colorLineRect = new Rect(5, rowY, 3, rowHeight - 2);
                    EditorGUI.DrawRect(colorLineRect, GetKeyzoneColor(i));

                    Rect labelRect = new Rect(12, rowY, labelsColumnWidth - 17, 18);
                    GUI.Label(labelRect, $"Root: {keyzone.RootNote.DisplayName()}", EditorStyles.boldLabel);

                    Rect rangeLabelRect = new Rect(12, rowY + 20, labelsColumnWidth - 25, 18);
                    string noteRange = $"{keyzone.MinNote.DisplayName()} - {keyzone.MaxNote.DisplayName()}";
                    GUI.Label(rangeLabelRect, $"Range: {noteRange}", EditorStyles.miniLabel);

                    Rect velocityRect = new Rect(12, rowY + 40, labelsColumnWidth - 25, 18);
                    GUI.Label(velocityRect, $"Velocity: {keyzone.MinVelocity}-{keyzone.MaxVelocity}");

                    Rect roundRobinRect = new Rect(12, rowY + 60, labelsColumnWidth - 25, 18);
                    GUI.Label(roundRobinRect, $"RR: {keyzone.RoundRobinOrder}");

                    Rect articulationRect = new Rect(12, rowY + 80, labelsColumnWidth - 25, 18);
                    GUI.Label(articulationRect, $"Articulation: {keyzone.Articulation}");

                    Rect colliderRect = new Rect(12, rowY + 100, labelsColumnWidth, 18);
                    keyzone.Collider = (InstrumentCollision)EditorGUI.ObjectField(
                        colliderRect,
                        "Collider",
                        keyzone.Collider,
                        typeof(Collider),
                        true
                    );

                    Rect fileNameRect = new Rect(12, rowY + 120, labelsColumnWidth - 25, 18);
                    string fileName = keyzone.AudioClip != null ? keyzone.AudioClip.name : "No File";
                    GUI.Label(fileNameRect, fileName, EditorStyles.miniLabel);
                }
            }

            GUI.EndGroup();

            // Main scroll view for grid only
            Rect mainViewArea = new Rect(
                totalArea.x + labelsColumnWidth,
                totalArea.y + pianoHeight,
                totalArea.width - labelsColumnWidth,
                totalArea.height - pianoHeight
            );

            Rect contentRect = new Rect(
                0,
                0,
                totalPianoWidth,
                totalGridHeight
            );

            scrollPosition = GUI.BeginScrollView(
                mainViewArea,
                scrollPosition,
                contentRect,
                true,   // Horizontal scrollbar
                true    // Vertical scrollbar
            );

            // Draw grid content
            for (int i = 0; i < Keyzones.Count; i++)
            {
                float rowY = i * rowHeight;
                if (rowY + rowHeight < scrollPosition.y - rowHeight || rowY > scrollPosition.y + visibleGridHeight + rowHeight)
                    continue;

                var keyzone = Keyzones[i];

                int minNoteIndex = Mathf.Clamp(keyzone.MinNote.ToMidiNoteNumber() - lowestNote, 0, totalKeys - 1);
                int maxNoteIndex = Mathf.Clamp(keyzone.MaxNote.ToMidiNoteNumber() - lowestNote, 0, totalKeys - 1);

                Rect rangeRect = new Rect(
                    minNoteIndex * keyWidth,
                    rowY,
                    (maxNoteIndex - minNoteIndex + 1) * keyWidth,
                    rowHeight - 2
                );

                // Draw handle areas
                float handleWidth = 10f;
                Rect leftHandle = new Rect(rangeRect.x - handleWidth / 2, rangeRect.y, handleWidth, rangeRect.height);
                Rect rightHandle = new Rect(rangeRect.xMax - handleWidth / 2, rangeRect.y, handleWidth, rangeRect.height);

                EditorGUI.DrawRect(rangeRect, GetKeyzoneColor(i));
                GUI.Box(rangeRect, GUIContent.none);

                // Draw handle indicators
                EditorGUI.DrawRect(leftHandle, new Color(0.8f, 0.8f, 0.8f, 0.5f));
                EditorGUI.DrawRect(rightHandle, new Color(0.8f, 0.8f, 0.8f, 0.5f));

                // Handle mouse events
                Event e = Event.current;
                Vector2 mousePos = e.mousePosition;

                switch (e.type)
                {
                    case EventType.MouseDown:
                        if (e.button == 0)
                        {
                            if (leftHandle.Contains(mousePos))
                            {
                                activeKeyzoneIndex = i;
                                isDraggingMin = true;
                                isDraggingMax = false;
                                dragStartX = mousePos.x;
                                dragStartNote = keyzone.MinNote.ToMidiNoteNumber();
                                e.Use();
                            }
                            else if (rightHandle.Contains(mousePos))
                            {
                                activeKeyzoneIndex = i;
                                isDraggingMin = false;
                                isDraggingMax = true;
                                dragStartX = mousePos.x;
                                dragStartNote = keyzone.MaxNote.ToMidiNoteNumber();
                                e.Use();
                            }
                        }
                        break;

                    case EventType.MouseDrag:
                        if (activeKeyzoneIndex == i && (isDraggingMin || isDraggingMax))
                        {
                            float dragDelta = mousePos.x - dragStartX;

                            // Calculate the exact position in note space
                            float exactNoteChange = dragDelta / keyWidth;

                            // When holding Shift, allow free movement without snapping
                            bool useSnapping = !e.shift;
                            int noteChange;

                            if (useSnapping)
                            {
                                // Snap to nearest semitone
                                noteChange = Mathf.RoundToInt(exactNoteChange);

                                // Draw snap indicator line
                                float snapX = dragStartX + (noteChange * keyWidth);
                                Color snapColor = new Color(1f, 1f, 1f, 0.5f);
                                EditorGUI.DrawRect(new Rect(snapX - 1, rowY, 2, rowHeight), snapColor);
                            }
                            else
                            {
                                // Allow fractional movement when holding Shift
                                noteChange = Mathf.FloorToInt(exactNoteChange);
                            }

                            if (isDraggingMin)
                            {
                                int newNote = Mathf.Clamp(dragStartNote + noteChange, lowestNote, keyzone.MaxNote.ToMidiNoteNumber());
                                keyzone.MinNote = new MusicalNote(newNote);

                                // Show current note name while dragging
                                var noteNameStyle = new GUIStyle(EditorStyles.label);
                                noteNameStyle.normal.textColor = Color.white;
                                noteNameStyle.padding = new RectOffset(4, 4, 2, 2);
                                noteNameStyle.normal.background = EditorGUIUtility.whiteTexture;
                                var dragMinContentRect = new Rect(mousePos.x, mousePos.y - 20, 50, 20);
                                GUI.color = new Color(0, 0, 0, 0.8f);
                                GUI.Label(dragMinContentRect, GetNoteName(newNote), noteNameStyle);
                                GUI.color = Color.white;
                            }
                            else if (isDraggingMax)
                            {
                                int newNote = Mathf.Clamp(dragStartNote + noteChange, keyzone.MinNote.ToMidiNoteNumber(), lowestNote + totalKeys - 1);
                                keyzone.MaxNote = new MusicalNote(newNote);

                                // Show current note name while dragging
                                var noteNameStyle = new GUIStyle(EditorStyles.label);
                                noteNameStyle.normal.textColor = Color.white;
                                noteNameStyle.padding = new RectOffset(4, 4, 2, 2);
                                noteNameStyle.normal.background = EditorGUIUtility.whiteTexture;
                                var dragMaxContentRect = new Rect(mousePos.x, mousePos.y - 20, 50, 20);
                                GUI.color = new Color(0, 0, 0, 0.8f);
                                GUI.Label(dragMaxContentRect, GetNoteName(newNote), noteNameStyle);
                                GUI.color = Color.white;
                            }

                            GUI.changed = true;
                            e.Use();
                        }
                        break;

                    case EventType.MouseUp:
                        if (activeKeyzoneIndex == i && (isDraggingMin || isDraggingMax))
                        {
                            activeKeyzoneIndex = -1;
                            isDraggingMin = false;
                            isDraggingMax = false;
                            e.Use();
                        }
                        break;
                }

                // Change cursor when hovering over handles
                if (leftHandle.Contains(mousePos) || rightHandle.Contains(mousePos))
                {
                    EditorGUIUtility.AddCursorRect(leftHandle, MouseCursor.ResizeHorizontal);
                    EditorGUIUtility.AddCursorRect(rightHandle, MouseCursor.ResizeHorizontal);
                }


                EditorGUI.DrawRect(rangeRect, GetKeyzoneColor(i));
                GUI.Box(rangeRect, GUIContent.none);

                // Draw horizontal grid lines
                if (Event.current.type == EventType.Repaint)
                {
                    Handles.color = new Color(0.5f, 0.5f, 0.5f, 0.3f);
                    Handles.DrawLine(
                        new Vector3(0, rowY),
                        new Vector3(totalPianoWidth, rowY)
                    );
                }
            }

            // Draw vertical grid lines
            if (Event.current.type == EventType.Repaint)
            {
                for (float x = 0; x <= totalPianoWidth; x += keyWidth)
                {
                    Handles.color = new Color(0.5f, 0.5f, 0.5f, 0.3f);
                    Handles.DrawLine(
                        new Vector3(x, 0),
                        new Vector3(x, totalGridHeight)
                    );
                }
            }

            GUI.EndScrollView();

            // Add spacing after the piano roll
            EditorGUILayout.Space(10);
#endif
        }
        /// <summary>
        /// Determines if a note is a black key in a 12-note octave.
        /// </summary>
        private bool IsBlackKey(int noteInOctave)
        {
            return noteInOctave == 1 || noteInOctave == 3 || noteInOctave == 6 || noteInOctave == 8 || noteInOctave == 10;
        }

        /// <summary>
        /// Returns a unique color for each keyzone row.
        /// </summary>
        private Color GetKeyzoneColor(int index)
        {
            Color[] colors = {
                new Color(1f, 0.5f, 0.5f, 0.4f), // Light red
                new Color(0.5f, 1f, 0.5f, 0.4f), // Light green
                new Color(0.5f, 0.5f, 1f, 0.4f), // Light blue
                new Color(1f, 1f, 0.5f, 0.4f),   // Light yellow
                new Color(1f, 0.5f, 1f, 0.4f)    // Light magenta
            };
            return colors[index % colors.Length];
        }

        private void Play(InstrumentCollision collision, float normalizedVelocity, double? scheduledTime = null)
        {
            var keyzonesByMicPosition = Keyzones
               .Where(k => k.Collider == collision)
               .GroupBy(k => micPositions.FirstOrDefault(pos => k.name.Contains(pos)));

            var firstKeyzone = Keyzones.FirstOrDefault(k => k.Collider == collision);
            if (firstKeyzone == null || !keyzoneToPitchQuantizer.ContainsKey(firstKeyzone)) return;

            var pq = keyzoneToPitchQuantizer[firstKeyzone];
            var note = pq.closestNote;
            if (note == -1) return;

            int midiVelocity = Mathf.RoundToInt(normalizedVelocity * 127);

            foreach (var micGroup in keyzonesByMicPosition)
            {
                string micPosition = micGroup.Key;
                if (string.IsNullOrEmpty(micPosition)) continue;

                var keyzoneToUse = KeyzoneExtensions.FindClosestKeyzone(micPosition,
                    micGroup.ToList(), note, midiVelocity, collision);

                if (keyzoneToUse == null || !keyzoneToAudioSources.TryGetValue(keyzoneToUse, out var audioSourceQueue))
                    continue;

                var audioSource = audioSourceQueue.Dequeue();
                audioSourceQueue.Enqueue(audioSource);

                var pitch = keyzoneToPitchQuantizer[keyzoneToUse].GetQuantizedPitch();
                audioSource.pitch = pitch;
                audioSource.volume = normalizedVelocity;

                if (scheduledTime.HasValue)
                {
                    audioSource.PlayScheduled(scheduledTime.Value);
                }
                else
                {
                    double dspTime = AudioSettings.dspTime + 0.1f;
                    audioSource.PlayScheduled(dspTime);
                }

                UpdateDebugUI(micPosition, keyzoneToUse, pitch, midiVelocity, pq);
            }
        }

        public void PlayOneShot(InstrumentCollision collision, float normalizedVelocity)
        {
            Play(collision, normalizedVelocity);
        }

        public void PlayScheduled(InstrumentCollision collision, float normalizedVelocity, double timeToStart)
        {
            Play(collision, normalizedVelocity, timeToStart);
        }

        private void UpdateDebugUI(string micPosition, Keyzone keyzone, float pitch, int midiVelocity, PitchQuantizer pq)
        {
            if (!showDebugText || !micPositionToDebugUI.TryGetValue(micPosition, out var debugUI))
                return;

            debugUI.SetBaseNoteText(keyzone.RootNote);
            debugUI.SetPitchAdjustText(pitch);
            debugUI.SetAdjustNoteText(pq.closestNote);
            debugUI.SetSampleText($"{micPosition}: {keyzone.AudioClip.name}");
            debugUI.SetScaleText(pq.GetNotesString());
            debugUI.SetVelocityText(midiVelocity);
            debugUI.SetRoundRobinText(keyzone.RoundRobinOrder);
        }


        private static readonly string[] NOTE_NAMES = { "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B" };
        private string GetNoteName(int midiNote)
        {
            int noteInOctave = midiNote % 12;
            int octave = (midiNote / 12) - 1; // Adjust here if necessary
            return $"{NOTE_NAMES[noteInOctave]}{octave}";
        }
    }
}