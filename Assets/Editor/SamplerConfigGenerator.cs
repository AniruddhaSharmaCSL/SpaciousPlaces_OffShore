using UnityEngine;
using UnityEditor;
using System.IO;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Linq;
using System;
using SpaciousPlaces;
using UnityEngine.Audio;

namespace SpaciousPlaces
{
    public class SamplerConfigGenerator : EditorWindow
    {
        private const int LOWEST_NOTE = 21;  // A0
        private const int HIGHEST_NOTE = 96; // C7

        private GameObject targetGameObject;
        private string selectedFolderPath = "";
        private Vector2 scrollPosition;
        private AudioMixerGroup samplerMixerGroup;

        [MenuItem("Tools/Setup Sampler")]
        public static void ShowWindow()
        {
            GetWindow<SamplerConfigGenerator>("Sampler Setup");
        }

        void OnGUI()
        {
            scrollPosition = EditorGUILayout.BeginScrollView(scrollPosition);

            GUILayout.Label("Sampler Setup", EditorStyles.boldLabel);

            targetGameObject = EditorGUILayout.ObjectField(
                "Target GameObject",
                targetGameObject,
                typeof(GameObject),
                true) as GameObject;

            samplerMixerGroup = EditorGUILayout.ObjectField(
                "Sampler Mixer Group",
                samplerMixerGroup,
                typeof(AudioMixerGroup),
                false) as AudioMixerGroup;

            EditorGUILayout.Space();

            // Folder selection
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Audio Files Folder:", selectedFolderPath);
            if (GUILayout.Button("Browse", GUILayout.Width(60)))
            {
                string newPath = EditorUtility.OpenFolderPanel("Select Audio Files Folder", "Assets", "");
                if (!string.IsNullOrEmpty(newPath))
                {
                    selectedFolderPath = GetRelativePath(newPath);
                }
            }
            EditorGUILayout.EndHorizontal();

            // Search pattern field
            EditorGUILayout.HelpBox("Files should follow pattern: [InstrumentName]_hit_Close_C4_vl1_rr1\nWhere:\n- [InstrumentName] is the name of your instrument\n- hit is the name of the articulation\n- Close/OH/Room etc. is the mic position\n- C4/G#3 etc. is the note\n- vl1/vl2 etc. is the velocity layer\n- rr1/rr2 etc. is the round robin variation", MessageType.Info);

            EditorGUILayout.Space();

            GUI.enabled = targetGameObject != null && !string.IsNullOrEmpty(selectedFolderPath) && samplerMixerGroup != null;
            if (GUILayout.Button("Generate Keyzones and Setup Sampler"))
            {
                if (targetGameObject == null)
                {
                    EditorUtility.DisplayDialog("Error", "Please select a target GameObject", "OK");
                    return;
                }
                if (string.IsNullOrEmpty(selectedFolderPath))
                {
                    EditorUtility.DisplayDialog("Error", "Please select an audio files folder", "OK");
                    return;
                }
                if (samplerMixerGroup == null)
                {
                    EditorUtility.DisplayDialog("Error", "Please assign a Sampler Mixer Group", "OK");
                    return;
                }
                SetupSampler();
            }
            GUI.enabled = true;

            EditorGUILayout.EndScrollView();
        }

        private string GetRelativePath(string absolutePath)
        {
            if (absolutePath.StartsWith(Application.dataPath))
            {
                return "Assets" + absolutePath.Substring(Application.dataPath.Length);
            }
            return absolutePath;
        }

