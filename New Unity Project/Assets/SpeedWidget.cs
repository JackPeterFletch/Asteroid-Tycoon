using UnityEngine;
using System.Collections;

public class SpeedWidget : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		
		var spaceShuttle = GameObject.Find("SpaceShuttleOrbiter");
		
		this.guiText.text = "Speed (Somethings/S): " + spaceShuttle.rigidbody.velocity.magnitude.ToString();
	}
}
