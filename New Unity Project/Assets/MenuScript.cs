using UnityEngine;
using System.Collections;

public class MenuScript : MonoBehaviour {

	void OnGUI () {
		// Make a group on the center of the screen
		GUI.BeginGroup (new Rect (Screen.width / 2 - 50, Screen.height / 2 , 100, 100));
		// All rectangles are now adjusted to the group. (0,0) is the topleft corner of the group.

		// We'll make a box so you can see where the group is on-screen.
		GUI.Box (new Rect (0,0,100,100), "Menu");
		if (GUI.Button (new Rect (10,25,80,30), "Start Game")){
			Application.LoadLevel("mainScene");		
		}
		if (GUI.Button (new Rect (10,65,80,30), "Quit")){
			Application.Quit();
		}

		// End the group we started above. This is very important to remember!
		GUI.EndGroup ();
	}

}
