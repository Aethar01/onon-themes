// VHS: what is behind the pane, played back off a worn tape. Red and blue
// fringe apart, a tracking line drifts slowly down through it, and the
// rim glows neon, pink fading to cyan and back.

const vec3 PANEL = vec3(0.114, 0.043, 0.239); // synthwave's panel, #1d0b3d
const vec3 PINK = vec3(1.0, 0.184, 0.702);    // #ff2fb3
const vec3 CYAN = vec3(0.184, 0.953, 1.0);    // #2ff3ff
const float FRINGE = 2.5;                      // how far red and blue split, in logical pixels
const float GLOW = 7.0;                        // how far in the rim glows, in logical pixels

float hash(vec2 p) { return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453); }

vec3 behind(vec2 coord) {
	return texture(iChannel0, clamp(coord / iResolution.xy, 0.0, 1.0)).rgb;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 uv = fragCoord / iResolution.xy;

	// The tracking line: a band moving down that tears the lines it crosses.
	float y = fract(1.0 - iTime * 0.05);
	float band = smoothstep(0.08, 0.0, abs(uv.y - y));
	float row = floor(fragCoord.y / (2.0 * iScale));
	float tear = band * (hash(vec2(row, floor(iTime * 24.0))) - 0.5) * 16.0 * iScale;

	vec2 coord = fragCoord + vec2(tear, 0.0);
	float split = FRINGE * iScale * (1.0 + 2.0 * band);
	vec3 color = vec3(behind(coord + vec2(split, 0.0)).r,
	                  behind(coord).g,
	                  behind(coord - vec2(split, 0.0)).b);
	color = mix(PANEL, color * vec3(1.0, 0.7, 1.1), 0.22);
	color += band * 0.12 * hash(fragCoord + iTime);

	float inside = -iShape(fragCoord) / iScale;
	vec3 neon = mix(PINK, CYAN, 0.5 + 0.5 * sin(uv.x * 3.0 + iTime * 0.7));
	color += neon * exp(-inside / GLOW) * 0.85;

	fragColor = vec4(color, 1.0);
}
