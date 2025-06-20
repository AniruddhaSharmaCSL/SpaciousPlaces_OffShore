using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace SpaciousPlaces
{
    public class GotoScene : Singleton<GotoScene>
    {
        public SceneUtils.SceneId nextScene = SceneUtils.SceneId.Home;
        [SerializeField] SPLevel level;

        public void Go(SPLevel level)
        {
            string scene = null;

            switch (level.scene)
            {
                case SceneUtils.SceneId.Main:
                    scene = SceneUtils.scenes[(int)SceneUtils.SceneId.Main];
                    break;

                case SceneUtils.SceneId.IAPTest:
                    scene = SceneUtils.scenes[(int)SceneUtils.SceneId.IAPTest];
                    break;

                case SceneUtils.SceneId.SamplerTest:
                    scene = SceneUtils.scenes[(int)SceneUtils.SceneId.SamplerTest];
                    break;
            }

            if (scene != null)
            {
                SceneLoader.Instance.LoadScene(scene, level);
            }
        }
    }
}
