using UnityEngine;
using System.Collections;

public class MenuZoomScript : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
		if (gameObject.transform.position.z > 6){
		
			gameObject.transform.Translate(0,0,-(50*Time.deltaTime));
			
		}
		
	}
}
