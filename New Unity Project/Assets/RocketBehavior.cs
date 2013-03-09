using UnityEngine;
using System.Collections;

public class RocketBehavior : MonoBehaviour {

	// Use this for initialization
	void Start () {
		var orbital_velocity = new Vector3(0,200,0);
		this.rigidbody.velocity = orbital_velocity;
	}
	
	// Update is called once per frame
	void Update () {
		//Lock z axis
		var x = this.transform.position.x;
		var y = this.transform.position.y;
		var planet_z = this.transform.parent.transform.position.z;
		var z_locked = new Vector3(x,y,planet_z);
		this.transform.position = z_locked;
		//////////////////////////////////////
		
		var zero_thrust = new Vector3(0,0,0);
		this.transform.constantForce.relativeForce = zero_thrust;
		
		Vector3 gravity = this.transform.parent.transform.position - this.transform.position;
		var thrust = new Vector3(0,0,-100);
		
		this.transform.constantForce.force = gravity/3;
		
		// Keyboard input
		if (Input.GetKey(KeyCode.UpArrow)){
			this.transform.constantForce.relativeForce = thrust;
		}
		if (Input.GetKey(KeyCode.DownArrow)){
			this.transform.constantForce.relativeForce = -thrust;
		}
		if (Input.GetKey(KeyCode.W)){
			this.transform.Rotate(-2,0,0);
		}
		if (Input.GetKey(KeyCode.S)){
			this.transform.Rotate(2,0,0);
		}
		////////////////////////////////////////
		
		// Uncomment these for 3D rotation
		//if (Input.GetKey(KeyCode.A)){
		//	this.transform.Rotate(2,0,0);
		//}
		//if (Input.GetKey(KeyCode.D)){
		//	this.transform.Rotate(-2,0,0);
		//}
		//if (Input.GetKey(KeyCode.Q)){
		//	this.transform.Rotate(0,2,0);
		//}
		//if (Input.GetKey(KeyCode.E)){
		//	this.transform.Rotate(0,-2,0);
		//}
	}
}