        private void SetupSampler()
        {
            // Ensure we have a Sampler component
            var sampler = targetGameObject.GetComponent<Sampler>();
            if (sampler == null)
            {
                sampler = targetGameObject.AddComponent<Sampler>();
            }

            // Get InstrumentCollision components
            var colliders = targetGameObject.GetComponentsInChildren<InstrumentCollision>()
                .OrderBy(c => c.transform.GetSiblingIndex())
                .ToArray();

            // Create a "Keyzones" child object if it doesn't exist
            Transform keyzonesParent = targetGameObject.transform.Find("Keyzones");
            if (keyzonesParent == null)
            {
                var keyzonesObj = new GameObject("Keyzones");
                keyzonesParent = keyzonesObj.transform;
                keyzonesParent.SetParent(targetGameObject.transform);
            }

            // Clear existing keyzones
            foreach (var existingKeyzone in keyzonesParent.GetComponentsInChildren<Keyzone>())
            {
                DestroyImmediate(existingKeyzone.gameObject);
            }

            // Find audio files
            string[] guids = AssetDatabase.FindAssets("t:AudioClip", new[] { selectedFolderPath });
            var paths = guids
                .Select(guid => AssetDatabase.GUIDToAssetPath(guid))
                .Where(path => Path.GetFileName(path).EndsWith(".wav") || Path.GetFileName(path).EndsWith(".mp3") || Path.GetFileName(path).EndsWith(".ogg") || Path.GetFileName(path).EndsWith(".flac"))
                .ToList();

            if (paths.Count == 0)
            {
                EditorUtility.DisplayDialog("Error", "No audio files found matching the pattern", "OK");
                return;
            }

            // Parse sample information with mic positions
            var samples = new List<(string micPosition, string note, int velocity, int roundRobin, string path, string articulation)>();
            var regex = new Regex(@"(\w+)_(\w+)_(\w+)_([A-G][#b]?\d)_vl(\d+)_rr(\d+)", RegexOptions.IgnoreCase);

            Debug.Log("\n=== File Analysis ===");
            foreach (string path in paths)
            {
                string filename = Path.GetFileNameWithoutExtension(path);
                Debug.Log($"\nAnalyzing file: {filename}");

                Match match = regex.Match(filename);
                if (!match.Success)
                {
                    Debug.LogWarning($"  No match for regex pattern!");
                    continue;
                }

                string articulation = match.Groups[2].Value;
                string micPosition = match.Groups[3].Value;
                string note = match.Groups[4].Value;
                int velocity = int.Parse(match.Groups[5].Value);
                int rr = int.Parse(match.Groups[6].Value);

                Debug.Log($"  Extracted: mic={micPosition}, note={note}, vel={velocity}, rr={rr}, articulation={articulation}");
                samples.Add((micPosition, note, velocity, rr, path, articulation));
            }

            // Create mixer groups for each mic position
            var micPositions = samples.Select(s => s.micPosition).Distinct().ToList();
            sampler.micPositions = micPositions.ToArray();

            var micMixerGroups = new Dictionary<string, AudioMixerGroup>();

            Debug.Log("=== Sample Analysis ===");
            Debug.Log($"Found these mic positions in samples: {string.Join(", ", micPositions)}");
            foreach (var sample in samples.Take(5))
            {
                Debug.Log($"Sample example: {Path.GetFileNameWithoutExtension(sample.path)} -> mic pos: '{sample.micPosition}'");
            }

            Debug.Log("\n=== Mixer Group Analysis ===");
            Debug.Log($"Looking for mic positions under parent group: {samplerMixerGroup.name}");

            // Only get groups that are children of our sampler mixer group
            var relevantGroups = samplerMixerGroup.audioMixer
                .FindMatchingGroups($"{samplerMixerGroup.name}/")
                .Where(g => g != samplerMixerGroup) // Exclude the parent group itself
                .ToArray();

            Debug.Log($"Found {relevantGroups.Length} subgroups under {samplerMixerGroup.name}:");
            Debug.Log("\nAvailable mixer subgroups:");
            foreach (var group in relevantGroups)
            {
                Debug.Log($"  Subgroup name: '{group.name}'");
            }

            Debug.Log("\nAttempting matches:");
            foreach (var micPosition in micPositions)
            {
                foreach (var group in relevantGroups)
                {
                    Debug.Log($"  Comparing mic position '{micPosition}' with group '{group.name}' - match: {group.name.Equals(micPosition, StringComparison.OrdinalIgnoreCase)}");
                }
            }

            foreach (var micPosition in micPositions)
            {
                try
                {
                    // Look for an exact match in the subgroups
                    var matchingGroup = relevantGroups.FirstOrDefault(g =>
                        g.name.Equals(micPosition, StringComparison.OrdinalIgnoreCase));

                    if (matchingGroup != null)
                    {
                        micMixerGroups[micPosition] = matchingGroup;
                        Debug.Log($"Found mixer group for position: {micPosition}");
                    }
                    else
                    {
                        Debug.LogWarning($"No mixer group found for position: {micPosition} under {samplerMixerGroup.name}");
                        continue;
                    }
                }
                catch (Exception ex)
                {
                    Debug.LogError($"Error finding mixer group for position {micPosition}: {ex.Message}");
                    continue;
                }
            }

            // Group by note and calculate ranges
            var groupedByNote = samples
                .GroupBy(s => s.note)
                .OrderBy(g => MidiNoteConverter.StringToMidiNote(g.Key))
                .ToList();

            // Calculate note ranges
            var noteRangeMapping = CalculateNoteRanges(groupedByNote);

            // Create Keyzones
            var keyZoneComponents = new List<Keyzone>();
            int colliderIndex = 0;

            Undo.RegisterFullObjectHierarchyUndo(targetGameObject, "Create Keyzones");

            try
            {
                EditorUtility.DisplayProgressBar("Creating Keyzones", "Processing...", 0f);
                int totalNotes = groupedByNote.Count;
                int noteIndex = 0;

                foreach (var noteGroup in groupedByNote)
                {
                    string note = noteGroup.Key;
                    var (minMidiNote, maxMidiNote) = noteRangeMapping[note];

                    // Get collider for this note group
                    InstrumentCollision assignedCollider = colliderIndex < colliders.Length ?
                        colliders[colliderIndex++] : null;

                    // Group by mic position
                    var micPositionGroups = noteGroup.GroupBy(s => s.micPosition);

                    foreach (var micGroup in micPositionGroups)
                    {
                        string micPosition = micGroup.Key;
                        var velocityGroups = micGroup.GroupBy(s => s.velocity).ToList();

                        // Calculate velocity ranges more flexibly
                        var velocitiesSorted = velocityGroups.Select(g => g.Key).Distinct().OrderBy(v => v).ToList();
                        int velocityGroupCount = velocitiesSorted.Count;
                        int velocityRangeSize = 128 / velocityGroupCount; // Total MIDI range (0-127) divided by number of groups

                        for (int vIdx = 0; vIdx < velocitiesSorted.Count; vIdx++)
                        {
                            int currentVelocity = velocitiesSorted[vIdx];

                            // Calculate evenly distributed velocity ranges
                            int minVelocity = vIdx * velocityRangeSize;
                            int maxVelocity;

                            if (vIdx == velocitiesSorted.Count - 1)
                            {
                                // Last group gets any remaining values
                                maxVelocity = 127;
                            }
                            else
                            {
                                maxVelocity = ((vIdx + 1) * velocityRangeSize) - 1;
                            }

                            var samplesForVelocity = velocityGroups.FirstOrDefault(g => g.Key == currentVelocity);

                            if (samplesForVelocity != null)
                            {
                                foreach (var sample in samplesForVelocity.OrderBy(s => s.roundRobin))
                                {
                                    // Skip if we don't have a mixer group for this mic position
                                    if (!micMixerGroups.ContainsKey(micPosition))
                                    {
                                        Debug.LogWarning($"Skipping keyzone creation for {micPosition} - no mixer group found");
                                        continue;
                                    }

                                    var keyzoneObj = new GameObject(
                                        $"Keyzone_{sample.articulation}_{micPosition}_{sample.note}_vl{sample.velocity}_rr{sample.roundRobin}");
                                    keyzoneObj.transform.SetParent(keyzonesParent);

                                    // Add and configure Keyzone component
                                    var keyzone = keyzoneObj.AddComponent<Keyzone>();
                                    keyzone.EditorSetup(
                                        collider: assignedCollider,
                                        clip: AssetDatabase.LoadAssetAtPath<AudioClip>(sample.path),
                                        root: new MusicalNote(note),
                                        min: new MusicalNote(minMidiNote),
                                        max: new MusicalNote(maxMidiNote),
                                        minVel: minVelocity,
                                        maxVel: maxVelocity,
                                        roundRobin: sample.roundRobin - 1,
                                        mixerGroup: micMixerGroups[micPosition],
                                        articulation: sample.articulation
                                    );

                                    keyZoneComponents.Add(keyzone);
                                }
                            }
                        }
                    }

                    EditorUtility.DisplayProgressBar("Creating Keyzones",
                        $"Processing note {note}...",
                        (float)++noteIndex / totalNotes);
                }

                // Update Sampler's keyzone list
                sampler.Keyzones = keyZoneComponents;
                EditorUtility.SetDirty(sampler);

                Debug.Log($"Created {keyZoneComponents.Count} keyzones across {micPositions.Count} mic positions");
                EditorUtility.DisplayDialog("Success",
                    $"Successfully created {keyZoneComponents.Count} keyzones across {micPositions.Count} mic positions!", "OK");
            }
            finally
            {
                EditorUtility.ClearProgressBar();
            }
        }

