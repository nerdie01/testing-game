shader_type spatial;

uniform float smoothstep_min = 0.01;
uniform float smoothstep_max = 0.03;

uniform vec3 main_color: source_color = vec3(1);

uniform bool specular = false;
uniform float specular_light = 40;
uniform float specular_falloff = 10;

uniform float edge_falloff = 4.0;

void fragment() {
	ALBEDO = main_color;
}

void light(){
	float n_dot_l = clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
	n_dot_l = smoothstep(smoothstep_min, smoothstep_max, n_dot_l);

	vec3 result = vec3(n_dot_l);
	DIFFUSE_LIGHT += result;

	if (specular) {
		vec3 camera_eff = normalize(VIEW + LIGHT);
		float v_dot_l = clamp(dot(NORMAL, camera_eff), 0.0, 1.0);
		v_dot_l = pow(v_dot_l, specular_light);
		v_dot_l = smoothstep(0.06, 0.1, v_dot_l);

		SPECULAR_LIGHT += v_dot_l;
	}
}