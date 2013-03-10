using UnityEngine;
using System.Collections;

public class SphereTriggerScript : MonoBehaviour {
	
	static bool roidAttached;
	
	// Use this for initialization
	void Start () {
		roidAttached = false;
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	void OnTriggerEnter(Collider other) {
		
		Debug.Log(other.name);
		
		if(other.name == "asteroid 3DS(Clone)" && !roidAttached){
			
			
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
