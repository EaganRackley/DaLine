using UnityEngine;
using System.Collections;

public class ToggleLight : MonoBehaviour 
{
	// Use this for initialization
	void Start () 
	{

	}
	
	// Update is called once per frame
	void Update () 
	{
		
	}

	void OnTriggerEnter(Collider collider) 
	{
		Debug.Log ("On Trigger Enter");
		if (collider.tag == "TheLine")
		{
			string currLight = gameObject.name; 
			Debug.Log(gameObject.name);
			GameObject lSource = GameObject.Find(currLight+"/Point light");
			lSource.light.enabled = true;
			//StartCoroutine(MyCoroutine(lSource));
			Debug.Log(lSource.light.intensity);
			//find child point light and enable light
		}
	}
	/*IEnumerator MyCoroutine(GameObject lSource)
	{
		int lIntes = lSource.light.intensity
		for(int i = lIntes; i >= 0; i--)
		{
				lSource.light.intensity -= 1;
				yield return new WaitForSeconds (0.5f);
		}
	}*/
}
