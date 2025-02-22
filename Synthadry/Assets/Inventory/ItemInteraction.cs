using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ItemInteraction : MonoBehaviour
{
    [SerializeField] private Transform cam;
    [SerializeField] private int takeDistance = 100;
    [SerializeField] private GameObject player;
    [SerializeField] LayerMask itemLayer;
    [SerializeField] LayerMask buffLayer;
    [SerializeField] LayerMask torchLayer;
    [SerializeField] LayerMask componentLayer;

    private InventorySystem inventorySystem;
    void Start()
    {
        inventorySystem = player.GetComponent<InventorySystem>();
    }

    // Update is called once per frame
    void Update()
    {
        RaycastHit hit;

        if (Input.GetKeyDown(KeyCode.F))
        {
            if (Physics.Raycast(cam.position, cam.forward, out hit, takeDistance, itemLayer))
            {
                if (!hit.collider.GetComponent<ItemObject>())
                    return;

                Debug.Log(hit.collider.gameObject);

                inventorySystem.PickUpItem(hit.collider.gameObject);
                hit.collider.gameObject.SetActive(false);
            }
            else if (Physics.Raycast(cam.position, cam.forward, out hit, takeDistance, buffLayer))
            {
                if (!hit.collider.GetComponent<BuffObject>())
                    return;

                Debug.Log(hit.collider.gameObject);

                inventorySystem.PickUpBuff(hit.collider.gameObject);
                hit.collider.gameObject.SetActive(false);

            }
/*            else if (Physics.Raycast(cam.position, cam.forward, out hit, takeDistance, torchLayer))
            {
                Debug.Log(hit.collider.gameObject);
                torchSystem.addPercentages(hit.collider.gameObject.GetComponent<TorchObject>().torchPeace.Percents);
                Destroy(hit.collider.gameObject);
                
            }*/
            else if (Physics.Raycast(cam.position, cam.forward, out hit, takeDistance, componentLayer))
            {
                Debug.Log("4567");
                inventorySystem.PickUpComponent(hit.collider.gameObject);
                Destroy(hit.collider.gameObject);
            }
            else
            {
                //�� �����-�� ���� �����������?
            }
           
        }
        
    }
}