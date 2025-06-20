//© Dicewrench Designs LLC 2025

//All Rights Reserved
//Last Owned by: Allen White (allen@dicewrenchdesigns.com)

using UnityEngine;
using UnityEditor;
using System.IO;

public class RenameFilesEditorWindow : EditorWindow
{
    private string oldString = "";
    private string newString = "";
    private string selectedFolderPath = "";

    [MenuItem("DWD/Rename Files")]
    public static void ShowWindow()
    {
        GetWindow<RenameFilesEditorWindow>("Rename Files");
    }

    private void OnGUI()
    {
        GUILayout.Label("Rename Files in Folder", EditorStyles.boldLabel);

        selectedFolderPath = EditorGUILayout.TextField("Selected Folder Path:", selectedFolderPath);
        if (GUILayout.Button("Select Folder"))
        {
            selectedFolderPath = EditorUtility.OpenFolderPanel("Select Folder", "", "");
        }

        if (GUILayout.Button("Get Selected Folder Path"))
        {
            GetSelectedFolderPath();
        }

        oldString = EditorGUILayout.TextField("Old String:", oldString);
        newString = EditorGUILayout.TextField("New String:", newString);

        if (GUILayout.Button("Rename Files"))
        {
            RenameFiles();
        }
    }

    private void GetSelectedFolderPath()
    {
        if (Selection.assetGUIDs.Length == 0)
        {
            Debug.LogWarning("No folder selected in the Project window.");
            return;
        }

        string guid = Selection.assetGUIDs[0];
        string path = AssetDatabase.GUIDToAssetPath(guid);

        if (Directory.Exists(path))
        {
            selectedFolderPath = path;
        }
        else
        {
            Debug.LogWarning("The selected item is not a folder.");
        }
    }

    private void RenameFiles()
    {
        if (string.IsNullOrEmpty(selectedFolderPath))
        {
            Debug.LogError("Please select a folder.");
            return;
        }

        if (!Directory.Exists(selectedFolderPath))
        {
            Debug.LogError("The selected folder does not exist.");
            return;
        }

        if (string.IsNullOrEmpty(oldString) || string.IsNullOrEmpty(newString))
        {
            Debug.LogError("Both old and new strings must be provided.");
            return;
        }

        try
        {
            string[] files = Directory.GetFiles(selectedFolderPath);
            foreach (string file in files)
            {
                string fileName = Path.GetFileName(file);
                if (fileName.Contains(oldString))
                {
                    string newFileName = fileName.Replace(oldString, newString);
                    string newFilePath = Path.Combine(selectedFolderPath, newFileName);
                    File.Move(file, newFilePath);
                    AssetDatabase.RenameAsset(file.Substring(file.IndexOf("Assets")), newFileName);
                    Debug.Log($"Renamed: {fileName} to {newFileName}");
                }
            }
            AssetDatabase.Refresh();
        }
        catch (System.Exception e)
        {
            Debug.LogError($"An error occurred: {e.Message}");
        }
    }
}