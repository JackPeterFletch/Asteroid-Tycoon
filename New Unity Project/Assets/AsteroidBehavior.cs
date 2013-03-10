using UnityEngine;
using System.Collections;

public class AsteroidBehavior : MonoBehaviour {

	static float gravitational_constant = 10F;
	float rand = 0;
	
	// Use this for initialization
	void Start () {
		var x = this.rigidbody.position.x;
		var y = this.rigidbody.position.y;
		var distance = Mathf.Sqrt((x*x)+(y*y));
		var orbital_velocity = (Vector3.Cross(this.rigidbody.position,Vector3.forward)/(distance/780));//The more the distance is divided, the smaller the velocity.
		this.rigidbody.velocity = orbital_velocity;
		rand  = Random.Range (-40,120);
		this.transform.localScale += new Vector3(rand,rand,rand);
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
	
	void OnCollisionEnter(Collision collision) {
		
		Debug.Log("HELLOYOLOLOL");
		
        //Instantiate(explosionPrefab, pos, rot) as Transform;
		if (collision.gameObject == GameObject.Find("Planet")){
			GameObject.Find("Main Camera").audio.Play();
			MoneyCounterScript.money = MoneyCounterScript.money + (int)((transform.localScale.x * 1000)/150);
        	Destroy(gameObject);
		}
	}
		
}
