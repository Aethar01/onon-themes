// Liquid glass: what is behind the pane, blurred, and at the rim, as at
// the thick edge of a lens, what lies just beyond it bent in, with its
// colours split a little and light caught along the edge.

const float RIM = 18.0;   // how far in from the edge the glass bends, in logical pixels
const float REACH = 24.0; // how far beyond the edge the rim draws from: with the blur
                          // and the split, within the 32 iBackdrop reaches
const float BLUR = 5.0;   // how soft the glass is
const int TAPS = 20;

vec3 soft(vec2 coord, float radius) {
	vec3 sum = vec3(0.0);
	for (int i = 0; i < TAPS; i++) {
		float r = sqrt((float(i) + 0.5) / float(TAPS)) * radius;
		float a = float(i) * 2.39996;
		sum += iBackdrop(coord + r * vec2(cos(a), sin(a))).rgb;
	}
	return sum / float(TAPS);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	float inside = -iShape(fragCoord);
	float t = clamp(1.0 - inside / (RIM * iScale), 0.0, 1.0); // 1 at the edge
	vec2 n = vec2(iShape(fragCoord + vec2(1.0, 0.0)) - iShape(fragCoord - vec2(1.0, 0.0)),
	              iShape(fragCoord + vec2(0.0, 1.0)) - iShape(fragCoord - vec2(0.0, 1.0)));
	n = dot(n, n) > 0.0 ? normalize(n) : vec2(0.0);
	vec2 bend = n * t * t * t * REACH * iScale;
	float blur = BLUR * iScale;
	vec3 color = vec3(soft(fragCoord + bend * 1.12, blur).r,
	                  soft(fragCoord + bend, blur).g,
	                  soft(fragCoord + bend * 0.88, blur).b);
	float grey = dot(color, vec3(0.299, 0.587, 0.114));
	color = mix(vec3(grey), color, 1.35);
	float light = pow(t, 5.0) * (0.25 + 0.75 * abs(dot(n, normalize(vec2(-1.0, 1.0)))));
	color += light * 0.45;
	fragColor = vec4(color, 1.0);
}
