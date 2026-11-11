// Nosferatu: what is behind the pane, dim and drained of colour, with
// blood seeping in from the edges, its reach rising and falling with a
// slow heartbeat.

const vec3 PANEL = vec3(0.090, 0.047, 0.059); // vampire's panel, #170c0f
const vec3 BLOOD = vec3(0.54, 0.04, 0.12);    // #8a0a1f
const float REACH = 26.0;                      // how far in the blood seeps at most, in logical pixels

vec3 behind(vec2 coord) {
	vec3 sum = vec3(0.0);
	for (int i = 0; i < 8; i++) {
		float a = float(i) * 2.39996, r = sqrt((float(i) + 0.5) / 8.0) * 4.0 * iScale;
		sum += texture(iChannel0, clamp((coord + r * vec2(cos(a), sin(a))) / iResolution.xy, 0.0, 1.0)).rgb;
	}
	return sum / 8.0;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	float l = dot(behind(fragCoord), vec3(0.299, 0.587, 0.114));
	vec3 color = PANEL + l * vec3(0.10, 0.07, 0.075);

	// Two beats close together, then a long rest.
	float t = fract(iTime / 1.6);
	float beat = exp(-pow(t * 9.0, 2.0)) + 0.6 * exp(-pow((t - 0.22) * 9.0, 2.0));
	float reach = REACH * (0.55 + 0.45 * beat);

	float inside = -iShape(fragCoord) / iScale;
	float seep = smoothstep(reach, 0.0, inside);
	color = mix(color, BLOOD, seep * seep * 0.75);

	fragColor = vec4(color, 1.0);
}
