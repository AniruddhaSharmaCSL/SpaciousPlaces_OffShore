using UnityEngine;

public class AudioSourceMonitor : MonoBehaviour
{
    private AudioSource[] allAudioSources;
    private int totalSources;
    private int activeSources;

    void Update()
    {
        allAudioSources = FindObjectsOfType<AudioSource>();
        totalSources = allAudioSources.Length;

        activeSources = 0;
        foreach (AudioSource source in allAudioSources)
        {
            if (source.isPlaying)
            {
                activeSources++;
            }
        }

        //Debug.Log($"Total Audio Sources: {totalSources}, Currently Playing: {activeSources}");
    }

    void OnGUI()
    {
        GUI.Label(new Rect(10, 10, 300, 20), $"Total Audio Sources: {totalSources}");
        GUI.Label(new Rect(10, 30, 300, 20), $"Currently Playing: {activeSources}");
    }
}