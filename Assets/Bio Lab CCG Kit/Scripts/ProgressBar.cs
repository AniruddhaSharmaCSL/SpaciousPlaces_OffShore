
//** Gameshard Studio **\\
            // Bio Lab Card Game Template \\
                          //THIS SCRIPT USED FOR PROGRESS BAR ACTION

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ProgressBar : MonoBehaviour {

    public Transform LoadingBar;
    public Transform TextIndicator;
    public Transform TextLoading;
    public Transform ArrowUp;
    [SerializeField] private float currentAmount;
    [SerializeField] private float speed;


    void Update()
    {
        if (currentAmount < 100)
        {
            currentAmount += speed * Time.deltaTime;
            TextIndicator.GetComponent<Text>().text = ((int)currentAmount).ToString() + "%";
            TextLoading.gameObject.SetActive(true);
            ArrowUp.gameObject.SetActive(false);

        }

        else
        {
            TextLoading.gameObject.SetActive(false);
            TextIndicator.GetComponent<Text>().text = "LEVEL UP!";
            StartCoroutine("ReplayXP");
            ArrowUp.gameObject.SetActive(true);
        }
        LoadingBar.GetComponent<Image>().fillAmount = currentAmount / 100;

    }


    IEnumerator ReplayXP()
    {
        yield return new WaitForSeconds(3.0f);  
        currentAmount = 0;
        StopCoroutine("ReplayXP");
    }
}