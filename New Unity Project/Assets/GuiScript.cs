using UnityEngine;
using System.Collections;

public class GuiScript : MonoBehaviour {

	void OnGUI() {
	//Make Background Box
		GUI.BeginGroup (new Rect (Screen.width / 2 - 50, (Screen.height / 2) + 150, 100, 100));
		
		GUI.Box (new Rect(0,0,100,90),"Menu");
		
		// Make the first button. If it is pressed, Application.Loadlevel (1) will be executed
		if(GUI.Button(new Rect(10,30,80,20), "Start!")) {
			Application.LoadLevel("mainScene");
		}
		
		// Make the first button. If it is pressed, Application.Loadlevel (1) will be executed
		if(GUI.Button(new Rect(10,60,80,20), "Quit")) {
			Application.Quit();
		}
	}
}
