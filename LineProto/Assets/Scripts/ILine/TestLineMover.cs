using UnityEngine;
using System.Collections;

public class TestLineMover : MonoBehaviour {

	Vector4 ShaderPoint = new Vector4(1.0f, 0.0f, 0.0f, 1.0f);
	public float MoveVelocity = 0.02f;
	public float HMagnitude = 1.0f;
	public float VMagnitude = 1.0f;
	public float SineOffsetVel = 0.05f;
	public bool ChangePosition = true;
	public bool ChangeShader = false;
	private float myCount = 0.0f;
	private float myMoveCount = 0.0f;
	private float mySineOffset = 0.0f;
	private float myMagnitudeCounter = 0.0f;
	public Vector3 rot = new Vector3(0.0f, 1.0f, 0.0f);
	private float hMag;
	private float vMag;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {

		myCount+=0.01f;
		myMoveCount += MoveVelocity;

		if (ChangePosition) 
		{
			Vector3 pos = this.transform.position;
			pos.y = Mathf.Cos (myMoveCount) * 10.0f;
			this.transform.position = pos;
		}
		if (ChangeShader) 
		{
			ShaderPoint.y = Mathf.Sin (myCount) * 1.0f;
			myMagnitudeCounter += Time.deltaTime;
			if(myMagnitudeCounter > 1.0f) myMagnitudeCounter = 0.0f;
			hMag = HMagnitude; //Mathf.Lerp(0.0f, HMagnitude, myMagnitudeCounter);
			vMag = Mathf.Lerp(0.0f, VMagnitude, Mathf.Sin (myCount/2));
			renderer.sharedMaterial.SetVector("_LinePoint", ShaderPoint);
			renderer.sharedMaterial.SetFloat("_SineOffset", mySineOffset);
			renderer.sharedMaterial.SetFloat("_SineHMagnitude", hMag);
			renderer.sharedMaterial.SetFloat("_SineVMagnitude", vMag);
			mySineOffset += SineOffsetVel;
		}
		//this.transform.Rotate (rot);
	}

	void OnDrawGizmos()
	{
		Gizmos.color = Color.yellow;

		for (float x = -24.0f; x < 24.0f; x += 1.0f) 
		{
			Vector3 drawAt = new Vector3( x, transform.position.y, 0.0f );
			drawAt.y = Mathf.Sin(mySineOffset + drawAt.x / (hMag * 23f)) * (vMag * 14f) + (ShaderPoint.y * 12f);
			Gizmos.DrawCube (drawAt, new Vector3 (0.1f, 0.1f, 0.1f));
		}
	}
}
