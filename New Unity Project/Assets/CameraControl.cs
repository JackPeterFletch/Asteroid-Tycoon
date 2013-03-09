using UnityEngine;
using System.Collections;

public class CameraControl : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		
		Vector3 rocket_pos = GameObject.Find("SpaceShuttleOrbiter").transform.position;
		GameObject.Find("Main Camera").transform.position = new Vector3(rocket_pos.x, rocket_pos.y, GameObject.Find("Main Camera").transform.position.z);
		
		if (Input.GetKey(KeyCode.Z)){
			this.transform.Translate(0,0,10);
		}
		if (Input.GetKey(KeyCode.X)){
			this.transform.Translate(0,0,-10);
		}
	}
}
