using UnityEngine;
using System.Collections;

public class asteroidGen : MonoBehaviour {
	public Transform asteroid;
	
	// Use this for initialization
	void Start () {
		for(int i = 0;i<100;i++){
			var innerRad = 7000;
			var outerRad = 20000;
			var c = Random.insideUnitCircle * outerRad;
			while((c.x > -innerRad && c.x < innerRad)&&(c.y > -innerRad && c.y < innerRad)){
				c = Random.insideUnitCircle * outerRad;
			}
			while((c.y > -innerRad && c.y < innerRad) && (c.x < -innerRad && c.x > innerRad)){
				c.y = (Random.insideUnitCircle * outerRad).y;
			}
			while((c.x > -innerRad && c.x < innerRad) && (c.y < -innerRad && c.y > innerRad)){
				c.x = (Random.insideUnitCircle * outerRad).x;
			}
			var pos = new Vector3(c.x,c.y,0);
			Instantiate (asteroid,pos,transform.rotation);
		}
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
