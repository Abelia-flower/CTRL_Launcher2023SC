using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public Transform target; // カメラのターゲット（プレイヤー）
    public float rotationSpeed = 2.0f; // マウスによるカメラの回転速度
    public float distance = 5.0f; // カメラとプレイヤーの距離
    public float ydistance = 2.0f; // カメラの高さ（Y軸方向）

    private float rotationX = 0.0f; // マウスによるカメラのX軸回転角度
    private float rotationY = 0.0f; // マウスによるカメラのY軸回転角度

    private Vector3 initialPosition; // カメラの初期位置
    public Transform playerTransform; // プレイヤーのTransform

    private bool isHKeyPressed = false; // H キーが押されたかどうかのフラグ

    void Start()
    {
        //Cursor.lockState = CursorLockMode.Locked; // マウスカーソルをロックして隠す
        //Cursor.visible = true;

        // カメラの初期位置を保存
        initialPosition = transform.position;
    }

    private void Update()
    {
        // H キーの入力を検出
        if (Input.GetKeyDown(KeyCode.H))
        {
            isHKeyPressed = !isHKeyPressed; // H キーの状態を切り替える
        }
    }

    private void FixedUpdate()
    {
        if (isHKeyPressed)
        {
            // カメラをアイテムの位置に移動
            Vector3 targetPosition = FindNearestItem().transform.position;
            transform.position = Vector3.Lerp(transform.position, targetPosition, Time.deltaTime * rotationSpeed);

            // カメラをアイテムを向くように設定
            transform.LookAt(FindNearestItem().transform);
        }
        else
        {
            // マウスのX軸移動に応じてカメラを水平方向に回転
            rotationX += Input.GetAxis("Mouse X") * rotationSpeed;

            // マウスのY軸移動に応じてカメラを垂直方向に回転
            rotationY -= Input.GetAxis("Mouse Y") * rotationSpeed;
            rotationY = Mathf.Clamp(rotationY, -90f, 90f); // 上下方向の回転を制限

            // カメラの位置を設定
            Quaternion rotation = Quaternion.Euler(rotationY, rotationX, 0);
            Vector3 offset = new Vector3(0, ydistance, -distance); // カメラの高さと距離を設定
            Vector3 desiredPosition = target.position + rotation * offset;

            // カメラの位置を設定（スムーズに移動）
            transform.position = Vector3.Lerp(transform.position, desiredPosition, Time.deltaTime * 0.5f);

            // カメラの向きを設定
            transform.LookAt(target);
        }
    }

    GameObject FindNearestItem()
    {
        GameObject[] items = GameObject.FindGameObjectsWithTag("Pick Up"); // "Pick Up" タグのアイテムを探す

        int numberOfItems = items.Length; // アイテムの数を取得

        Debug.Log("アイテムの数: " + numberOfItems); // アイテムの数をログに表示

        if (items.Length == 0)
        {
            // アイテムが存在しない場合は null を返す
            return null;
        }

        GameObject nearestItem = null;

        float nearestDistance = Mathf.Infinity;

        foreach (GameObject item in items)
        {
            float distance = Vector3.Distance(playerTransform.position, item.transform.position);

            if (distance < nearestDistance)
            {
                nearestDistance = distance;
                nearestItem = item;
            }
        }

        return nearestItem;
    }
}
