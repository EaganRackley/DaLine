using UnityEngine;
using System.Collections;

public class TestLineMover : MonoBehaviour {

	Vector4 ShaderPoint = new Vector4(1.0f, 0.0f, 0.0f, 1.0f);
	public float MoveVelocity = 0.02f;
	public float HMagnitude = 1.0f;
	public float VMagnitude = 1.0f;
	public float SineOffsetVel = 0.05f;
	public bool ChangePosition = true;
	private float myCount = 0.0f;
	private float myMoveCount = 0.0f;
	private float mySineOffset = 0.0f;
	public Vector3 rot = new Vector3(0.0f, 1.0f, 0.0f);
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		myCount+=0.01f;
		myMoveCount += MoveVelocity;
		ShaderPoint.y = Mathf.Sin (myCount) * 10.0f;
		if (ChangePosition) 
		{
			Vector3 pos = this.transform.position;
			pos.y = Mathf.Cos (myMoveCount) * 10.0f;
			this.transform.position = pos;
			renderer.sharedMaterial.SetVector("_LinePoint", ShaderPoint);
			renderer.sharedMaterial.SetFloat("_SineOffset", mySineOffset);
			renderer.sharedMaterial.SetFloat("_SineHMagnitude", HMagnitude);
			renderer.sharedMaterial.SetFloat("_SineVMagnitude", VMagnitude);
			mySineOffset += SineOffsetVel;
		}
		//this.transform.Rotate (rot);
	}
}
