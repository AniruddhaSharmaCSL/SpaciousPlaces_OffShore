using SonicBloom.Koreo;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using VRUIP;

namespace SpaciousPlaces
{
    public class BeatQuantizationManager : MonoBehaviour
    {
        private BeatQuantizer[] beatQuantizers;

        [SerializeField]
        private OptionController BeatDivisionOptionController;

        private BeatDivision currentBeatDivision = BeatDivision.Half;
        public BeatDivision CurrentBeatDivision => currentBeatDivision;

        private bool quantizeEnabled = true;
        private bool beatDivisionNeedsUpdate = false;

        public bool QuantizeEnabled => quantizeEnabled;
        private void Start()
        {
            beatQuantizers = FindObjectsOfType<BeatQuantizer>(true);

            if (Koreographer.Instance.GetKoreographyAtIndex(0) == null)
            { 
                quantizeEnabled = false;
                BeatDivisionOptionController.gameObject.SetActive(false);
                QuantizeOff(true);
            }
            else
            {
                SetBeatDivisionFromText(BeatDivisionOptionController.CurrentOption);
            }
        }
        private void Update()
        {
            if (beatDivisionNeedsUpdate)
            {
                if (quantizeEnabled)
                {
                    SetBeatDivisionFromText(BeatDivisionOptionController.CurrentOption);
                }
                else
                {
                    SetBeatDivisionFromText("Off");
                }

                beatDivisionNeedsUpdate = false;
            }
        }

        public void SetQuantizationStrengthFromSlider(float value)
        {
            float adjustedValue = Mathf.InverseLerp(0f, 100f, value);

            foreach (var quantizer in beatQuantizers)
            {
                quantizer.QuantizeStrength = adjustedValue;
            }
        }

        public void BeatDivisionDidChange()
        {
            beatDivisionNeedsUpdate = true;
        }

        private void SetBeatDivisionFromText(string beatDivisionText)
        {
            switch (beatDivisionText)
            {
                case "1/4":
                    currentBeatDivision = BeatDivision.One;
                    break;
                case "1/8":
                    currentBeatDivision = BeatDivision.Half;
                    break;
                case "1/16":
                    currentBeatDivision = BeatDivision.Quarter;
                    break;
                case "1/32":
                    currentBeatDivision = BeatDivision.Eighth;
                    break;
                default:
                    currentBeatDivision = BeatDivision.None;
                    break;
            }

            if (quantizeEnabled)
            {
                foreach (var quantizer in beatQuantizers)
                {
                    quantizer.SetBeatDivision(quantizeEnabled ? currentBeatDivision : BeatDivision.None);
                }
            }
            else
            {
                foreach (var quantizer in beatQuantizers)
                {
                    quantizer.SetBeatDivision(BeatDivision.None);
                }
            }
        }

        public void ToggleQuantize()
        {
            quantizeEnabled = !quantizeEnabled;

            foreach (var quantizer in beatQuantizers)
            {
                quantizer.SetBeatDivision(quantizeEnabled ? currentBeatDivision : BeatDivision.None);
            }
        }

        public void QuantizeOff(bool enabled)
        {
            if (enabled)
            {
                if (beatQuantizers != null)
                {
                    foreach (var quantizer in beatQuantizers)
                    {
                        quantizer.SetBeatDivision(BeatDivision.None);
                    }
                }

                quantizeEnabled = false;
                currentBeatDivision = BeatDivision.None;
            }
            else
            {
                quantizeEnabled = true;
                beatDivisionNeedsUpdate = true;
            }
        }

        public void EnableSixteenthQuantize(bool enabled)
        {
            if (enabled)
            {
                foreach (var quantizer in beatQuantizers)
                {
                    quantizer.SetBeatDivision(BeatDivision.Sixteenth);
                }

                currentBeatDivision = BeatDivision.Sixteenth;
            }
        }
        public void EnableEighthQuantize(bool enabled)
        {
            if (enabled)
            {
                foreach (var quantizer in beatQuantizers)
                {
                    quantizer.SetBeatDivision(BeatDivision.Eighth);
                }

                currentBeatDivision = BeatDivision.Eighth;
            }
        }

        public void EnableQuarterQuantize(bool enabled)
        {
            if (enabled)
            {
                foreach (var quantizer in beatQuantizers)
                {
                    quantizer.SetBeatDivision(BeatDivision.Quarter);
                }

                currentBeatDivision = BeatDivision.Quarter;
            }
        }

        public void EnableHalfQuantize(bool enabled)
        {
            if (enabled)
            {
                foreach (var quantizer in beatQuantizers)
                {
                    quantizer.SetBeatDivision(BeatDivision.Half);
                }

                currentBeatDivision = BeatDivision.Half;
            }
        }

        public void EnableOneQuantize(bool enabled)
        {
            if (enabled)
            {
                foreach (var quantizer in beatQuantizers)
                {
                    quantizer.SetBeatDivision(BeatDivision.One);
                }

                currentBeatDivision = BeatDivision.One;
            }
        }
    }
}
