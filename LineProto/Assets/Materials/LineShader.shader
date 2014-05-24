Shader "LineShader" {
   Properties {
      _LinePoint ("Specifies a vector in world space where the line is drawn", Vector) = (0., 0., 0., 1.0)
      _ColorAbove ("Color above the specified point", Color) = (0.0, 1.0, 0.0, 1.0)
      _ColorBelow ("Color below the specified point", Color) = (0.3, 0.3, 0.3, 1.0)      
      _MainTex ("Texture", 2D) = "white" {}
      _AltTex  ("Alternative Texture", 2D) = "white" {}
      _SineOffset ("Offset value for sine wave.", Float) = 0.0
      _SineHMagnitude ("Horizontal magnitude for sine wave.", Float) = 0.0
      _SineVMagnitude ("Vertical magnitude for sine wave.", Float) = 0.0
   }
 
   SubShader {
      Pass {
		 		 
         GLSLPROGRAM
 
         // uniforms variables (don't change as rendering happens) corresponding to properties
         uniform sampler2D _MainTex;
         uniform sampler2D _AltTex; 
         uniform vec4 _MainTex_ST;          
         uniform vec4 _LinePoint;
         uniform vec4 _ColorAbove;
         uniform vec4 _ColorBelow;
         uniform float _SineOffset;
         uniform float _SineHMagnitude;
         uniform float _SineVMagnitude;
         
         // Varying variables used to pass info to the fragment shader
         varying vec2 textureCoordinates; 
                  
         #include "UnityCG.glslinc" 
            // defines _Object2World and _World2Object
 
         varying vec4 worldSpacePosition;
 
         #ifdef VERTEX
 
         void main()
         {
         	textureCoordinates = vec2(gl_MultiTexCoord0);
         	
            mat4 modelMatrix = _Object2World;
 
            worldSpacePosition = modelMatrix * gl_Vertex;
 
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
               gl_FragColor = vec4(texture.rgb * (_ColorBelow * texture.a + (1. - texture.a)), 1);
            }
            else
            {
               //gl_FragColor = _ColorBelow;
               //gl_FragColor = texture2D(_AltTex, vec2(textureCoordinates));               
               vec4 texture = texture2D(_AltTex, _MainTex_ST.xy * textureCoordinates.xy + _MainTex_ST.zw);
               gl_FragColor = vec4(texture.rgb * (_ColorBelow * texture.a + (1. - texture.a)), 1);
            }
         }
 
         #endif
 
         ENDGLSL
      }
   }
}