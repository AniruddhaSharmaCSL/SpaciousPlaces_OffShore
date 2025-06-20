using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using System;
using SpaciousPlaces;

public class SamplerDebugUI : MonoBehaviour
{
    [SerializeField] TMP_Text scaleText;
    [SerializeField] TMP_Text baseNoteText;
    [SerializeField] TMP_Text adjustNoteText;
    [SerializeField] TMP_Text sampleText;
    [SerializeField] TMP_Text pitchAdjustText;
    [SerializeField] TMP_Text velocityText;
    [SerializeField] TMP_Text roundRobinText;

    // Setters
    public void SetScaleText(string text)
    {
        if (scaleText != null)
            scaleText.text = $"Scale: {text}";
    }

    public void SetBaseNoteText(string text)
    {
        if (baseNoteText != null)
            baseNoteText.text = $"Root Note: {text}";
    }

    public void SetBaseNoteText(int midiNote)
    {
        if (baseNoteText != null)
            baseNoteText.text = $"Root Note: {midiNote} " + MidiNoteConverter.MidiNoteToString(midiNote);
    }

    public void SetAdjustNoteText(string midiNote)
    {
        if (adjustNoteText != null)
            adjustNoteText.text = $"Target Note: {midiNote}";
    }

    public void SetAdjustNoteText(int midiNote)
    {
        if (adjustNoteText != null)
            adjustNoteText.text = $"Target Note: {midiNote} " + MidiNoteConverter.MidiNoteToString(midiNote);
    }

    public void SetSampleText(string sample)
    {
        if (sampleText != null)
            sampleText.text = $"Sample: {sample}";
    }

    public void SetPitchAdjustText(float pitchAdjust)
    {
        if (pitchAdjustText != null)
            pitchAdjustText.text = $"Pitch Adjust: {pitchAdjust:F2}";
    }

    public void SetVelocityText(int velocity)
    {
        if (velocityText != null)
            velocityText.text = $"Vel: {velocity}";
    }

    public void SetRoundRobinText(int roundRobin)
    {
        if (roundRobinText != null)
            roundRobinText.text = $"RR: {roundRobin}";
    }
    // Getters
    public string GetScaleText()
    {
        if (scaleText == null || string.IsNullOrEmpty(scaleText.text)) return "";
        return scaleText.text.Replace("Scale: ", "");
    }

    public int GetBaseNote()
    {
        if (baseNoteText == null || string.IsNullOrEmpty(baseNoteText.text)) return 0;
        string numberStr = baseNoteText.text.Replace("Base Note: ", "");
        return int.TryParse(numberStr, out int result) ? result : 0;
    }

    public int GetAdjustNote()
    {
        if (adjustNoteText == null || string.IsNullOrEmpty(adjustNoteText.text)) return 0;
        string numberStr = adjustNoteText.text.Replace("Adjust Note: ", "");
        return int.TryParse(numberStr, out int result) ? result : 0;
    }

    public int GetScaleNote()
    {
        if (sampleText == null || string.IsNullOrEmpty(sampleText.text)) return 0;
        string numberStr = sampleText.text.Replace("Scale Note: ", "");
        return int.TryParse(numberStr, out int result) ? result : 0;
    }

    public float GetPitchAdjust()
    {
        if (pitchAdjustText == null || string.IsNullOrEmpty(pitchAdjustText.text)) return 0f;
        string numberStr = pitchAdjustText.text.Replace("Pitch Adjust: ", "");
        return float.TryParse(numberStr, out float result) ? result : 0f;
    }
}