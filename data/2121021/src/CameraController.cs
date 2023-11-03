using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public Transform target; // �J�����̃^�[�Q�b�g�i�v���C���[�j
    public float rotationSpeed = 2.0f; // �}�E�X�ɂ��J�����̉�]���x
    public float distance = 5.0f; // �J�����ƃv���C���[�̋���
    public float ydistance = 2.0f; // �J�����̍����iY�������j

    private float rotationX = 0.0f; // �}�E�X�ɂ��J������X����]�p�x
    private float rotationY = 0.0f; // �}�E�X�ɂ��J������Y����]�p�x

    private Vector3 initialPosition; // �J�����̏����ʒu
    public Transform playerTransform; // �v���C���[��Transform

    private bool isHKeyPressed = false; // H �L�[�������ꂽ���ǂ����̃t���O

    void Start()
    {
        //Cursor.lockState = CursorLockMode.Locked; // �}�E�X�J�[�\�������b�N���ĉB��
        //Cursor.visible = true;

        // �J�����̏����ʒu��ۑ�
        initialPosition = transform.position;
    }

    private void Update()
    {
        // H �L�[�̓��͂����o
        if (Input.GetKeyDown(KeyCode.H))
        {
            isHKeyPressed = !isHKeyPressed; // H �L�[�̏�Ԃ�؂�ւ���
        }
    }

    private void FixedUpdate()
    {
        if (isHKeyPressed)
        {
            // �J�������A�C�e���̈ʒu�Ɉړ�
            Vector3 targetPosition = FindNearestItem().transform.position;
            transform.position = Vector3.Lerp(transform.position, targetPosition, Time.deltaTime * rotationSpeed);

            // �J�������A�C�e���������悤�ɐݒ�
            transform.LookAt(FindNearestItem().transform);
        }
        else
        {
            // �}�E�X��X���ړ��ɉ����ăJ�����𐅕������ɉ�]
            rotationX += Input.GetAxis("Mouse X") * rotationSpeed;

            // �}�E�X��Y���ړ��ɉ����ăJ�����𐂒������ɉ�]
            rotationY -= Input.GetAxis("Mouse Y") * rotationSpeed;
            rotationY = Mathf.Clamp(rotationY, -90f, 90f); // �㉺�����̉�]�𐧌�

            // �J�����̈ʒu��ݒ�
            Quaternion rotation = Quaternion.Euler(rotationY, rotationX, 0);
            Vector3 offset = new Vector3(0, ydistance, -distance); // �J�����̍����Ƌ�����ݒ�
            Vector3 desiredPosition = target.position + rotation * offset;

            // �J�����̈ʒu��ݒ�i�X���[�Y�Ɉړ��j
            transform.position = Vector3.Lerp(transform.position, desiredPosition, Time.deltaTime * 0.5f);

            // �J�����̌�����ݒ�
            transform.LookAt(target);
        }
    }

    GameObject FindNearestItem()
    {
        GameObject[] items = GameObject.FindGameObjectsWithTag("Pick Up"); // "Pick Up" �^�O�̃A�C�e����T��

        int numberOfItems = items.Length; // �A�C�e���̐����擾

        Debug.Log("�A�C�e���̐�: " + numberOfItems); // �A�C�e���̐������O�ɕ\��

        if (items.Length == 0)
        {
            // �A�C�e�������݂��Ȃ��ꍇ�� null ��Ԃ�
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
