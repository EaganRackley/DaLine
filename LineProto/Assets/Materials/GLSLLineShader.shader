Shader "LineShader" {
   Properties {
      _LinePoint ("Specifies a vector in world space where the line is drawn", Vector) = (0., 0., 0., 1.0)
      _Color ("Alpha Color Key", Color) = (0, 0, 0, 1)
      _MainTex ("Texture", 2D) = "white" {}
      _AltTex  ("Alternative Texture", 2D) = "white" {}
      _SineOffset ("Offset value for sine wave.", Float) = 0.0
      _SineHMagnitude ("Horizontal magnitude for sine wave.", Float) = 0.0
      _SineVMagnitude ("Vertical magnitude for sine wave.", Float) = 0.0
   }
 
   SubShader {
   
 	  	Tags
		{
			"RenderType" = "Opaque"
			"Queue" = "Transparent+1"
		}
 
      Pass {
		 		 
         GLSLPROGRAM
 
         // uniforms variables (don't change as rendering happens) corresponding to properties
         uniform sampler2D _MainTex;
         uniform sampler2D _AltTex; 
         uniform vec4 _MainTex_ST;          
         uniform vec4 _LinePoint;
         uniform vec4 _Color;
         uniform float _SineOffset;
         uniform float _SineHMagnitude;
         uniform float _SineVMagnitude;
         
         // Varying variables used to pass info to the fragment shader
         varying vec2 textureCoordinates; 
         
         // defines _Object2World and _World2Object                        
         #include "UnityCG.glslinc" 
		    
         varying vec4 worldSpacePosition;
 
         #ifdef VERTEX
 
         float rand(vec2 co){
 		   return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	     }
 
 		 void main()
         {
         	textureCoordinates = vec2(gl_MultiTexCoord0);
         	
            mat4 modelMatrix = _Object2World;
 
            worldSpacePosition = modelMatrix * gl_Vertex;
            
            //float sinYComparison = sin(_SineOffset + gl_Vertex.x / _SineHMagnitude) * _SineVMagnitude + _LinePoint.y;
            //xOffset = rand( new vec2((0.001 * _TimeDelta * gl_Vertex.x), 0.1 * _TimeDelta) ) * 0.1;
           	//yOffset = rand( new vec2((0.001 * _TimeDelta * gl_Vertex.y), 0.1 * _TimeDelta) ) * 0.1;	                        
            //targetYOffset = rand( new vec2(_RandomSeed + gl_Vertex.y, _RandomSeed + gl_Vertex.x) );                      	
           	//vec4 wigglyVertex = new vec4(gl_Vertex.x + xOffset, gl_Vertex.y + yOffset, gl_Vertex.z, 1.0);
 
           	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex; 
                                  
         }
 
         #endif
 
         #ifdef FRAGMENT
         
         void main()
         { 			
         	float sinYComparison = sin(_SineOffset + worldSpacePosition.x / _SineHMagnitude) * _SineVMagnitude + _LinePoint.y;
         
 			if( worldSpacePosition.y > sinYComparison )
            {
               //gl_FragColor = _ColorAbove;
               //gl_FragColor = texture2D(_MainTex, vec2(textureCoordinates));               
               vec4 texture = texture2D(_MainTex, _MainTex_ST.xy * textureCoordinates.xy + _MainTex_ST.zw);
               if(texture.a < 0.1) 
               {
               	discard;
               }
               else
               {
               	gl_FragColor = vec4(texture.rgb * (_Color * texture.a + (1. - texture.a)), 1);
               }
            }
            else
            {
               //gl_FragColor = _ColorBelow;
               //gl_FragColor = texture2D(_AltTex, vec2(textureCoordinates));               
               vec4 texture = texture2D(_AltTex, _MainTex_ST.xy * textureCoordinates.xy + _MainTex_ST.zw);
               if(texture.a < 0.1) 
               {
               	discard;
               }
               else
               {
               	gl_FragColor = vec4(texture.rgb * (_Color * texture.a + (1. - texture.a)), 1);
               }
            }
         }
 
         #endif
 
         ENDGLSL
      }
   }
}