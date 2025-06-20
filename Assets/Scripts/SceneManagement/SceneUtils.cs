using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace SpaciousPlaces
{
    public static class SceneUtils
    {
        [System.Serializable]
        public enum SceneId
        {
            Home,
            Main,
            SamplerTest,
            IAPTest
        }

        public static readonly string[] scenes = { Names.Home, Names.Main, Names.SamplerTest, Names.IAPTest };

        public static class Names
        {
            public static readonly string XRPersistency = "XRPersistency";
            public static readonly string Home = "Home";
            public static readonly string Main = "MainScene";
            public static readonly string SamplerTest = "SamplerTest";
            public static readonly string IAPTest = "IAPTest";
        }

        public static void AlignXRRig(Scene currentScene)
        {
            var rigOrigin = GetRigOrigin(currentScene);
            Transform target = rigOrigin.transform;

            var rig = GetRig();

            if (rig != null)
            {
                var ovrCameraRig = rig.GetComponentInChildren<OVRCameraRig>();
                var centerEyeAnchor = ovrCameraRig.centerEyeAnchor;

                // camera position will likely be different from the rig position, so we need to calculate the offset
                Vector3 offset = centerEyeAnchor.position - rig.position;
                offset.y = 0;
                rig.position = target.position - offset;

                Vector3 targetForward = target.forward;
                targetForward.y = 0;
                Vector3 cameraForward = centerEyeAnchor.forward;
                cameraForward.y = 0;

                float angle = Vector3.SignedAngle(cameraForward, targetForward, Vector3.up);

                rig.RotateAround(centerEyeAnchor.position, Vector3.up, angle);
            }

            Debug.Log("Didn't move rig");
        }

        public static Transform GetRig()
        {
            Scene persistentScene = SceneManager.GetSceneByName(Names.XRPersistency);
            GameObject[] persistentObjects = persistentScene.GetRootGameObjects();

            foreach (var rig in persistentObjects)
            {
                if (rig.CompareTag("XR Rig"))
                {
                    return rig.transform;
                }
            }

            return null;
        }

        public static Transform GetRigOrigin(Scene currentScene)
        {
            GameObject[] currentObjects = currentScene.GetRootGameObjects();

            foreach (var rigOrigin in currentObjects)
            {
                if (rigOrigin.CompareTag("XR Rig Origin"))
                {
                    return rigOrigin.transform;
                }
            }

            Debug.Log("rig origin not found");

            return null;
        }

        public static Vector3 GetRigPosition(Scene persistentScene)
        {
            GameObject[] persistentObjects = persistentScene.GetRootGameObjects();

            foreach (var rig in persistentObjects)
            {
                if (rig.CompareTag("XR Rig"))
                {
                    return rig.transform.position;
                }
            }

            Debug.Log("rig not found");

            return Vector3.zero;
        }

        public static void LoadLevelData(Scene currentScene, SPLevel level)
        {
            GameObject[] currentObjects = currentScene.GetRootGameObjects();
            foreach (var obj in currentObjects)
            {
                if (obj.CompareTag("Level Loader"))
                {
                    obj.GetComponent<LevelLoader>().LoadLevelData(level);
                    return;
                }
            }
        }
    }
}
