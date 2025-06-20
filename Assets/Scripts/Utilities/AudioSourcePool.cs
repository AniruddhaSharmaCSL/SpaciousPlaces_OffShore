using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioSourcePool : MonoBehaviour
{
    private AudioSource[] audioSources;

    public GameObject audioSourcePrefab;
    [SerializeField] int AudioSourceQueueSize = 4;

    void Awake()
    {
        audioSources = new AudioSource[AudioSourceQueueSize];

        for (int i = 0; i < AudioSourceQueueSize; i++)
        {
            GameObject child = Instantiate(audioSourcePrefab, transform);
            audioSources[i] = child.GetComponent<AudioSource>();
        }
    }

    public AudioSource BaseAudioSource()
    {
        return audioSources[0];
    }

    public AudioSource NextAudioSource()
    {
        for (int i = 0; i < audioSources.Length; i++)
        {
            if (!audioSources[i].isPlaying)
            {
                return audioSources[i];
            }
        }

        return null;
    }
}
