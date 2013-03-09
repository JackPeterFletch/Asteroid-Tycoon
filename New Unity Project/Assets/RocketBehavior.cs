using UnityEngine;
using System.Collections;

public class RocketBehavior : MonoBehaviour {
	
	static float gravitational_constant = 10F;
	
	// Use this for initialization
	void Start () {
		var orbital_velocity = new Vector3(0,1000,0);
		this.rigidbody.velocity = orbital_velocity;
		
		LineRenderer lineRenderer = gameObject.AddComponent<LineRenderer>();
        //lineRenderer.useWorldSpace = true;
		lineRenderer.material = new Material (Shader.Find("Particles/Additive"));
        lineRenderer.SetColors(Color.white, Color.white);
		lineRenderer.SetWidth(100,100);
		lineRenderer.SetVertexCount(10);
	}
	
	// Update is called once per frame
	void Update () {
		
		//Lock z axis
		//var x = this.transform.position.x;
		//var y = this.transform.position.y;
		//var z_locked = new Vector3(x,y,0);
		//this.transform.position = z_locked;
		//////////////////////////////////////
		
		var zero_thrust = new Vector3(0,0,0);
		this.transform.constantForce.relativeForce = zero_thrust;
		
		// GRAVITY
		this.rigidbody.AddForce(GravityVector(this.transform.position)*Time.deltaTime*60);
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
		
		// Render Orbit prediction
		this.UpdateTrajectory(this.transform.position,this.rigidbody.velocity, 1, 4000);
	}
	
	Vector3 GravityVector(Vector3 position){
		Vector3 origin = new Vector3(0,0,0);
		var planet = GameObject.Find("Planet");
		
		Vector3 diff = origin - position;
		Vector3 down = diff.normalized;
		float gravitational_force = (planet.rigidbody.mass * this.rigidbody.mass * gravitational_constant) / diff.sqrMagnitude;
		
		return (down * gravitational_force);	
	}
	
	//
	void UpdateTrajectory(Vector3 startPos, Vector3 velocity, float timePerSegmentInSeconds, float maxTravelDistance){	
	    var positions = new System.Collections.Generic.List<Vector3>();
		var currentPosition = startPos;

		positions.Add(startPos);
	
		var direction = velocity;
		
	    //while(traveledDistance < maxTravelDistance){
		for(var i=0; i< 10; i++){
	
	        var newPos = currentPosition + direction + GravityVector(currentPosition) * timePerSegmentInSeconds * 60;
			//newPos = newPos.normalized;
			positions.Add(newPos);
	
	        currentPosition = newPos;
			Vector3 acceleration = GravityVector(currentPosition)/this.rigidbody.mass;
			Debug.Log (direction);
	        direction = direction + (acceleration * timePerSegmentInSeconds);
	        //direction = direction.normalized;
			Debug.Log (direction);
	    }
	
	    
	
	    BuildTrajectoryLine(positions);
	
	}
		
	//Draw Line from set of positions
	void BuildTrajectoryLine(System.Collections.Generic.List<Vector3> positions){
		LineRenderer lineRenderer = GetComponent<LineRenderer>();
    	for (var i = 0; i < positions.Count; i++){
			lineRenderer.SetPosition(i, positions[i]);
	    }
	}
}
