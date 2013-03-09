using UnityEngine;
using System.Collections;

public class RocketBehavior : MonoBehaviour {

	// Use this for initialization
	void Start () {
		var orbital_velocity = new Vector3(0,1000,0);
		this.rigidbody.velocity = orbital_velocity;
	}
	
	// Update is called once per frame
	void Update () {
		float gravitational_constant = 10F;
		var planet = GameObject.Find("Planet");
		
		//Lock z axis
		//var x = this.transform.position.x;
		//var y = this.transform.position.y;
		//var z_locked = new Vector3(x,y,0);
		//this.transform.position = z_locked;
		//////////////////////////////////////
		
		var zero_thrust = new Vector3(0,0,0);
		this.transform.constantForce.relativeForce = zero_thrust;
		
		Vector3 origin = new Vector3(0,0,0);
		
		// GRAVITY
		Vector3 diff = origin - this.transform.position;
		Vector3 down = diff.normalized;
		float gravitational_force = (planet.rigidbody.mass * this.rigidbody.mass * gravitational_constant) / diff.sqrMagnitude;
		this.rigidbody.AddForce(down * gravitational_force);
		//this.rigidbody.AddForce((origin - this.transform.position).normalized * gravitational_constant);
		////////////////
		
		var thrust = new Vector3(0,0,-100 * this.rigidbody.mass);
		
		// Keyboard input
		if (Input.GetKey(KeyCode.UpArrow)){
			this.transform.constantForce.relativeForce = thrust;
		}
		if (Input.GetKey(KeyCode.DownArrow)){
			this.transform.constantForce.relativeForce = -thrust;
		}
		if (Input.GetKey(KeyCode.W)){
			//this.transform.Rotate(-2,0,0);
			this.rigidbody.AddTorque(0,0,-50000 * this.rigidbody.mass);
		}
		if (Input.GetKey(KeyCode.S)){
			//this.transform.Rotate(2,0,0);
			this.rigidbody.AddTorque(0,0,50000 * this.rigidbody.mass);
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
