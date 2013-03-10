using UnityEngine;
using System.Collections;

public class Grabber: MonoBehaviour {

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {				
		this.guiText.text = "Grabber Active: " + SphereTriggerScript.toolDetaching;
	}
}
