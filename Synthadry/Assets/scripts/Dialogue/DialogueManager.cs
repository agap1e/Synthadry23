using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class DialogueManager : MonoBehaviour
{
    public NPC npc;

    bool isTalking = false;

    float distance;
    float curResponseTracker = 0;

    public GameObject player;
    public GameObject DialogueUI;

    public Text npcName;
    public Text npcDialogueBox;
    public Text playerDialogueBox;
    public Text playerDialogueBox1;


    void Start()
    {
        DialogueUI.SetActive(false);
    }

    void OnMouseOver()
    {
        distance = Vector3.Distance(player.transform.position, this.transform.position);
        if (distance <= 2.5f)
        {
            if (Input.GetAxis("Mouse ScrollWheel") < 0f)
            {
                curResponseTracker++;
                if (curResponseTracker >= npc.playerDialogue.Length - 1)
                {
                    curResponseTracker = npc.playerDialogue.Length - 1;
                }
            }
            else if (Input.GetAxis("Mouse ScrollWheel") > 0f)
            {
                curResponseTracker--;
                if (curResponseTracker < 0)
                {
                    curResponseTracker = 0;
                }
            }
            if (Input.GetKeyDown(KeyCode.E) && isTalking == false)
            {
                StartConversation();
                playerDialogueBox.text = npc.playerDialogue[0];
                playerDialogueBox1.text = npc.playerDialogue[1];
            }
            else if (Input.GetKeyDown(KeyCode.E) && isTalking == true)
            {
                EndDialogue();
            }

            if (curResponseTracker == 0 && npc.playerDialogue.Length >= 0)
            {
                playerDialogueBox.color = Color.blue;
                playerDialogueBox1.color = Color.white;

                if (Input.GetKeyDown(KeyCode.Return))
                {
                    npcDialogueBox.text = npc.dialogue[1];
                }
            }
            else if (curResponseTracker == 1 && npc.playerDialogue.Length >= 1)
            {
                playerDialogueBox.color = Color.white;
                playerDialogueBox1.color = Color.blue;

                if (Input.GetKeyDown(KeyCode.Return))
                {
                    npcDialogueBox.text = npc.dialogue[2];
                }
            }
            else if (curResponseTracker == 2 && npc.playerDialogue.Length >= 2)
            {
                playerDialogueBox.text = npc.playerDialogue[2];
                if (Input.GetKeyDown(KeyCode.Return))
                {
                    npcDialogueBox.text = npc.dialogue[3];
                }
            }
        }
        else
        {
            EndDialogue();
        }
    }
    void StartConversation()
    {
        isTalking = true;
        curResponseTracker = 0;
        DialogueUI.SetActive(true);
        npcName.text = npc.name;
        npcDialogueBox.text = npc.dialogue[0];
        //npcDialogueBox.text = npc.dialogue[1];

    }
    void EndDialogue()
    {
        isTalking = false;
        DialogueUI.SetActive(false);
    }
}


