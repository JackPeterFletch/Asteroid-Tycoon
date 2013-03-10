using UnityEngine;
using System.Collections;

public class MoneyCounterScript : MonoBehaviour {
	
	public static int money; 

	// Use this for initialization
	void Start () {
		money = 0;
	}
	
	// Update is called once per frame
	void Update () {
		guiText.text = "Cash $ " + money;
	}
}
