// Rain on the cabin window: what is behind the pane, dim and misted by the
// warmth inside, with rain on the glass. Beads land, swell and slowly dry.
// Now and then one grows heavy enough to run, holding and then slipping
// down the glass in sudden jerks, each in its own time, wandering a little
// as it goes and leaving a clear path and a few beads behind it. Another
// drop may find that path, and once it does it races down it to join the
// first, which swells. The drops bend what is behind them and catch the
// lamplight, and a fire low in the room breathes on the glass.

const vec3 PANEL = vec3(0.102, 0.133, 0.106);     // forest-rain's panel, #1a221b
const vec3 PANEL_ALT = vec3(0.090, 0.098, 0.082); // and its alt panel, #171915
const vec3 EMBER = vec3(0.890, 0.604, 0.298);     // its accent, #e39a4c
const vec3 NIGHT = vec3(0.70, 0.86, 0.78);        // the forest through the glass, cool and green
const float MIST = 4.0;                            // how misted the glass is, in logical pixels
const float BEND = 7.0;                            // how far a drop bends what is behind it
const vec2 CELL = vec2(50.0, 220.0);               // the cells drops run down, in logical pixels
const float RUNNING = 0.35;                        // how often a cell has a drop running down it, 0 to 1
const float JOINING = 0.45;                        // how often another drop joins it, 0 to 1
const float RACE = 220.0;                          // how fast a joining drop runs down a path, logical pixels a second
const float BEADS = 0.22;                          // how often a cell has a bead resting in it, 0 to 1
const int TAPS = 8;

float hash(vec2 p) { return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453); }

vec3 behind(vec2 coord) {
	return texture(iChannel0, clamp(coord / iResolution.xy, 0.0, 1.0)).rgb;
}

vec3 misted(vec2 coord, float radius) {
	vec3 sum = vec3(0.0);
	for (int i = 0; i < TAPS; i++) {
		float a = float(i) * 2.39996, r = sqrt((float(i) + 0.5) / float(TAPS)) * radius;
		sum += behind(coord + r * vec2(cos(a), sin(a)));
	}
	return sum / float(TAPS);
}

// Where a drop's path is across its cell at height y: mostly straight down,
// wandering as it finds its way between the beads.
float path(float y, float x0, vec2 seed) {
	return x0 + sin(y * 0.043 + seed.x * 6.28) * 2.2 + sin(y * 0.13 + seed.y * 6.28) * 0.9;
}

// How far down its run a drop is at tau seconds into it, 0 to 1. It holds,
// then slips, steps times over: each slip at a time of its own within its
// share of the run, quick, and carrying it a distance of its own.
float progress(float tau, float run, float steps, vec2 seed) {
	float total = 0.0, done = 0.0;
	for (int k = 0; k < 6; k++) {
		if (float(k) >= steps) break;
		vec2 s = seed + float(k) * vec2(3.7, 1.9);
		float w = 0.25 + hash(s);
		float start = (float(k) + 0.1 + 0.8 * hash(s + 0.4)) / steps * run * 0.9;
		float slip = 0.25 + 0.45 * hash(s + 0.8);
		float u = clamp((tau - start) / slip, 0.0, 1.0);
		total += w;
		done += w * u * (2.0 - u); // off at once, slowing as it catches
	}
	return done / total;
}

// A drop at c of radius r: heavier at its foot, drawn out above by stretch.
// Returns its slope in xy and how much of the glass it covers in z.
vec3 drop(vec2 f, vec2 c, float r, float stretch) {
	vec2 d = f - c;
	d.y *= d.y > 0.0 ? stretch : 1.15;
	float m = smoothstep(r, r * 0.55, length(d));
	return vec3(d / max(r, 0.001) * m, m);
}

