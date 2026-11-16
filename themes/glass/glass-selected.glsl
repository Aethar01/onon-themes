// Glass for the selection: the panes' glass, glass.glsl, but catching
// light all round its edge, a bead of glass, where the panes have only a
// thin highlight along the top, so the selection stands out over them
// without a colour of its own. Keep it as glass.glsl is but for its light.

const float BLUR = 5.0;          // how soft the glass is, in logical pixels
const int TAPS = 20;
const float REFRACTION = 8.0;    // how wide a band the lens bends, in logical pixels: narrow,
                                 // to keep to the rim, clear of the text inset from it
const float MAGNIFY = 0.1;       // how thick the lens is, for the pane's shorter side,
const float LENS = 24.0;         // up to this, in logical pixels, as thick as a dock is:
                                 // thicker, a tall menu would smear in what lies far inside it
const float RADIAL = 0.65;       // how much the lens draws from the centre, not straight in
const float DRIFT = 2.88;        // how far the colours drift apart at the rim, in logical pixels
const float RIM = 18.0;          // how far in light catches, in logical pixels

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
	float d = iShape(fragCoord);
	vec2 n = vec2(iShape(fragCoord + vec2(1.0, 0.0)) - iShape(fragCoord - vec2(1.0, 0.0)),
	              iShape(fragCoord + vec2(0.0, 1.0)) - iShape(fragCoord - vec2(0.0, 1.0)));
	n = dot(n, n) > 0.0 ? normalize(n) : vec2(0.0, 1.0); // outward

	// 1 at the edge, easing to 0 a band's width in.
	float edge = smoothstep(-REFRACTION * 1.25 * iScale, 0.0, d);
	edge *= edge;

	// The lens: drawn in from the centre and straight in from the edge
	// alike, so corners bend smoothly, as far as the pane is thick.
	vec2 size = iResolution.xy;
	vec2 local = (fragCoord - size * 0.5) / max(size * 0.5, vec2(1.0));
	vec2 radial = local / max(length(local), 0.001);
	vec2 dir = normalize(mix(n, radial, RADIAL));
	float thickness = min(min(size.x, size.y) * MAGNIFY * 3.5, LENS * iScale);
	vec2 lens = fragCoord - dir * thickness * edge;

	float blur = BLUR * iScale;
	vec3 color = soft(lens, blur);
	if (edge > 0.001) {
		vec2 drift = n * DRIFT * iScale;
		vec3 split = vec3(soft(lens + drift, blur).r,
		                  soft(lens + drift * 0.30, blur).g,
		                  soft(lens - drift * 0.25, blur).b);
		color = mix(color, split, edge);
	}

	float grey = dot(color, vec3(0.299, 0.587, 0.114));
	color = mix(vec3(grey), color, 1.35);

	// Light caught all round its edge, brightest at the top left and the
	// bottom right: a bead of glass, where the panes have only a thin
	// highlight along the top. Over what is light it whitens, never burns.
	float t = clamp(1.0 + d / (RIM * iScale), 0.0, 1.0); // 1 at the edge
	float light = pow(t, 5.0) * (0.25 + 0.75 * abs(dot(n, normalize(vec2(-1.0, 1.0)))));
	color = mix(color, vec3(1.0), clamp(light * 0.45, 0.0, 1.0));
	fragColor = vec4(color, 1.0);
}
