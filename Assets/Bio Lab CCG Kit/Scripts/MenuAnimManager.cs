using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MenuAnimManager : MonoBehaviour {


    public GameObject button1;
    public GameObject button2;
    public GameObject button3;
    public GameObject button4;
    public GameObject button5;
    public GameObject button6;



    public GameObject fadeOut;

    // Use this for initialization
    void Start () {
		
	}

    public void choosed1()
    {
        button1.GetComponent<Animator>().Play("Button1Choosed");
        fadeOut.GetComponent<Animator>().Play("FadeOut");
    }

    public void choosed2()
    {
        button2.GetComponent<Animator>().Play("Button2Choosed");
        fadeOut.GetComponent<Animator>().Play("FadeOut");
    }

    public void choosed3()
    {
        button3.GetComponent<Animator>().Play("Button3Choosed");
        fadeOut.GetComponent<Animator>().Play("FadeOut");
    }

    public void choosed4()
    {
        button4.GetComponent<Animator>().Play("Button4Choosed");
        
    }

    public void notchoosed4()
    {
        button4.GetComponent<Animator>().Play("Idle");

    }

    public void choosed5()
    {
        button5.GetComponent<Animator>().Play("Button5Choosed");
        fadeOut.GetComponent<Animator>().Play("FadeOut");
    }

    public void choosed6()
    {
        button6.GetComponent<Animator>().Play("Button6Choosed");
        fadeOut.GetComponent<Animator>().Play("FadeOut");
    }

    public void fadePlane()
    {
        fadeOut.GetComponent<Animator>().Play("FadeOut");
    }

    // Update is called once per frame
    void Update () {
		
	}
}
