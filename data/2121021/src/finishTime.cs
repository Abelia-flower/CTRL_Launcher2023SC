using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class finishTime : MonoBehaviour
{
    public Text finishText;

    // Start is called before the first frame update
    void Start()
    {
        finishText = GetComponent<Text>();
    }

    // Update is called once per frame
    void Update()
    {
        Debug.Log(Timer.timer);
        finishText.text = "  " +Timer.timer + "  ";

        if (Input.GetKeyDown(KeyCode.F))

        {
            Application.Quit();
        }
    }
}
