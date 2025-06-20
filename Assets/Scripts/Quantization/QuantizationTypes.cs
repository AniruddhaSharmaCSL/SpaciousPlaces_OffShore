

using System.Collections.Generic;
using UnityEngine;


namespace SpaciousPlaces
{
    [System.Serializable]

    public enum BeatDivision
    {
        None = 0,
        One = 1,
        Half = 2,
        Quarter = 4,
        Eighth = 8,
        Sixteenth = 16
    };

    public static class QuantizationTypes
    {
        public static string BeatDivisionEventID(BeatDivision beatDivision)
        {
            switch (beatDivision)
            {
                case BeatDivision.One:
                    return "One";
                case BeatDivision.Half:
                    return "Half";
                case BeatDivision.Quarter:
                    return "Quarter";
                case BeatDivision.Eighth:
                    return "Eighth";
                case BeatDivision.Sixteenth:
                    return "Sixteenth";
                default:
                    return null;
            }
        }

        public static string BeatDivisionTrackId(BeatDivision division)
        {
            switch (division)
            {
                case BeatDivision.One:
                    return "One";
                case BeatDivision.Half:
                    return "Half";
                case BeatDivision.Quarter:
                    return "Quarter";
                case BeatDivision.Eighth:
                    return "Eighth";
                case BeatDivision.Sixteenth:
                    return "Sixteenth";
                default:
                    return "One";
            }
        }

        public static int BeatsPerDivision(BeatDivision division)
        {
            switch (division)
            {
                case BeatDivision.One:
                    return 1;
                case BeatDivision.Half:
                    return 2;
                case BeatDivision.Quarter:
                    return 4;
                case BeatDivision.Eighth:
                    return 8;
                case BeatDivision.Sixteenth:
                    return 16;
                default:
                    return 1;
            }
        }
    }
}
