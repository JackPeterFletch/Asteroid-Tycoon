using UnityEngine;
using System.Collections;

public class RocketBehavior : MonoBehaviour {
	
	LineRenderer lineRenderer;
	
	// Use this for initialization
	void Start () {
		var orbital_velocity = new Vector3(0,1000,0);
		this.rigidbody.velocity = orbital_velocity;
		
		lineRenderer = gameObject.AddComponent<LineRenderer>();
        //lineRenderer.useWorldSpace = true;
		lineRenderer.material = new Material (Shader.Find("Particles/Additive"));
        lineRenderer.SetColors(Color.white, Color.white);
		lineRenderer.SetWidth(100,100);
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
		
		// Render Orbit prediction
		this.UpdateTrajectory(this.rigidbody.position,this.rigidbody.velocity, 1, 4000, gravitational_force, down);
	}
	
	//
	void UpdateTrajectory(Vector3 startPos, Vector3 velocity, float timePerSegmentInSeconds, float maxTravelDistance, float gravitational_force, Vector3 gravity_vector){	
	    var positions = new System.Collections.Generic.List<Vector3>();
	    var lastPosition = startPos;
		var currentPosition = startPos;

		positions.Add(startPos);
	
	    var traveledDistance = 0.0f;	
		var direction = velocity;
	    var speed = direction.magnitude;
		
	    //while(traveledDistance < maxTravelDistance){
		for(var i=0; i< 10; ++i){
	
	        traveledDistance += speed * timePerSegmentInSeconds;	
	        var hasHitSomething = TravelTrajectorySegment(startPos, direction, speed, timePerSegmentInSeconds, positions, gravitational_force, gravity_vector);	
	        if (hasHitSomething){
	        	break;
			}
	
	        lastPosition = currentPosition;
	        currentPosition = positions[positions.Count - 1];
	        direction = currentPosition - lastPosition;
	        direction = direction.normalized;
	    }
	
	    
	
	    BuildTrajectoryLine(positions);
	
	}
		
	//Draw Line from set of positions
	void BuildTrajectoryLine(System.Collections.Generic.List<Vector3> positions){
    	for (var i = 0; i < positions.Count; ++i){
			lineRenderer.SetPosition(i, positions[i]);
	    }
	}
	
	//Calculate Trajectory Segment
	bool TravelTrajectorySegment(Vector3 startPos, Vector3 direction, float speed, float timePerSegmentInSeconds, System.Collections.Generic.List<Vector3> positions, float gravitational_force, Vector3 gravity_vector){	
		var newPos = startPos + (direction * speed * timePerSegmentInSeconds) + (gravity_vector * gravitational_force * timePerSegmentInSeconds); //EDIT THIS BIT
		RaycastHit hitInfo;
		var hasHitSomething = Physics.Linecast(startPos, newPos, out hitInfo);
		if (hasHitSomething){
	        newPos = hitInfo.transform.position;
		}
		positions.Add(newPos);

		//return hasHitSomething;
		return false;
	}
}
