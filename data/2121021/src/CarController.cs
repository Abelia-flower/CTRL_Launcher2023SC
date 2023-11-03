using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class CarController : MonoBehaviour
{

    public float speed;

    public float time;

    public float timeLimit = 5f;

    public Timer timer;

    public Gamemanager gamemanager;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.Translate(Vector3.forward * speed);

        time += Time.deltaTime;

        if (time > timeLimit)
        {
            time = 0;
            Destroy(gameObject);
        }

    }
}
