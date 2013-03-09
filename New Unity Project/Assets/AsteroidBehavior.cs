using UnityEngine;
using System.Collections;

public class AsteroidBehavior : MonoBehaviour {

	static float gravitational_constant = 10F;
	
	// Use this for initialization
	void Start () {
		var orbital_velocity = new Vector3(1000,0,0);
		this.rigidbody.velocity = orbital_velocity;
	}
	
	// Update is called once per frame
	void Update () {
		
		var x = this.transform.position.x;
		var y = this.transform.position.y;
		
		var z_locked = new Vector3(x,y,0);
		
		this.transform.position = z_locked;
			
		// GRAVITY
		//Vector3 diff = origin - this.transform.position;
		//Vector3 down = diff.normalized;
		//float gravitational_force = (planet.rigidbody.mass * this.rigidbody.mass * gravitational_constant) / diff.sqrMagnitude;
		//this.rigidbody.AddForce(down * gravitational_force);
		this.rigidbody.AddForce(GravityVector(this.transform.position)*Time.deltaTime*60);
		////////////////
		
		var zero_thrust = new Vector3(0,0,0);
		this.transform.constantForce.relativeForce = zero_thrust;
	}
	
	Vector3 GravityVector(Vector3 position){
		Vector3 origin = new Vector3(0,0,0);
		var planet = GameObject.Find("Planet");
		
		Vector3 diff = origin - position;
		Vector3 down = diff.normalized;
		float gravitational_force = (planet.rigidbody.mass * this.rigidbody.mass * gravitational_constant) / diff.sqrMagnitude;
		
		return (down * gravitational_force);	
	}
}
