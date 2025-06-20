//** Gameshard Studio **\\
               // Bio Lab Card Game Template \\
                                 //THIS SCRIPT USED FOR CAMERA TEXTURE DEPTH

using UnityEngine;
[ExecuteInEditMode]
public class EnableDepthTexture : MonoBehaviour
{
    void Start()
    {
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
    }
}
