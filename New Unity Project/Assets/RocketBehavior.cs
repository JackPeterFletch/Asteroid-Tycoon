using UnityEngine;
using System.Collections;

public class RocketBehavior : MonoBehaviour {
	
	static float gravitational_constant = 10F;
	static float updates = 0F;
	public System.Collections.Generic.List<Vector3> positions = null;
	public GameObject phantom;
	public static bool gyro;
	public bool first_tick = true;
	public float RCS_thrust;
	
	// Use this for initialization
	void Start () {
		var orbital_velocity = new Vector3(0,1200,0);
		this.rigidbody.velocity = orbital_velocity;
		positions = new System.Collections.Generic.List<Vector3>();
		phantom = GameObject.Find("Phantom Shuttle");
		gyro = true;
		phantom.transform.position = this.transform.position;
      	phantom.rigidbody.velocity = this.rigidbody.velocity * 10;
		
		LineRenderer lineRenderer = gameObject.AddComponent<LineRenderer>();
        //lineRenderer.useWorldSpace = true;
		lineRenderer.material = new Material (Shader.Find("Particles/Additive"));
        lineRenderer.SetColors(Color.white, Color.white);
		lineRenderer.SetWidth(100,100);
		lineRenderer.SetVertexCount(50);
	}
	
	// Update is called once per frame
	void Update () {
		
		if (SphereTriggerScript.roidAttached){
			RCS_thrust = 200000;
		} else {
			RCS_thrust = 50000;
		}
		
		var zero_thrust = new Vector3(0,0,0);
		this.transform.constantForce.relativeForce = zero_thrust;
		
		// GRAVITY
		this.rigidbody.AddForce(GravityVector(this.transform.position)*Time.deltaTime*60);
		////////////////
		
		var thrust = new Vector3(0,0,-100 * this.rigidbody.mass);
		var fire = GameObject.Find("Fire");
		var frontBottom = GameObject.Find("RCSFrontBottom");
		frontBottom.renderer.enabled = false;
		var frontTop = GameObject.Find("RCSFrontTop");
		frontTop.renderer.enabled = false;
		var rearBottom = GameObject.Find("RCSRearBottom");
		rearBottom.renderer.enabled = false;
		var rearTop = GameObject.Find("RCSRearTop");
		rearTop.renderer.enabled = false;
		
		fire.renderer.enabled = false;
		// Keyboard input
		if (Input.GetKey(KeyCode.UpArrow)){
       		this.transform.constantForce.relativeForce = thrust;
       		fire.renderer.enabled = true;
			audio.enabled = true;
			if (!audio.isPlaying){
				audio.Play();
			} 
		} else {
			audio.Stop();
		}
		if (Input.GetKeyUp(KeyCode.UpArrow)){
    	    phantom.transform.position = this.transform.position;
			phantom.rigidbody.velocity = this.rigidbody.velocity * 10;
			PhantomBehaviour.wipe = true;
     	}
     	if (Input.GetKey(KeyCode.DownArrow)){
	        this.transform.constantForce.relativeForce = -thrust;
     	}
		if (Input.GetKeyUp(KeyCode.DownArrow)){
    	    phantom.transform.position = this.transform.position;
			phantom.rigidbody.velocity = this.rigidbody.velocity * 10;
			PhantomBehaviour.wipe = true;
     	}
		if (Input.GetKey(KeyCode.W)){
			//this.transform.Rotate(-2,0,0);
			this.rigidbody.AddTorque(0,0,-RCS_thrust * this.rigidbody.mass);
			frontTop.renderer.enabled = true;
			rearBottom.renderer.enabled = true;
		}
		if (Input.GetKey(KeyCode.S)){
			//this.transform.Rotate(2,0,0);
			this.rigidbody.AddTorque(0,0,RCS_thrust * this.rigidbody.mass);
			frontBottom.renderer.enabled = true;
			rearTop.renderer.enabled = true;	
		}
	    if (Input.GetKeyUp(KeyCode.G)){
			if (gyro == true){
				gyro = false;
			}else if (SphereTriggerScript.roidAttached == false){
				gyro = true;
			}
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
		//this.UpdateTrajectory(this.transform.position,this.rigidbody.velocity, 1, 4000);
		
		if (gyro == true){
			transform.LookAt(Vector3.zero);
			if (this.rigidbody.position.x <=0){
				transform.Rotate(new Vector3(90,0,180));
			}else{
				transform.Rotate(new Vector3(270,0,0));
			}
		}
		
		updates++;
		if(updates == 100){
			updates = 0;
			if(positions.Count == 50){
				positions.RemoveAt(0);
			}
			positions.Add(this.transform.position);
		}
		
		for (var i=0; i<10; i++){
			phantom.transform.constantForce.relativeForce = zero_thrust;
			phantom.rigidbody.AddForce(PhantomGravityVector(phantom.transform.position,phantom)*Time.deltaTime*60);
		}
	}
	
	void OnCollisionEnter(Collision collision) {
        //Instantiate(explosionPrefab, pos, rot) as Transform;
		if (collision.gameObject == GameObject.Find("Planet")){
        	Destroy(gameObject);
			FailureMenu.userHasFailed = true;
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
	
	Vector3 PhantomGravityVector(Vector3 position, GameObject phantom){
		Vector3 origin = new Vector3(0,0,0);
		var planet = GameObject.Find("Planet");
		
		Vector3 diff = origin - position;
		Vector3 down = diff.normalized;
		float gravitational_force = (planet.rigidbody.mass * phantom.rigidbody.mass * 100F) / diff.sqrMagnitude;
		
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
