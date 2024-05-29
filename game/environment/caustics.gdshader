shader_type spatial;


uniform float travel_length: hint_range(0.0, 8.0, 0.1) = 4.0;
uniform float travel_speed : hint_range(0.1, 4.0, 0.1) = 2.0;
uniform float sharpness: hint_range(0.8, 1.2, 0.01) = 0.9;

//TODO, try to get a baked noise working, better performance I guess
//uniform sampler2D worley_noise: hint_default_white;
uniform sampler2D color_ramp;


vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}

float worley(vec2 uv, float columns, float rows) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 0.99;  
	
	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			minimum_dist = min(minimum_dist, dist);
		}
	}
	
	return minimum_dist;
}

varying vec3 world_coordinates;

void vertex() {
	world_coordinates = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float worley = worley(world_coordinates.xz + sin(TIME / travel_speed) * travel_length, 0.3f, 0.3f);
	
	//float color = texture(worley_noise, world_coordinates.xz + sin(TIME / travel_speed) * travel_length).r;
	
	float color = texture(color_ramp, vec2(worley)).r;
	color = log(sharpness) / log(color);
	
	EMISSION = vec3(color);
	ALPHA = color;
}

//alternative solution, maybe
//
//uniform sampler2D caustics_bw : hint_default_white;
//uniform float slowdown : hint_range( 0.1, 10.0, 0.1 ) = 5.0;
//uniform float time_caust : hint_range( 0.01, 1.0, 0.01 ) = 0.13;
//uniform float tile_caust: hint_range( 0.1, 16.0, 0.1 ) = 4.0;
//uniform float tile_ground: hint_range( 0.1, 16.0, 0.1 ) = 8.0;
//
//
//void fragment() {
	//// caustics_bw
	//vec2 caustics_bw_uv1 = UV * (tile_caust + sin(TIME / slowdown) * time_caust);
	//vec2 caustics_bw_uv2 = UV * (tile_caust + cos(TIME / slowdown) * time_caust);
	//
	//float caustics_bw1_read = texture(caustics_bw, caustics_bw_uv1.xy).r;
	//float caustics_bw2_read = texture(caustics_bw, caustics_bw_uv2.yx).r;
	//
	//// ground_rgb
	////vec3 ground_rgb_read = texture(COLOR.rgb, UV * (tile_ground)).rgb;
	//
	//ALPHA_SCISSOR_THRESHOLD = caustics_bw1_read * caustics_bw2_read;
	//ALBEDO.rgb *= caustics_bw1_read * caustics_bw2_read;
	////ALPHA = caustics_bw1_read * caustics_bw2_read;
//
//}