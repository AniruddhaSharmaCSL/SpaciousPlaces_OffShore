using SpaciousPlaces;
using System.Collections.Generic;
using UnityEngine.Audio;
using UnityEngine;
using System.Linq;

public class KeyzoneAudioSourcePool
{
    private List<AudioSource> sources = new List<AudioSource>();
    private GameObject parent;

    public KeyzoneAudioSourcePool(GameObject parent, AudioSource template, AudioMixerGroup mixer, int poolSize)
    {
        this.parent = parent;
        for (int i = 0; i < poolSize; i++)
        {
            sources.Add(CreateSource(mixer));
        }
    }

    private AudioSource CreateSource(AudioMixerGroup mixer)
    {
        var source = parent.AddComponent<AudioSource>();
        source.outputAudioMixerGroup = mixer;
        source.playOnAwake = false;
       
       // availableSources.Enqueue(source);
        return source;
    }

    private int currentIndex = 0;

    public AudioSource GetNext()
    {
        var source = sources[currentIndex];
        currentIndex = (currentIndex + 1) % sources.Count;
        return source;
    }
}