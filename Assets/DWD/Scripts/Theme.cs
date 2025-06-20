//© Dicewrench Designs LLC 2024
//All Rights Reserved
//Last Owned by: Allen White (allen@dicewrenchdesigns.com)

using DWD.MaterialManager;
using UnityEngine;

namespace SpaciousPlaces
{
    [CreateAssetMenu(fileName = "Theme")]
    public class Theme : ScriptableObject
    {
        [Tooltip("Material Collections to Apply for this Theme.  Will apply in order starting at index 0 up...")]
        [SerializeField]
        private MaterialCollection[] _matCollections = new MaterialCollection[0];

        public void ApplyTheme()
        {
            int count = _matCollections.Length;
            for(int a = 0; a < count; a++)
            {
                MaterialCollection temp = _matCollections[a];
                if(temp != null)
                {
                    temp.ApplyAllProperties();
                }
            }
        }
    }
}