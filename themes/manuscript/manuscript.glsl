// Vellum: what is behind the pane, faint and yellowed through a sheet of
// calfskin with its fibres and grain, and the ink soaked into the sheet
// along its torn edges.

const vec3 PANEL = vec3(0.984, 0.961, 0.902); // manuscript's panel, #fbf5e6
const vec3 INK = vec3(0.30, 0.22, 0.14);      // iron gall, browned
const float SOAK = 9.0;                        // how far the ink spreads in, in logical pixels

float hash(vec2 p) { return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453); }

float noise(vec2 p) {
	vec2 i = floor(p), f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x),
	           mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x), f.y);
}

vec3 behind(vec2 coord) {
	vec3 sum = vec3(0.0);
	for (int i = 0; i < 8; i++) {
		float a = float(i) * 2.39996, r = sqrt((float(i) + 0.5) / 8.0) * 3.0 * iScale;
		sum += texture(iChannel0, clamp((coord + r * vec2(cos(a), sin(a))) / iResolution.xy, 0.0, 1.0)).rgb;
	}
	return sum / 8.0;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 p = fragCoord / iScale;

	float l = dot(behind(fragCoord), vec3(0.299, 0.587, 0.114));
	vec3 sepia = mix(vec3(0.45, 0.35, 0.22), vec3(0.96, 0.91, 0.78), l);
	vec3 color = mix(PANEL, sepia, 0.3);

	float fibres = noise(p * vec2(0.05, 0.6)) * 0.6 + noise(p * 0.15) * 0.4;
	color *= 0.955 + 0.06 * fibres - 0.035 * step(0.985, hash(floor(p)));

	float inside = -iShape(fragCoord) / iScale;
	float reach = SOAK * (0.5 + noise(p * 0.08));
	float soaked = smoothstep(reach, 0.0, inside) * (0.6 + 0.4 * noise(p * 0.4));
	color = mix(color, INK, soaked * 0.4);

	fragColor = vec4(color, 1.0);
}
