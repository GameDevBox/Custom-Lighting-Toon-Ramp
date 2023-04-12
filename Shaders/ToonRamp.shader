// Define a new shader called "ToonRamp" under the "GameDevBox" category
Shader "GameDevBox/ToonRamp"
{

    // Define the properties of the shader
    Properties
    {
        _ToonRampTex ("Toon Ramp Texture", 2D) = "white"{} // Texture ramp property for the shader
        _Color ("Color", Color) = (1,1,1,1) // Color property for the shader
    }

    // Define the sub-shader, which includes the actual rendering code
    SubShader
    {
        // Use the CGPROGRAM directive to specify that we're using Cg/HLSL code
        CGPROGRAM
        // Use the ToonRamp lighting model for this sub-shader
        #pragma surface surf ToonRamp

        // Define the shader variables
        float4 _Color; // Color variable for the shader
        sampler2D _ToonRampTex; // Texture ramp variable for the shader

        // Define the custom lighting function that uses the ToonRamp lighting model
        float4 LightingToonRamp(SurfaceOutput  s, fixed3 lightDir, fixed atten)
        {
            // Calculate the dot product between the surface normal and the light direction
            float diff = dot(s.Normal, lightDir);

            // Convert the dot product value to a range between 0 and 1
            float h = diff * 0.5 + 0.5;

            // Create a float2 vector using the converted dot product value
            float2 rh = h;

            // Use the ramp texture to determine the shading value based on the dot product value
            float3 ramp = tex2D(_ToonRampTex, rh).rgb;

            // Combine the albedo, light color, and shading value to create the final color
            float4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
            c.a = s.Alpha;
            return c;
        }

        // Define the input structure for the surface shader
        struct Input
        {
            float2 uv_MainTex;
        };

        // Define the surface shader function
        void surf(Input IN, inout SurfaceOutput  o)
        {
            // Set the albedo value to the _Color property
            o.Albedo = _Color.rgb;
        }

        // End the Cg/HLSL code block
        ENDCG
    }

    // Use the "Diffuse" shader as a fallback if the current shader is not supported
    FallBack "Diffuse"

}