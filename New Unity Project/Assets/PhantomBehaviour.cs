using UnityEngine;
using System.Collections;

public class PhantomBehaviour : MonoBehaviour {
	
	static float updates = 0F;
	public static bool wipe = false;
	public static System.Collections.Generic.List<Vector3> positions = null;
	public static LineRenderer lineRenderer;
	
	// Use this for initialization
	void Start () {
		var orbital_velocity = new Vector3(0,12000,0);
		this.rigidbody.velocity = orbital_velocity;
		this.transform.position = GameObject.Find("SpaceShuttleOrbiter").transform.position;
		positions = new System.Collections.Generic.List<Vector3>();
		
		lineRenderer = gameObject.AddComponent<LineRenderer>();
		lineRenderer.material = new Material (Shader.Find("Particles/Additive"));
        lineRenderer.SetColors(Color.blue, Color.blue);
		lineRenderer.SetWidth(10,10);
		lineRenderer.SetVertexCount(300);
	}
	
	// Update is called once per frame
	void Update(){
		
		var height = (this.transform.position - GameObject.Find("SpaceShuttleOrbiter").transform.position).magnitude;
		
		if(wipe){
			positions.Clear();
			lineRenderer.SetVertexCount(0);
			lineRenderer.SetVertexCount(300);
			wipe = false;
		}
		
		updates++;
		if(updates >= 2){
			updates = 0;
			if(positions.Count >= Mathf.Sqrt(height)*2){
				positions.RemoveAt(0);
			}
			if(positions.Count == 300){
				positions.RemoveAt(0);
			}
			Debug.Log (positions.Count);
			positions.Add(this.transform.position);
			BuildTrajectoryLine(positions);
		}
	}
		
	//Draw Line from set of positions
	void BuildTrajectoryLine(System.Collections.Generic.List<Vector3> positions){
		LineRenderer lineRenderer = GetComponent<LineRenderer>();
    	for (var i = 0; i < positions.Count; i++){
			lineRenderer.SetPosition(i, positions[i]);
	    }
	}
}
