using UnityEngine;
using System.Collections;

public class MenuText : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		if (transform.localPosition.z > 23) {
			transform.Translate(0,0,-(50*Time.deltaTime));	
		}
	}
}