        private Dictionary<string, (int minNote, int maxNote)> CalculateNoteRanges(
            List<IGrouping<string, (string micPosition, string note, int velocity, int roundRobin, string path, string articulation)>> groupedByNote)
        {
            var noteRangeMapping = new Dictionary<string, (int minNote, int maxNote)>();

            for (int i = 0; i < groupedByNote.Count; i++)
            {
                int rootMidiNote = MidiNoteConverter.StringToMidiNote(groupedByNote[i].Key);

                // Calculate min note
                int minNote = i == 0 ? LOWEST_NOTE :
                    noteRangeMapping[groupedByNote[i - 1].Key].maxNote + 1;

                // Calculate max note
                int maxNote;
                if (i == groupedByNote.Count - 1)
                {
                    maxNote = HIGHEST_NOTE;
                }
                else
                {
                    int nextRootMidiNote = MidiNoteConverter.StringToMidiNote(groupedByNote[i + 1].Key);
                    maxNote = rootMidiNote + (nextRootMidiNote - rootMidiNote) / 2;
                }

                noteRangeMapping[groupedByNote[i].Key] = (
                    Mathf.Clamp(minNote, LOWEST_NOTE, HIGHEST_NOTE),
                    Mathf.Clamp(maxNote, LOWEST_NOTE, HIGHEST_NOTE)
                );
            }

            return noteRangeMapping;
        }
    }
        public static class AudioMixerGroupExtensions
        {
            public static string GetPath(this AudioMixer mixer, AudioMixerGroup group)
            {
                if (group == null) return "";

                var current = group;
                var path = new System.Text.StringBuilder(group.name);

                while (true)
                {
                    var parentProperty = new SerializedObject(current)
                        .FindProperty("m_Parent")?.objectReferenceValue as AudioMixerGroup;

                    if (parentProperty == null) break;

                    path.Insert(0, parentProperty.name + "/");
                    current = parentProperty;
                }

                return path.ToString();
            }
        }
    }
    