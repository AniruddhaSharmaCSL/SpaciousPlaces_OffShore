using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LaireonFramework
{
    /// <summary>
    /// This example class shows how to make a carousel that changes its screens depending on what has been unlocked
    /// 
    /// </summary>
    public class DynamicCarouselExample : MonoBehaviour
    {
        #region Variables
        public static DynamicCarouselExample Instance;

        /// <summary>
        /// All currently available characters. An index of the characters to act as an example
        /// </summary>
        public List<int> unlockedCharacters = new List<int>();

        /// <summary>
        /// A helper to know which carousel to influence
        /// </summary>
        public CharacterCarousel linkedCarousel;
        #endregion

        #region Methods
        void Start()
        {
            Instance = this;

            for (int i = 0; i < 10; i++)
                unlockedCharacters.Add(i);//start by unlocking everything
        }

        void Update()
        {
            if (Input.GetKeyDown(KeyCode.Alpha0))
                ToggleCharacterUnlock(9);

            if (Input.GetKeyDown(KeyCode.Alpha1))
                ToggleCharacterUnlock(0);

            if (Input.GetKeyDown(KeyCode.Alpha2))
                ToggleCharacterUnlock(1);

            if (Input.GetKeyDown(KeyCode.Alpha3))
                ToggleCharacterUnlock(2);

            if (Input.GetKeyDown(KeyCode.Alpha4))
                ToggleCharacterUnlock(3);

            if (Input.GetKeyDown(KeyCode.Alpha5))
                ToggleCharacterUnlock(4);

            if (Input.GetKeyDown(KeyCode.Alpha6))
                ToggleCharacterUnlock(5);

            if (Input.GetKeyDown(KeyCode.Alpha7))
                ToggleCharacterUnlock(6);

            if (Input.GetKeyDown(KeyCode.Alpha8))
                ToggleCharacterUnlock(7);

            if (Input.GetKeyDown(KeyCode.Alpha9))
                ToggleCharacterUnlock(8);
        }

        void ToggleCharacterUnlock(int index)
        {
            if (!unlockedCharacters.Contains(index))//not unlocked
                unlockedCharacters.Add(index);
            else
                unlockedCharacters.Remove(index);

            unlockedCharacters.Sort();

            linkedCarousel.screensToSpawn = unlockedCharacters.Count;
            linkedCarousel.RebuildUI();
            linkedCarousel.Reset();//reset the positions of the screens and reanimate as though we are opening the menu for the first time again
        }
        #endregion
    }
}