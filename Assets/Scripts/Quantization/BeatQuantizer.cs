using SonicBloom.Koreo;
using SonicBloom.Koreo.Players;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace SpaciousPlaces
{
    public class BeatQuantizer : MonoBehaviour
    {
        [SerializeField] public UnityEvent<KoreographyEvent> OnPlay;

        [SerializeField] public float QuantizeStrength = 1.0f;

        [SerializeField] public int Delay = 0;

        [SerializeField] TMPro.TMP_Text missText;
        [SerializeField] TMPro.TMP_Text doublesText;
        [SerializeField] TMPro.TMP_Text doublesTwoText;

        private BeatDivision beatDivision = BeatDivision.Half;

        private double lastPlayTime = 0;
        private CircularBuffer<int> samples = new CircularBuffer<int>(32);

        private int misses = 0;
        private int doubles = 0;
        private int doublesTwo = 0;

        private Koreography koreography;
        private KoreographyTrackBase track;
        private List<KoreographyEvent> events = new List<KoreographyEvent>();
        private AudioSourceVisor visor;
        private float sampleRate;
        private TempoSectionDef tempoSection;
        private int currentDelay = 0;
        private int sampleTimeQuantizationLength;

        private void Start()
        {
            koreography = Koreographer.Instance.GetKoreographyAtIndex(0);

            if (koreography != null)
            {
                visor = Koreographer.Instance.GetComponent<AudioSourceVisor>();
                sampleRate = koreography.SourceClip.frequency;
                tempoSection = koreography.GetTempoSectionAtIndex(0);
                SetBeatDivision(beatDivision);
                track = koreography.GetTrackByID(QuantizationTypes.BeatDivisionTrackId(beatDivision));
            }

            if (!canQuantize())
            {
                SetBeatDivision(BeatDivision.None);
                Debug.Log("No Koreography found. Free play!");
                return;
            }
        }

        private void Update()
        {
            if (missText != null)
            {
                missText.text = "Miss?: " + misses;
            }

            if (doublesText != null)
            {
                doublesText.text = "Double?: " + doubles;
            }

            if (doublesTwoText != null)
            {
                doublesTwoText.text = "Double??: " + doublesTwo;
            }
        }

        public void StartQuantize()
        {
            if (canQuantize())
            {
                SetBeatDivision(beatDivision);
            }
        }

        public void StopQuantize()
        {
            Koreographer.Instance.UnregisterForAllEvents(this);
        }

        public BeatDivision GetBeatDivision()
        {
            return beatDivision;
        }

        public void SetBeatDivision(BeatDivision beatDivision)
        {
            if (!canQuantize())
            {
                this.beatDivision = BeatDivision.None;
                Debug.Log("No Koreography found. Cant set beat division!");
                return;
            }
            else
            {
                Debug.Log("setting beat division: " + beatDivision);
            }

            this.beatDivision = beatDivision;

            Koreographer.Instance.UnregisterForAllEvents(this);

            switch (beatDivision)
            {
                case BeatDivision.One:
                    Koreographer.Instance.RegisterForEvents("One", Play);
                    break;
                case BeatDivision.Half:
                    Koreographer.Instance.RegisterForEvents("Half", Play);
                    break;
                case BeatDivision.Quarter:
                    Koreographer.Instance.RegisterForEvents("Quarter", Play);
                    break;
                case BeatDivision.Eighth:
                    Koreographer.Instance.RegisterForEvents("Eighth", Play);
                    break;
                case BeatDivision.Sixteenth:
                    Koreographer.Instance.RegisterForEvents("Sixteenth", Play);
                    break;
                default:
                    break;
            }

            sampleTimeQuantizationLength = (int)(tempoSection.SamplesPerBeat / (double)QuantizationTypes.BeatsPerDivision(beatDivision));
            track = koreography.GetTrackByID(QuantizationTypes.BeatDivisionTrackId(beatDivision));
        }

        public double NextPlayTime()
        {
            var latestSampleTime = koreography.GetLatestSampleTime();
            //  Debug.Log("latest sample time: " + latestSampleTime);
            int lookAheadTime = sampleTimeQuantizationLength + koreography.GetLatestSampleTimeDelta();
            events.Clear();
            track.GetEventsInRange(latestSampleTime, latestSampleTime + lookAheadTime, events);
            // Debug.Log("events: " + events.Count);

            if (events.Count > 0)
            {
                int i = 0;
                int startSample = events[i].StartSample;
                // Debug.Log("next event: " + startSample);

                while (samples.GetIndexByValue(startSample) != -1)
                {
                    if (i < events.Count - 1)
                    {
                        i++;
                        startSample = events[i].StartSample;
                    }
                    else
                    {
                        // Debug.Log("no valid next event");
                        misses++;
                        return -1;
                    }
                }

                if (i > 0)
                {
                    doubles++;
                }

                if (events.Count > 1)
                {
                    doublesTwo++;
                }

                samples.Add(startSample);

                var nextEventTime = visor.ScheduledPlayTime + (startSample / sampleRate);
                // Debug.Log("scheduledplaytime: " + visor.ScheduledPlayTime);
                // Debug.Log("next event time: " + nextEventTime);
                //  Debug.Log("next start sample time: " + startSample);

                var currentDspTime = AudioSettings.dspTime;
                //  Debug.Log("current dsp time: " + currentDspTime);
                var nextPlayTime = currentDspTime + (nextEventTime - currentDspTime) * QuantizeStrength;
                //  Debug.Log("next play time: " + nextPlayTime);

                lastPlayTime = nextPlayTime;

                return nextPlayTime;
            }

            return -1; // Event not found
        }

        private void Play(KoreographyEvent koreoEvent)
        {
            if (OnPlay == null)
            {
                return;
            }

            if (currentDelay < Delay)
            {
                currentDelay++;
                return;
            }

            currentDelay = 0;

            OnPlay.Invoke(koreoEvent);
        }

        private bool canQuantize()
        {
            return koreography != null;
        }
    }
}
