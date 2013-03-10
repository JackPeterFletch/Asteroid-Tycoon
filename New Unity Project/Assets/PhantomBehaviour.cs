using UnityEngine;
using System.Collections;

public class PhantomBehaviour : MonoBehaviour {
	
	static float gravitational_constant = 10F;
	static float updates = 0F;
	public System.Collections.Generic.List<Vector3> positions = null;
	
	// Use this for initialization
	void Start () {
		var orbital_velocity = new Vector3(0,12000,0);
		this.rigidbody.velocity = orbital_velocity;
		this.transform.position = GameObject.Find("SpaceShuttleOrbiter").transform.position;
		positions = new System.Collections.Generic.List<Vector3>();
		
		LineRenderer lineRenderer = gameObject.AddComponent<LineRenderer>();
        //lineRenderer.useWorldSpace = true;
		lineRenderer.material = new Material (Shader.Find("Particles/Additive"));
        lineRenderer.SetColors(Color.blue, Color.blue);
		lineRenderer.SetWidth(10,10);
		lineRenderer.SetVertexCount(300);
	}
	
	// Update is called once per frame
	void Update(){
		
		updates++;
		if(updates == 2){
			updates = 0;
			if(positions.Count == 300){
				positions.RemoveAt(0);
			}
			positions.Add(this.transform.position);
			BuildTrajectoryLine(positions);
		}
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
		for(var i=0; i< 50; i++){
	
	        var newPos = currentPosition + direction + GravityVector(currentPosition) * timePerSegmentInSeconds * 60;
			//newPos = newPos.normalized;
			positions.Add(newPos);
	
	        currentPosition = newPos;
			Vector3 acceleration = GravityVector(currentPosition)/this.rigidbody.mass;
	        direction = direction + (acceleration * timePerSegmentInSeconds);
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
