// LCD: what is behind the pane, on the handheld's screen: big pixels in
// its four greens, shades between them made by ordered dithering, and the
// faint grid between the pixels.

const float PIXEL = 3.0; // in logical pixels
const vec3 SHADES[4] = vec3[4](
	vec3(0.059, 0.220, 0.059), // darkest, #0f380f
	vec3(0.188, 0.384, 0.188), // dark, #306230
	vec3(0.545, 0.675, 0.059), // light, #8bac0f
	vec3(0.608, 0.737, 0.059)  // lightest, #9bbc0f
);
const float BAYER[16] = float[16](
	0.0, 8.0, 2.0, 10.0,
	12.0, 4.0, 14.0, 6.0,
	3.0, 11.0, 1.0, 9.0,
	15.0, 7.0, 13.0, 5.0
);

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	float size = PIXEL * iScale;
	vec2 cell = floor(fragCoord / size);
	vec3 behind = texture(iChannel0, clamp((cell + 0.5) * size / iResolution.xy, 0.0, 1.0)).rgb;

	// Kept light, so the pane's dark text reads over it.
	float l = 0.55 + 0.45 * dot(behind, vec3(0.299, 0.587, 0.114));
	ivec2 b = ivec2(mod(cell, 4.0));
	float threshold = (BAYER[b.y * 4 + b.x] + 0.5) / 16.0 - 0.5;
	int shade = int(clamp(floor(l * 3.0 + threshold + 0.5), 0.0, 3.0));
	vec3 color = SHADES[shade];

	vec2 within = mod(fragCoord, size);
	if (min(within.x, within.y) < iScale * 0.6) {
		color = mix(color, SHADES[1], 0.18);
	}
	fragColor = vec4(color, 1.0);
}
