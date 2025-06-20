
//This script creates a new menu and a new menu items in the Editor window
// Use the new menu item to create a prefab at the given path.


using UnityEngine;
using UnityEditor;
using UnityEngine.UI;

public class ToolScript : MonoBehaviour
{
    public GameObject[] MenuPrefabs;



    // public Vector2 spwnPNT;
    public GameObject canvasMenu;

    void Start()
    {
       // GameObject munas = Instantiate(munas, new Vector2(0, 0, 0), Quaternion.identity) as GameObject;
       canvasMenu = GameObject.FindGameObjectWithTag("MainCanvas");
    }

    public void buildButton1()
    {
       // GameObject newCanvas = Instantiate(canvio) as GameObject;
        GameObject createImage = Instantiate(MenuPrefabs[0]) as GameObject;
        createImage.transform.SetParent(canvasMenu.transform, false);
        
        //Instantiate(munas, spwnPNT, Quaternion.identity);
    }


    public void buildButton2()
    {
        // GameObject newCanvas = Instantiate(canvio) as GameObject;
        GameObject createImage2 = Instantiate(MenuPrefabs[1]) as GameObject;
        createImage2.transform.SetParent(canvasMenu.transform, false);

        //Instantiate(munas, spwnPNT, Quaternion.identity);
    }


    public void buildButton3()
    {
        // GameObject newCanvas = Instantiate(canvio) as GameObject;
        GameObject createImage3 = Instantiate(MenuPrefabs[2]) as GameObject;
        createImage3.transform.SetParent(canvasMenu.transform, false);

        //Instantiate(munas, spwnPNT, Quaternion.identity);
    }


    public void buildButton4()
    {
        // GameObject newCanvas = Instantiate(canvio) as GameObject;
        GameObject createImage4 = Instantiate(MenuPrefabs[3]) as GameObject;
        createImage4.transform.SetParent(canvasMenu.transform, false);

        //Instantiate(munas, spwnPNT, Quaternion.identity);
    }
    public void buildButton5()
    {
        // GameObject newCanvas = Instantiate(canvio) as GameObject;
        GameObject createImage4 = Instantiate(MenuPrefabs[4]) as GameObject;
        createImage4.transform.SetParent(canvasMenu.transform, false);

        //Instantiate(munas, spwnPNT, Quaternion.identity);
    }
    public void buildButton6()
    {
        // GameObject newCanvas = Instantiate(canvio) as GameObject;
        GameObject createImage4 = Instantiate(MenuPrefabs[5]) as GameObject;
        createImage4.transform.SetParent(canvasMenu.transform, false);

        //Instantiate(munas, spwnPNT, Quaternion.identity);
    }
    public void buildButton7()
    {
        // GameObject newCanvas = Instantiate(canvio) as GameObject;
        GameObject createImage4 = Instantiate(MenuPrefabs[6]) as GameObject;
        createImage4.transform.SetParent(canvasMenu.transform, false);

        //Instantiate(munas, spwnPNT, Quaternion.identity);
    }
    public void buildButton8()
    {
        // GameObject newCanvas = Instantiate(canvio) as GameObject;
        GameObject createImage4 = Instantiate(MenuPrefabs[7]) as GameObject;
        createImage4.transform.SetParent(canvasMenu.transform, false);

        //Instantiate(munas, spwnPNT, Quaternion.identity);
    }
    public void buildButton9()
    {
        // GameObject newCanvas = Instantiate(canvio) as GameObject;
        GameObject createImage4 = Instantiate(MenuPrefabs[8]) as GameObject;
        createImage4.transform.SetParent(canvasMenu.transform, false);

        //Instantiate(munas, spwnPNT, Quaternion.identity);
    }
    public void buildButton10()
    {
        // GameObject newCanvas = Instantiate(canvio) as GameObject;
        GameObject createImage4 = Instantiate(MenuPrefabs[9]) as GameObject;
        createImage4.transform.SetParent(canvasMenu.transform, false);

        //Instantiate(munas, spwnPNT, Quaternion.identity);
    }



}

