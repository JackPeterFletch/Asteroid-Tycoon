using UnityEngine;
using System.Collections;

public class CameraControl : MonoBehaviour {
	
	static float manual_zoom = 0;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		
		Vector3 rocket_pos = GameObject.Find("SpaceShuttleOrbiter").transform.position;
		Vector3 planet_pos = GameObject.Find("Planet").transform.position;
		var planet_radius = 4500/2;
		var zoom = (Vector3.Distance(planet_pos, rocket_pos) - planet_radius) + 600 + manual_zoom;
		if(zoom < 600){
			zoom = 600;
		}
		GameObject.Find("Main Camera").transform.position = new Vector3(rocket_pos.x, rocket_pos.y, -zoom);
		
		if (Input.GetKey(KeyCode.Z)){
			manual_zoom += 50;
		}
		if (Input.GetKey(KeyCode.X)){
			manual_zoom -= 50;
		}
		if(manual_zoom < -4000){
			manual_zoom = -4000;
		}
	}
}
