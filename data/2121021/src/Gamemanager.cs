using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gamemanager : MonoBehaviour
{
    public bool gameOver;

    public GameObject gameOverText;

    public GameObject winText;

    public GameObject timerText;

    public PlayerController playerController;

    // Start is called before the first frame update
    void Start()
    {
        gameOverText.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if (gameOver && playerController.count < 10)
        {
            gameOverText.SetActive(true);
            timerText.SetActive(false);
        }
    }
}
