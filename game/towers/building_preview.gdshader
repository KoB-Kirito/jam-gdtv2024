shader_type spatial;
render_mode blend_mix, diffuse_toon, specular_disabled, ambient_light_disabled;

global uniform vec4 preview_color : source_color;

void fragment() {
	ALBEDO = preview_color.rgb;
	ALPHA = preview_color.a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
