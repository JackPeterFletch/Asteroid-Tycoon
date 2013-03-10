using UnityEngine;
using System.Collections;

public class FailureMenu : MonoBehaviour {
	
	public static bool userHasFailed;
	
	// Use this for initialization
	void Start () {
		userHasFailed = false;
	}
	
	
	void OnGUI () {
		
		if (userHasFailed){
			// Make a group on the center of the screen
			GUI.BeginGroup (new Rect (Screen.width / 2 - 200, Screen.height / 2 -50 , 400, 100));
			// All rectangles are now adjusted to the group. (0,0) is the topleft corner of the group.
	
			// We'll make a box so you can see where the group is on-screen.
			GUI.Box (new Rect (0,0,400,100), "Well Done, you made $" +MoneyCounterScript.money+ " this flight, try again?");
			if (GUI.Button (new Rect (160,25,80,30), "Retry")){
				Application.LoadLevel("mainScene");		
			}
			if (GUI.Button (new Rect (160,65,80,30), "Quit")){
				Application.Quit();
			}
	
			// End the group we started above. This is very important to remember!
			GUI.EndGroup ();
		}
	}
}
