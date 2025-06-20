
//** Gameshard Studio **\\
// BioLab Card Game Template \\
//THIS SCRIPT USED FOR LOADING SCREEN

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class LoadingScreen : MonoBehaviour {

    public GameObject loadingScreen;
    public Slider loadingProgress;
    GameObject fadeOut;

    void Start()
    {
        fadeOut = GameObject.Find("FadeOut");
    }

    public void callLoad()
    {
        LoadLevel();
    }

    public void LoadLevel ()
    {
        StartCoroutine(LoadAsynchronously(1));

    }

    public void LoadLevelIndex(int sceneIndex)
    {
        Cursor.visible = false;
        StartCoroutine(LoadAsynchronously(sceneIndex));
    }

    public void fadeOutEffect()
    {
        fadeOut.GetComponent<Animator>().Play("FadeOut");
    }

    IEnumerator LoadAsynchronously (int sceneIndex)
    {
  
        yield return new WaitForSeconds(3.00f);  // Disable the highlight image 5

        AsyncOperation operation = SceneManager.LoadSceneAsync(sceneIndex);

        loadingScreen.SetActive(true);

        while (!operation.isDone)
        {

            float progress = Mathf.Clamp01(operation.progress / 1.0f);

            loadingProgress.value = progress;

            yield return null;

        }

    }
}
