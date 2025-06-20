
//** Gameshard Studio **\\
             // Bio Lab Card Game Template \\
                               //THIS SCRIPT USED FOR WATER TUBE OFFSET MAP

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TubeWaterOffset : MonoBehaviour {


    public float ScrollX = 0.5F;
    public float ScrollY = 0.5F;

    Material thisMat;
    Color c;
    public float value;

    public Renderer rend;

    void Start()
    {
        rend = GetComponent<Renderer>();
    }
    void Update()
    {
        float OffsetY = Time.time * ScrollY;
        float OffsetX = Time.time * ScrollX;
        rend.material.SetTextureOffset("_MainTex", new Vector2(OffsetX, OffsetY));

    }
}