// Drops running down the glass. The glass is cut into tall cells, each
// column of them shifted up or down by its own amount, and each cell runs
// one drop after another: a fresh drop, of its own size and in its own
// place, each time round, and sometimes a second that joins it. Returns
// the slope in xy, how much of the glass is wet in z, and the paths
// cleared in w.
vec4 running(vec2 p, float t) {
	float col = floor(p.x / CELL.x);
	vec2 q = vec2(p.x / CELL.x, p.y / CELL.y + hash(vec2(col, 0.0)));
	vec2 id = floor(q);
	vec2 f = fract(q) * CELL; // logical pixels from the cell's bottom left, y up

	float rate = 0.05 + 0.04 * hash(id + 0.5);
	float run = 1.0 / rate;
	float phase = t * rate + hash(id + 1.5);
	float life = fract(phase);
	float tau = life * run;
	vec2 cid = id + floor(phase) * vec2(7.31, 3.17);
	if (hash(cid) > RUNNING) return vec4(0.0);

	vec3 n = vec3(hash(cid + 1.1), hash(cid + 2.2), hash(cid + 3.3));
	float steps = 3.0 + floor(n.z * 4.0);
	float top = CELL.y * (0.8 + 0.1 * n.y), bottom = CELL.y * 0.06;
	float x0 = CELL.x * mix(0.25, 0.75, n.x);
	float shown = smoothstep(0.0, 0.03, life) * (1.0 - smoothstep(0.92, 1.0, life));
	float slid = progress(tau, run, steps, cid);
	float y = mix(top, bottom, slid);
	float r = min(mix(1.8, 4.4, n.y * n.y), CELL.x * 0.12) * mix(1.0, 0.75, slid);

	// Behind it, a clear path, narrowing and drying further up.
	float above = f.y - y;
	float cleared = above > 0.0 && f.y < top
		? smoothstep(r * 0.85, r * 0.25, abs(f.x - path(f.y, x0, n.xy))) * exp(-above / 70.0) : 0.0;

	// And beads left along it, at no even spacing, some to one side.
	vec3 wet = vec3(0.0);
	float gap = r * 2.6;
	float k = floor(f.y / gap);
	vec3 b = vec3(hash(cid + k * 1.37), hash(cid + k * 2.71), hash(cid + k * 4.13));
	float by = (k + 0.2 + 0.6 * b.y) * gap;
	if (b.x > 0.5 && by > y + r * 1.5 && by < top) {
		vec2 c = vec2(path(by, x0, n.xy) + (b.z - 0.5) * r * 0.8, by);
		wet = drop(f, c, r * (0.18 + 0.3 * b.z), 1.0);
	}

	// A second drop, above and to one side. It gathers, slides across into
	// the first one's path, then races down it, and joins the first.
	vec4 j = vec4(hash(cid + 5.1), hash(cid + 6.2), hash(cid + 7.3), hash(cid + 8.4));
	if (j.x < JOINING) {
		float t0 = run * (0.1 + 0.4 * j.y);
		float ya = mix(top, bottom, progress(t0, run, steps, cid));
		float y0 = min(ya + 30.0 + 70.0 * j.z, CELL.y - 8.0);
		float yj = y0 - 18.0 - 25.0 * j.w;
		float side = x0 < CELL.x * 0.5 ? 1.0 : -1.0;
		float off = side * (7.0 + 8.0 * fract(j.w * 13.0));
		float hold = 1.0 + 3.0 * fract(j.y * 11.0);
		float slide = 0.7 + 0.6 * fract(j.x * 17.0);
		float rj = r * (0.5 + 0.3 * fract(j.z * 29.0));

		// When it catches the first, found by following the first along:
		// where it is when the race starts, then where it has got to by the
		// time the second would reach there, and so on.
		float race = t0 + hold + slide;
		float caught = race;
		for (int i = 0; i < 3; i++) {
			float yc = mix(top, bottom, progress(caught, run, steps, cid));
			caught = race + max(yj - yc, 0.0) / RACE;
		}

		float yb = y0, stretch = 0.6;
		if (tau > race) {
			yb = max(yj - RACE * (tau - race), y + r); // never past the first
			stretch = 0.35; // drawn out as it races
		} else if (tau > t0 + hold) {
			float u = (tau - t0 - hold) / slide;
			yb = mix(y0, yj, u * u);
		}

		if (tau > t0 && y0 > ya + 25.0) {
			float joined = tau >= caught ? 1.0 : 0.0;
			float xb = path(yb, x0, n.xy) + off * smoothstep(yj, yj + 20.0, yb);
			if (joined < 0.5) {
				vec3 m = drop(f, vec2(xb, yb), rj * smoothstep(t0, t0 + 0.6, tau), stretch);
				wet = m.z > wet.z ? m : wet;
			}
			// its own path, from where it gathered to where it joined
			float low = max(yb, y);
			if (f.y > low && f.y < y0) {
				float xp = path(f.y, x0, n.xy) + off * smoothstep(yj, yj + 20.0, f.y);
				cleared = max(cleared, smoothstep(rj * 0.85, rj * 0.2, abs(f.x - xp)) * exp(-(f.y - low) / 70.0));
			}
			r = mix(r, sqrt(r * r + rj * rj), joined);
		}
	}

	vec3 m = drop(f, vec2(path(y, x0, n.xy), y), r, 0.6);
	wet = m.z > wet.z ? m : wet;
	return vec4(wet.xy, wet.z, cleared) * shown;
}

