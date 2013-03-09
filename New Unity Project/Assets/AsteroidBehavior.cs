using UnityEngine;
using System.Collections;

public class AsteroidBehavior : MonoBehaviour {

	// Use this for initialization
	void Start () {
		var orbital_velocity = new Vector3(150,0,0);
		this.rigidbody.velocity = orbital_velocity;
	}
	
	// Update is called once per frame
	void Update () {
		float gravitational_constant = 10F;
		var planet = GameObject.Find("Planet");
		
		var x = this.transform.position.x;
		var y = this.transform.position.y;
		
		var z_locked = new Vector3(x,y,0);
		
		this.transform.position = z_locked;
		
		Vector3 origin = new Vector3(0,0,0);
		
		// GRAVITY
		Vector3 diff = origin - this.transform.position;
		Vector3 down = diff.normalized;
		float gravitational_force = (planet.rigidbody.mass * this.rigidbody.mass * gravitational_constant) / diff.sqrMagnitude;
		this.rigidbody.AddForce(down * gravitational_force);
		////////////////
		
		var zero_thrust = new Vector3(0,0,0);
		this.transform.constantForce.relativeForce = zero_thrust;
	}
}
