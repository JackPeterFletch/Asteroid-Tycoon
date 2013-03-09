using UnityEngine;
using System.Collections;

public class asteroidGen : MonoBehaviour {
	public Transform asteroid;
	
	// Use this for initialization
	void Start () {
		for(int i = 0;i<100;i++){
			var pos = new Vector3(Random.Range(-9000,9000),Random.Range(8000,14000),0);
			Instantiate (asteroid,pos,transform.rotation);
		}
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
