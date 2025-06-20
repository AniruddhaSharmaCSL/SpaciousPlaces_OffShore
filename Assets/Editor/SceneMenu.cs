using UnityEngine;
using UnityEditor;
using UnityEngine.SceneManagement;
using UnityEditor.SceneManagement;


namespace SpaciousPlaces
{
    public static class SceneMenu
    {
        [MenuItem("Scenes/Home")]
        static void OpenHome()
        {
            OpenScene(SceneUtils.Names.Home);
        }

        [MenuItem("Scenes/MainScene")]
        static void OpenMain()
        {
            OpenScene(SceneUtils.Names.Main);
        }

        [MenuItem("Scenes/SamplerTest")]
        static void OpenSamplerTest()
        {
            OpenScene(SceneUtils.Names.SamplerTest);
        }

        [MenuItem("Scenes/IAPTest")]
        static void OpenIAPTest()
        {
            OpenScene(SceneUtils.Names.IAPTest);
        }

        static void OpenScene(string name)
        {
            if (SceneManager.GetActiveScene().isDirty)
            {
                EditorSceneManager.SaveCurrentModifiedScenesIfUserWantsTo();
            }

            else
            {
                Scene persistentScene = EditorSceneManager.OpenScene("Assets/Scenes/" + SceneUtils.Names.XRPersistency + ".unity", OpenSceneMode.Single);

                Scene currentScene = EditorSceneManager.OpenScene("Assets/Scenes/" + name + ".unity", OpenSceneMode.Additive);

                EditorSceneManager.SetActiveScene(currentScene);

                SceneUtils.AlignXRRig(currentScene);
            }
        }
    }
}
