using JetBrains.Annotations;
using UnityEngine;
[CreateAssetMenu(fileName ="NPC name", menuName = "NPC Files Archive")]
public class NPC : ScriptableObject
{
    public string name;
    [TextArea(3, 15)]
    public string[] dialogue;
    [TextArea(3, 15)]
    public string[] playerDialogue;
}
