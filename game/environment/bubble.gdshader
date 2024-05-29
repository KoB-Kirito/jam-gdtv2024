shader_type spatial;


uniform sampler2D noise_texture;
uniform float smoothness : hint_range(0.0, 1.0, 0.1) = 0.1;

varying vec3 world_position;


void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float height = texture(noise_texture, VERTEX.xz * smoothness + vec2(TIME * 0.05)).r;
	VERTEX += NORMAL * height * 0.4;
}


float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}


void fragment() {
	float fresnel = fresnel(1.0, NORMAL, VIEW);
	ALPHA = fresnel;
	ROUGHNESS = 0.0;
}


