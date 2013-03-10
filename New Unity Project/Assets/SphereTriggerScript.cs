using UnityEngine;
using System.Collections;

public class SphereTriggerScript : MonoBehaviour {
	
	public static bool roidAttached;

	public static bool toolDetaching;
	
	public AudioClip thunkNoise;
	
	// Use this for initialization
	void Start () {
		roidAttached = false;
		toolDetaching = false;
	}
	
	// Update is called once per frame
	void Update () {
		
		if (Input.GetKeyDown(KeyCode.Space) && roidAttached){
			
			toolDetaching = true;
			roidAttached = false;
			
			var shuttleVar = GameObject.Find("SpaceShuttleOrbiter");
			Destroy(shuttleVar.GetComponent<FixedJoint>());
			
						
		} else if(Input.GetKeyDown(KeyCode.Space)){
			toolDetaching = !toolDetaching;
		}
	
	}
	
	void OnTriggerEnter(Collider other) {
		
		Debug.Log(other.name);
		
		if(other.name == "asteroid 3DS(Clone)" && !roidAttached && !toolDetaching){
			
			GameObject.Find ("Main Camera").audio.PlayOneShot(thunkNoise);
			var shuttleVar = GameObject.Find("SpaceShuttleOrbiter");
			
			shuttleVar.AddComponent("FixedJoint");
			shuttleVar.GetComponent<FixedJoint>().connectedBody = other.rigidbody;
			
			roidAttached = true;
			
			
			
			 //B.GetComponent<FixedJoint>().connectedBody = A.rigidbody;
			//GameObject.Find("SpaceShuttleOrbiter").gameObject.hingeJoint.connectedBody = other.rigidbody;
			
			//other.gameObject.AddComponent("FixedJoint");
			//other.gameObject.fixed.f.connectedBody = GameObject.Find("SpaceShuttleOrbiter");
			
			
			//
		}
		
		//GameObject.Find("SpaceShuttleOrbiter").hingeJoint.axis = (1,1,1) ;
		//GameObject.Find("SpaceShuttleOrbiter").hingeJoint.axis.y = 1;
		//GameObject.Find("SpaceShuttleOrbiter").hingeJoint.axis.z = 1;
		//GameObject.Find("SpaceShuttleOrbiter").hingeJoint.connectedBody = other.gameObject;
        
    }
}
