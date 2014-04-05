using UnityEngine;
using System.Collections;

public class LineMove : MonoBehaviour {
	public int lineSpeed = 4;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update() 
	{
		transform.Translate(Vector3.right * (Time.deltaTime*lineSpeed), Camera.main.transform);
	}
}
