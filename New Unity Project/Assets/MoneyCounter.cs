using UnityEngine;
using System.Collections;

public class MoneyCounter : MonoBehaviour {
	
	public static int amountOfMoney;

	// Use this for initialization
	void Start () {
		amountOfMoney = 0;	
	}
	
	// Update is called once per frame
	void Update () {				
		this.guiText.text = "Money $ " + amountOfMoney;
	}
}
