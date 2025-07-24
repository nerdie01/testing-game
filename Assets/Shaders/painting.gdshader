#define SECTOR_COUNT 4

shader_type canvas_item;

// const vec2 KERNEL[41] = {vec2(0,0), vec2(0,1), vec2(0,2), vec2(0,3), vec2(0,4), vec2(0,5), vec2(0,6), vec2(1,0), vec2(1,1), vec2(1,2), vec2(1,3), vec2(1,4), vec2(1,5), vec2(1,6), vec2(2,0), vec2(2,1), vec2(2,2), vec2(2,3), vec2(2,4), vec2(2,5), vec2(2,6), vec2(3,0), vec2(3,1), vec2(3,2), vec2(3,3), vec2(3,4), vec2(3,5), vec2(4,0), vec2(4,1), vec2(4,2), vec2(4,3), vec2(4,4), vec2(4,5), vec2(5,0), vec2(5,1), vec2(5,2), vec2(5,3), vec2(5,4), vec2(6,0), vec2(6,1), vec2(6,2)};

uniform int kernel_size = 5;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void quadrant_average(sampler2D tex, vec2 uv, vec2 offset, vec2 res, out vec3 average_color, out float variance) { 
	vec3 color_sum = vec3(0.0);
	
	vec3 max_point = vec3(0.0);
	vec3 min_point = vec3(255.0);
	
	for (int i = 0; i < kernel_size; i++) {
		for (int j = 0; j < kernel_size; j++) {
			vec2 uv_offset = (vec2(float(i), float(j)) * offset) / res;
			vec3 point = texture(tex, uv + uv_offset).rgb;
			
			color_sum += point;
			max_point = max(point, max_point);
			min_point = min(point, min_point);
		}

	}
	
	average_color = color_sum / float(kernel_size * kernel_size);
	variance = dot((max_point - min_point), (max_point - min_point));
}

void fragment() {
	vec2 resolution = vec2(textureSize(screen_texture, 0));
	vec4 screen_color = textureLod(screen_texture, SCREEN_UV, 0.0);
	
	vec3 kernel_avg_colors[SECTOR_COUNT];
	float kernel_variances[SECTOR_COUNT];
	
	quadrant_average(screen_texture, UV, vec2(-1, -1), resolution, kernel_avg_colors[0], kernel_variances[0]);
	quadrant_average(screen_texture, UV, vec2(-1, 1), resolution, kernel_avg_colors[1], kernel_variances[1]);
	quadrant_average(screen_texture, UV, vec2(1, -1), resolution, kernel_avg_colors[2], kernel_variances[2]);
	quadrant_average(screen_texture, UV, vec2(1, -1), resolution, kernel_avg_colors[3], kernel_variances[3]);
	
	vec3 color = kernel_avg_colors[0];
	float min_variance = kernel_variances[0];
	
	for (int i = 0; i < SECTOR_COUNT; i++) {
		if (kernel_variances[i] < min_variance) {
			color = kernel_avg_colors[i];
			min_variance = kernel_variances[i];
		}
	}
	
	COLOR.rgb = color;
}