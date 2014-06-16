using UnityEngine;
using System.Collections;

/// <summary>
/// Properties used to define shape, position, and size of the line being displayed via the shader and in world space.
/// </summary>
public struct LineProperties
{
	/// <summary> Defines the initial position of the line. </summary>
	public Vector4 Position = new Vector4(0.0f, 0.0f, 0.0f, 1.0f);
	/// <summary> Defines the speed at which the line changes vertical position. </summary>
	public float YVelocity = 0.02f;
	/// <summary> Defines the current offset of the sine wave. </summary>
	public float SineOffset = 0.05f;
	/// <summary> Defines the speed at which the sine wave moves. </summary>
	public float OffsetVelocity = 0.05f;
	/// <summary> Defines the horizontal magnitude of the line (e.g. space between each wave)y>
	public float SineHMagnitude = 1.0f;
	/// <summary> Defines the vertical magnitude of the line (e.g. how high each wave is)y>
	public float SineVMagnitude = 1.0f;
}
