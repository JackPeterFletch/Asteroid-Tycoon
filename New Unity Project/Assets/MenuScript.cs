using UnityEngine;
using System.Collections;

public class MenuScript : MonoBehaviour {

	void OnGUI () {
        GUI.TextArea(new Rect((Screen.width - 220),(Screen.height - 700),80,20),"CONTROLS");
        GUI.TextArea(new Rect((Screen.width - 260),(Screen.height - 670),160,230),
			"Up: Increase Thrust" + System.Environment.NewLine +
			System.Environment.NewLine +
			"Down: Decrease Thrust" + System.Environment.NewLine +
			System.Environment.NewLine +
			"W: Pitch Down" + System.Environment.NewLine +
			System.Environment.NewLine +
			"S: Pitch Up" + System.Environment.NewLine +
			System.Environment.NewLine +
			"X: Zoom Out" + System.Environment.NewLine +
			System.Environment.NewLine +
        	"Z: Zoom In" + System.Environment.NewLine +
			System.Environment.NewLine +
			"G: Gyroscope On/Off" + System.Environment.NewLine +
			System.Environment.NewLine +
			"Spacebar: Grabber On/Off" + System.Environment.NewLine);

	// We'll make a box so you can see where the group is on-screen.
		GUI.Box (new Rect ((Screen.width / 2),(Screen.height - 700),100,100), "Menu");
		if (GUI.Button (new Rect (((Screen.width / 2) + 10),(Screen.height - 675),80,30), "Start Game")){
			Application.LoadLevel("mainScene");		
		}
		if (GUI.Button (new Rect (((Screen.width / 2) + 10),(Screen.height - 635),80,30), "Quit")){
			Application.Quit();
		}
	}
}
