// CRT: what is behind the pane, shown on a green phosphor tube. The glass
// bulges toward the edges, every third line is dark, the bright parts
// bloom, and the picture flickers faintly as a refresh rolls up it.

const vec3 PANEL = vec3(0.012, 0.063, 0.031);  // phosphor's panel, #031008
const vec3 GREEN = vec3(0.22, 1.0, 0.42);      // its accent, #39ff6a
const float BULGE = 0.10;                       // how far the glass curves
const float BLOOM = 6.0;                        // how far light spreads, in logical pixels
const int TAPS = 12;

float lum(vec3 c) { return dot(c, vec3(0.299, 0.587, 0.114)); }

float behind(vec2 coord) {
	return lum(texture(iChannel0, clamp(coord / iResolution.xy, 0.0, 1.0)).rgb);
}

float bloom(vec2 coord, float radius) {
	float sum = 0.0;
	for (int i = 0; i < TAPS; i++) {
		float r = sqrt((float(i) + 0.5) / float(TAPS)) * radius;
		float a = float(i) * 2.39996;
		sum += behind(coord + r * vec2(cos(a), sin(a)));
	}
	return sum / float(TAPS);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 c = fragCoord / iResolution.xy - 0.5;
	vec2 coord = (c * (1.0 + BULGE * dot(c, c)) + 0.5) * iResolution.xy;

	float v = behind(coord) * 0.7 + bloom(coord, BLOOM * iScale) * 0.3;
	vec3 color = PANEL + GREEN * v * 0.16;

	float line = mod(fragCoord.y / iScale, 3.0);
	color *= line < 1.0 ? 0.6 : 1.0;

	float roll = fract(fragCoord.y / iResolution.y - iTime * 0.12);
	color += GREEN * 0.035 * smoothstep(0.9, 1.0, roll);
	color *= 0.97 + 0.03 * sin(iTime * 9.0) * sin(iTime * 2.3);

	color *= 1.0 - 0.6 * dot(c, c); // darker toward the curved edges
	fragColor = vec4(color, 1.0);
}
