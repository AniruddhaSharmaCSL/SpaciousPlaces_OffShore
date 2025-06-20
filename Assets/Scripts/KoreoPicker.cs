using SonicBloom.Koreo;
using SonicBloom.Koreo.Players;
using System.Collections.Generic;
using UnityEngine;


namespace SpaciousPlaces
{
    public class KoreoPicker : MonoBehaviour
    {
        [SerializeField] private List<Koreography> koreographies = new List<Koreography>();

        private SimpleMusicPlayer player;
        private Koreography currentKoreo;

        private void Awake()
        {
            player = GetComponent<SimpleMusicPlayer>();
        }

        public void AddKoreographyAtIndex(int index, Koreography koreo)
        {
            koreographies.Insert(index, koreo);
        }

        public void StartCurrentKoreographyAtIndex(int index)
        {
            player.Stop();
            currentKoreo = koreographies[index];
            Koreographer.Instance.LoadKoreography(currentKoreo);
            player.LoadSong(currentKoreo);
            player.Play();

            Koreographer.Instance.RegisterForEvents("EndOfSong", onEndOfSong);
        }

        private void onEndOfSong(KoreographyEvent koreoEvent)
        {
            Debug.Log("End of song");
            Koreographer.Instance.ClearEventRegister();
            SceneLoader.Instance.LoadScene("Home", null);
        }
    }
}