// Beads resting on the glass, one or none to a cell, anywhere in it and of
// any size, each landing, swelling and slowly drying before another lands.
vec3 beading(vec2 p, float cell, float most, float seed, float t) {
	vec2 id = floor(p / cell);
	vec2 f = fract(p / cell) * cell;
	float phase = t * (0.015 + 0.03 * hash(id + seed + 0.7)) + hash(id + seed);
	float life = fract(phase);
	vec2 cid = id + floor(phase) * vec2(5.17, 9.31) + seed;
	if (hash(cid) > BEADS) return vec3(0.0);

	vec2 c = (vec2(hash(cid + 1.1), hash(cid + 2.2)) * 0.6 + 0.2) * cell;
	float size = hash(cid + 3.3);
	float r = mix(0.6, most, size * size) * smoothstep(0.0, 0.02, life) * (1.0 - smoothstep(0.5, 1.0, life));
	return drop(f, c, r, 1.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 p = fragCoord / iScale;
	float t = iTime;

	vec4 run = running(p, t);

	// Beads, large and small, wiped away where a drop has run.
	vec3 big = beading(p, 24.0, 3.2, 31.0, t);
	vec3 fine = beading(p + 5.0, 9.0, 1.3, 47.0, t);
	float wipe = 1.0 - run.w;
	vec2 slope = run.xy + (big.xy + fine.xy) * wipe;
	float wet = max(run.z, max(big.z, fine.z) * wipe);
	float clear = max(wet, run.w * 0.7);

	// The forest through the glass: misted, but clear through the drops and
	// the paths they leave, bent by each drop.
	vec3 seen = mix(misted(fragCoord, MIST * iScale),
	                behind(fragCoord - slope * BEND * iScale), clear) * NIGHT;
	vec3 panel = mix(PANEL, PANEL_ALT, iAlt);
	vec3 color = mix(panel, seen, mix(0.14, 0.3, clear));

	// Each drop caught by the lamplight above, dark at its rim, and shaded
	// below.
	vec2 n = dot(slope, slope) > 0.0 ? normalize(slope) : vec2(0.0);
	float lit = pow(max(dot(n, vec2(-0.45, 0.89)), 0.0), 4.0);
	color += mix(vec3(1.0), EMBER, 0.5) * lit * wet * 0.22;
	color *= 1.0 - 0.3 * wet * max(dot(n, vec2(0.45, -0.89)), 0.0);
	color *= 1.0 - 0.25 * wet * (1.0 - wet) * 4.0;

	// The fire, low in the room, breathing slowly on the glass.
	float flicker = 0.85 + 0.1 * sin(t * 1.3) + 0.05 * sin(t * 3.1 + 1.3);
	float glow = exp(-p.y / 70.0) * (0.8 + 0.2 * sin(p.x * 0.012 + t * 0.2));
	color += EMBER * glow * flicker * 0.07;

	fragColor = vec4(color, 1.0);
}
