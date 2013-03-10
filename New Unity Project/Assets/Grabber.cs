using UnityEngine;
using System.Collections;

public class Grabber: MonoBehaviour {

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {				
		if (SphereTriggerScript.toolDetaching == true){
			this.guiText.text = "Grabber: In Use";
		} else {
			this.guiText.text = "Grabber: Available For Use";
		}
	}
}
