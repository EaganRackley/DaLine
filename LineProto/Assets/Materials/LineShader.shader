Shader "LineShader" {
   Properties {
      m_LinePoint ("Specifies a vector in world space where the line is drawn", Vector) = (0., 0., 0., 1.0)
      m_ColorAbove ("Color above the specified point", Color) = (0.0, 1.0, 0.0, 1.0)
      m_ColorBelow ("Color below the specified point", Color) = (0.3, 0.3, 0.3, 1.0)
      _MainTex ("Texture", 2D) = "white" {}
      _AltTex  ("Alternative Texture", 2D) = "white" {}
   }
 
   SubShader {
      Pass {
		 		 
         GLSLPROGRAM
 
         // uniforms variables (don't change as rendering happens) corresponding to properties
         uniform sampler2D _MainTex;
         uniform sampler2D _AltTex; 
         uniform vec4 _MainTex_ST;          
         uniform vec4 m_LinePoint;
         uniform vec4 m_ColorAbove;
         uniform vec4 m_ColorBelow;
         
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
 			if( worldSpacePosition.y > m_LinePoint.y )
            {
               //gl_FragColor = m_ColorAbove;
               //gl_FragColor = texture2D(_MainTex, vec2(textureCoordinates));               
               vec4 texture = texture2D(_MainTex, _MainTex_ST.xy * textureCoordinates.xy + _MainTex_ST.zw);
               gl_FragColor = vec4(texture.rgb * (m_ColorBelow * texture.a + (1. - texture.a)), 1);
            }
            else
            {
               //gl_FragColor = m_ColorBelow;
               vec4 texture = texture2D(_AltTex, _MainTex_ST.xy * textureCoordinates.xy + _MainTex_ST.zw);
               gl_FragColor = vec4(texture.rgb * (m_ColorBelow * texture.a + (1. - texture.a)), 1);
            }
         }
 
         #endif
 
         ENDGLSL
      }
   }
}