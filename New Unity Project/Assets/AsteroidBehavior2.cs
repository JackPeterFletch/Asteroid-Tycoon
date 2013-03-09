using UnityEngine;
using System.Collections;

public class AsteroidBehavior2 : MonoBehaviour {

	// Use this for initialization
	void Start () {
		var orbital_velocity = new Vector3(500,0,0);
		this.rigidbody.velocity = orbital_velocity;
	}
	
	// Update is called once per frame
	void Update () {
		var x = this.transform.position.x;
		var y = this.transform.position.y;
		var planet_z = this.transform.parent.transform.position.z;
		
		var z_locked = new Vector3(x,y,planet_z);
		
		this.transform.position = z_locked;
		
		Vector3 gravity = this.transform.parent.transform.position - this.transform.position;
		this.transform.constantForce.force = gravity/3;
		
		var zero_thrust = new Vector3(0,0,0);
		this.transform.constantForce.relativeForce = zero_thrust;
	}
}
