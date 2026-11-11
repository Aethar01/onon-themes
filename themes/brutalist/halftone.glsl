// Halftone: the pane printed as a coarse screen of dots at 45 degrees,
// growing toward the bottom right as though the hard shadow beneath it
// shows through the paper. Black on white, or white on black when
// alternate colours are on.
//
// It draws no backdrop: what is behind a brutalist pane is its own shadow.

const float CELL = 7.0;  // the screen's pitch, in logical pixels
const float INK = 0.35;  // how strongly the dots print

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	float size = CELL * iScale;
	mat2 turn = mat2(0.7071, 0.7071, -0.7071, 0.7071);
	vec2 q = turn * fragCoord;
	vec2 centre = (floor(q / size) + 0.5) * size;
	vec2 at = transpose(turn) * centre;

	vec2 uv = clamp(at / iResolution.xy, 0.0, 1.0);
	float toward = (uv.x + 1.0 - uv.y) * 0.5; // 0 at the top left, 1 at the bottom right
	float dark = 0.04 + 0.5 * toward * toward;
	float radius = sqrt(dark) * size * 0.62;
	float dot_ = 1.0 - smoothstep(radius - iScale * 0.5, radius + iScale * 0.5, length(q - centre));

	vec3 paper = iAlt > 0.5 ? vec3(0.0) : vec3(1.0);
	vec3 ink = vec3(1.0) - paper;
	fragColor = vec4(mix(paper, ink, dot_ * INK), 1.0);
}
