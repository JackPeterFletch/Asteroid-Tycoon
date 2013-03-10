using UnityEngine;
using System.Collections;

public class asteroidGen : MonoBehaviour {
	public Transform asteroid;
	
	// Use this for initialization
	void Start () {
		for(int i = 0;i<150;i++){
			var innerRad = 8000;
			var outerRad = 12000;
			var c = Random.insideUnitCircle * outerRad; // Initial Random x,y
			
			//If both x and y are within innerRad, loop until not
			while((c.x > -innerRad && c.x < innerRad)&&(c.y > -innerRad && c.y < innerRad)){
				c = Random.insideUnitCircle * outerRad;
			}
			
			//If y is within innerRad, but x is not, loop until y is out
			while((c.y > -innerRad && c.y < innerRad) && (c.x < -innerRad && c.x > innerRad)){
				c.y = (Random.insideUnitCircle * outerRad).y;
			}
			
			//If x is within innerRad, but y is not, loop until x is out
			while((c.x > -innerRad && c.x < innerRad) && (c.y < -innerRad && c.y > innerRad)){
				c.x = (Random.insideUnitCircle * outerRad).x;
			}
			
			//Set position, instantiate prefab asteroid
			var pos = new Vector3(c.x,c.y,0);
			Instantiate (asteroid,pos,transform.rotation);
		}
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
