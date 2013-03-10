using UnityEngine;
using System.Collections;

public class MoneyCounterScript : MonoBehaviour {
	
	public static int money;
	public static int deorbit_count;

	// Use this for initialization
	void Start () {
		money = 0;
		deorbit_count = 0;
	}
	
	// Update is called once per frame
	void Update () {
		guiText.text = "Cash $ " + money + " From " + deorbit_count + " Asteroids.";
	}
}
