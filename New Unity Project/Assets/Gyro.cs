using UnityEngine;
using System.Collections;

public class Gyro : MonoBehaviour
{

	// Use this for initialization
	void Start ()
	{
	
	}
	
	// Update is called once per frame
	void Update ()
	{
		if (RocketBehavior.gyro == true){
			this.guiText.text = "Gyro: On";
		} else {
			this.guiText.text = "Gyro: Off";
		}
	}
}

