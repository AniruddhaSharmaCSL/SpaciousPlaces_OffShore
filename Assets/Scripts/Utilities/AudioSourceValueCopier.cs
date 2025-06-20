using UnityEngine;

public static class AudioSourceCopier
{
    public struct CopyOptions
    {
        public bool copyClip;
        public bool copyVolume;
        public bool copyPitch;
        public bool copySpatialSettings;
        public bool copyEffects;

        public static CopyOptions All => new CopyOptions
        {
            copyClip = true,
            copyVolume = true,
            copyPitch = true,
            copySpatialSettings = true,
            copyEffects = true
        };
    }

    /// <summary>
    /// Copies values from one AudioSource to another based on specified options
    /// </summary>
    /// <param name="source">Source AudioSource to copy from</param>
    /// <param name="target">Target AudioSource to copy to</param>
    /// <param name="options">Options specifying which properties to copy</param>
    /// <returns>True if copy was successful, false if either source or target is null</returns>
    public static bool CopyValues(AudioSource source, AudioSource target, CopyOptions options)
    {
        if (source == null || target == null)
        {
            Debug.LogError("Source or target AudioSource is null!");
            return false;
        }

        if (options.copyClip)
        {
            target.clip = source.clip;
        }

        if (options.copyVolume)
        {
            target.volume = source.volume;
            target.mute = source.mute;
        }

        if (options.copyPitch)
        {
            target.pitch = source.pitch;
        }

        if (options.copySpatialSettings)
        {
            // 3D Sound Settings
            target.spatialBlend = source.spatialBlend;
            target.spatialize = source.spatialize;
            target.spatializePostEffects = source.spatializePostEffects;
            target.minDistance = source.minDistance;
            target.maxDistance = source.maxDistance;
            target.rolloffMode = source.rolloffMode;
            target.dopplerLevel = source.dopplerLevel;
            target.spread = source.spread;
        }

        if (options.copyEffects)
        {
            // Effect Settings
            target.bypassEffects = source.bypassEffects;
            target.bypassListenerEffects = source.bypassListenerEffects;
            target.bypassReverbZones = source.bypassReverbZones;
            target.priority = source.priority;
            target.reverbZoneMix = source.reverbZoneMix;
        }

        return true;
    }

    /// <summary>
    /// Copies all values from one AudioSource to another
    /// </summary>
    /// <param name="source">Source AudioSource to copy from</param>
    /// <param name="target">Target AudioSource to copy to</param>
    /// <returns>True if copy was successful, false if either source or target is null</returns>
    public static bool CopyAllValues(AudioSource source, AudioSource target)
    {
        return CopyValues(source, target, CopyOptions.All);
    }
}