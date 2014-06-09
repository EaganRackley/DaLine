Shader "CgLineShader" 
{
	Properties 
 	{
      _LinePoint ("Specifies a vector in world space where the line is drawn", Vector) = (0., 0., 0., 1.0)
      _Color ("Alpha Color Key", Color) = (0, 0, 0, 1)
      _MainTex ("Texture", 2D) = "white" {}
      _AltTex  ("Alternative Texture", 2D) = "white" {}
      _SineOffset ("Offset value for sine wave.", Float) = 0.0
      _SineHMagnitude ("Horizontal magnitude for sine wave.", Float) = 0.0
      _SineVMagnitude ("Vertical magnitude for sine wave.", Float) = 0.0
   	}
 
   	SubShader 
   	{
   		Tags
		{
			"RenderType" = "Opaque"
			"Queue" = "Transparent+1"
		}
 
      	Pass 
      	{
         	CGPROGRAM // here begins the part in Unity's Cg
         	
         	// uniform variables (don't change as rendering happens) corresponding to properties
         	uniform sampler2D _MainTex;
         	uniform sampler2D _AltTex; 
         	uniform float4 _MainTex_ST;          
         	uniform float4 _LinePoint;
         	uniform float4 _Color;
         	uniform float _SineOffset;
         	uniform float _SineHMagnitude;
         	uniform float _SineVMagnitude;
         	
         	// Specify the method to use for our vertex shader 
         	#pragma vertex vert 
            // Specify the method to use for our fragment shader 
         	#pragma fragment frag
         	
         	#include "UnityCG.cginc"
         	 
         	// This struct defines values that are used as outputs in the vertex shader 
         	// and values that are used as inputs in the fragment shader representing the position
         	// of the vertex in world space, and the texture coordinates stored in the vertex.
         	struct VERTEX_IN
			{
		    	float4 vertexPosition : SV_POSITION;
		    	float2 vtx_texcoord0 : TEXCOORD0;
			};

			struct FRAGMENT_IN
			{    			
    			float2 textureCoordinates: TEXCOORD0;
    			float4 position: POSITION;
    			float4 worldPosition : TEXCOORD1; // we can't use a POSITION value in the fragment shader, so using this instead.
			};
            
         	// Our vertex shader processes our texture and world space coordinates so that they can
         	// be used by the fragement shader in addition to specifying the actual position
         	// of the vertex in the v2f struct.
         	FRAGMENT_IN vert(VERTEX_IN input) 
            {
            	FRAGMENT_IN output;
            	output.worldPosition = mul(UNITY_MATRIX_MVP, input.vertexPosition);
            	output.position = mul(UNITY_MATRIX_MVP, input.vertexPosition);
            	output.textureCoordinates = input.vtx_texcoord0;
            	return output;            	
         	}// end vert
 
 			// Our fragment shader generates a sin wave based on our world space position and the shader
 			// properties defined above, and then evaluates whether to use _MainTex or _AltTex based on
 			// the position of the fragment in world space vs. the position of the sine wave in world space.
         	float4 frag(FRAGMENT_IN input) : COLOR
         	{
         		float sinYComparison = sin(_SineOffset + input.worldPosition.x / _SineHMagnitude) * _SineVMagnitude + _LinePoint.y;
         		float distance = abs(input.worldPosition.y - sinYComparison);
         		
         		float maxEffectDistance = 0.01;
         	
         		float4 textureColor;
         	
         		if( input.worldPosition.y > sinYComparison )
            	{
            		textureColor = tex2D(_MainTex, _MainTex_ST.xy * input.textureCoordinates.xy + _MainTex_ST.zw);
            	}
            	else
            	{
            		textureColor = tex2D(_AltTex, _MainTex_ST.xy * input.textureCoordinates.xy + _MainTex_ST.zw);
            	}
         		
         		if(textureColor.a < 0.1) 
               	{
               		discard;
               	}
               	
               	if( distance <= 0.02 )
         		{
         			textureColor = lerp(textureColor, _Color, 1.0 - (distance * 100.0 / 2.0));
         		}
               		
               	return float4(textureColor.rgb * (_Color * textureColor.a + (1. - textureColor.a)), 1);
               	         		
         	}// end frag
 
         	ENDCG // here ends the part in Cg 
         	
    	}// End Pass
    	
    } // End SubShader
    
}// End Shader