using UnityEngine;
using System.Collections;

public class AsteroidBehavior : MonoBehaviour {

	// Use this for initialization
	void Start () {
		var orbital_velocity = new Vector3(1000,0,0);
		this.rigidbody.velocity = orbital_velocity;
	}
	
	// Update is called once per frame
	void Update () {
		float gravitational_constant = 9.81F;
		
		var x = this.transform.position.x;
		var y = this.transform.position.y;
		var planet_z = this.transform.parent.transform.position.z;
		
		var z_locked = new Vector3(x,y,planet_z);
		
		this.transform.position = z_locked;
		
		// GRAVITY
		Vector3 diff = this.transform.parent.transform.position - this.transform.position;
		Vector3 down = diff.normalized;
		float gravitational_force = (this.transform.parent.rigidbody.mass * this.rigidbody.mass * gravitational_constant) / diff.sqrMagnitude;
		this.rigidbody.AddForce(down * gravitational_force);
		////////////////
		
		var zero_thrust = new Vector3(0,0,0);
		this.transform.constantForce.relativeForce = zero_thrust;
	}
}
