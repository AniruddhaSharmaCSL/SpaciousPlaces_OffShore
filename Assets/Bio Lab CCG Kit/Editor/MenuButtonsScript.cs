
//** Gameshard Studio **\\
                   // Bio Lab Card Game Template \\
                                 //THIS SCRIPT USED FOR TOOL MENU BUTTONS

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;


public class MenuButtonsScript : ScriptableWizard {

#pragma warning disable 0219

    private static ToolScript myScript;
    public GameObject canvasMenu;

    [MenuItem("Gameshard/Create Main Canvas")]


    private static void CreateCanvas()
    {
        DisplayWizard<MenuButtonsScript>("Create Canvas", "Create new");

    }

    // Use this for initialization
    [MenuItem("Gameshard/Create UI Buttons/Create Settings Button")]


    private static void CreateButtons()
    {
        GameObject canvasMenu = GameObject.Find("Main Canvas");
        ToolScript scriptToAccess = canvasMenu.GetComponent<ToolScript>();
        
        scriptToAccess.buildButton1();

    }

    [MenuItem("Gameshard/Create UI Buttons/Create Game Over Button")]

    private static void CreateGameOverButtons()
    {

        GameObject canvasMenu = GameObject.Find("Main Canvas");
        ToolScript scriptToAccess = canvasMenu.GetComponent<ToolScript>();

        scriptToAccess.buildButton2();
 
    }

    private void OnWizardCreate()
    {
    GameObject mainCanvas = PrefabUtility.InstantiatePrefab(canvasMenu.gameObject as GameObject) as GameObject;
        // GameObject canvasMenu = PrefabUtility.InstantiatePrefab(Resources.Load("Main Canvas")) as GameObject;
    }


    //GameObject canvasMenu = GameObject.Find("Main Canvas");
    //Tool_Script scriptToAccess = canvasMenu.GetComponent<Tool_Script>();
    //scriptToAccess.buildButton1();

}
