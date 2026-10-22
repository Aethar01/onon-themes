-- synthwave: a onon theme in neon, as a 1980s album cover imagined it.
--
-- Hot pink and cyan glowing on deep violet. Every panel has layered neon
-- shadows, menu titles are underlined with a pink-to-cyan gradient, the
-- selection springs past each row and settles, and pages still rendering
-- show a striped sun setting over a grid rolling toward you. :colors alt
-- swaps the accent to cyan and the pages to violet.
--
-- Showcases: layered shadows, colours computed in Lua, an overshooting
-- cubic-bezier easing, and an animated loader.
--
-- Pick it with :theme synthwave.

local pink, cyan, sun = "#ff2fb3", "#2ff3ff", "#ffd319"

local function rgb(hex)
  return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

-- The colour t of the way from a to b.
local function mix(a, b, t)
  local ar, ag, ab = rgb(a)
  local br, bg, bb = rgb(b)
  return string.format("#%02x%02x%02x",
    math.floor(ar + (br - ar) * t + 0.5),
    math.floor(ag + (bg - ag) * t + 0.5),
    math.floor(ab + (bb - ab) * t + 0.5))
end

-- A menu's title, over a neon rule fading from pink to cyan.
local function gradient_rule(canvas, box, state)
  canvas:default()
  local x0, x1, y = 12, box.w - 12, box.h - 2
  local n = 32
  local step = (x1 - x0) / n
  for i = 0, n - 1 do
    local c = mix(pink, cyan, i / (n - 1))
    canvas:rect(x0 + i * step, y - 3, step + 0.5, 5, c .. "/18") -- the glow
    canvas:rect(x0 + i * step, y - 1, step + 0.5, 1.5, c)
  end
end

-- The loader: a striped sun setting behind a grid that rolls toward you.
local function sunset(canvas, box, state)
  local w, h = 200, 132
  local x0, y0 = (box.w - w) / 2, (box.h - h) / 2
  local cx, horizon = x0 + w / 2, y0 + h * 0.58
  canvas:rect(x0, y0, w, h, "#12062b", 10)

  -- the sun: slices shading from yellow to pink, with gaps that widen
  -- toward the horizon
  local r = 40
  for dy = r, 1, -2 do
    local d = dy / r
    local gap = math.max(0, (0.6 - d) * 9)
    if (dy % 7) >= gap then
      local half = math.sqrt(r * r - dy * dy)
      canvas:rect(cx - half, horizon - dy, half * 2, 2, mix(pink, sun, d))
    end
  end

  -- the grid: lines running to the vanishing point, and crossbars coming
  -- toward you, further apart the nearer they are
  local bottom = y0 + h - 6
  canvas:rect(x0 + 4, horizon, w - 8, 1.5, cyan)
  for k = -6, 6 do
    canvas:stroke(string.format("M%f,%f L%f,%f", cx + k * 7, horizon, cx + k * 34, bottom), pink .. "/70", 1)
  end
  local t = (state.time * 0.6) % 1
  for i = 0, 5 do
    local z = ((i + t) / 6)
    local y = horizon + (bottom - horizon) * z * z
    canvas:rect(x0 + 4, y, w - 8, 1, pink .. "/" .. math.floor(30 + 60 * z))
  end
end

return {
  base = "moss",

  background = "#12062b",
  page = "#f4eefc",
  foreground = "#f8e9ff",
  muted = "#9a7cc4",
  accent = pink,
  panel = "#1d0b3d",
  border = "#4a2a86",
  status_bar = "#170833",
  selection = "#ffb3e6", -- multiplied over white pages
  search = "#9ef6ff",
  search_current = "#ff9de2",
  hint_foreground = "#1a0636",
  presentation = "#0b0320",

  -- :colors alt: cyan leads, and the pages turn violet.
  alt = {
    background = "#0b0320",
    page = "#150a30",
    foreground = "#e6dcff",
    muted = "#8a77b8",
    accent = cyan,
    panel = "#1a0b38",
    border = "#3d2470",
    status_bar = "#12062b",
    selection = "#5a1a6e", -- added over dark pages
    search = "#135a6a",
    search_current = "#7a1a5a",
    hint_foreground = "#0b0320",
    presentation = "#05010f",
  },

  radius = 6,
  padding = 8,
  shadow = true,
  status_bar_style = "pill",

  motion = {
    panel = "160ms ease-out",
    message = "200ms ease",
    -- y above 1 overshoots: the highlight springs past the row and back
    selection = "260ms cubic-bezier(0.3, 1.5, 0.5, 1)",
    prompt = "200ms cubic-bezier(0.3, 1.3, 0.5, 1)",
    cursor = "70ms ease-out",
  },

  elements = {
    panel = {
      radius = 8,
      border = { width = 1, color = "accent/80" },
      shadow = "0 0 0 1 accent/25, 0 0 18 2 accent/45, 0 0 46 8 " .. cyan .. "/16",
      padding = { 0, 6, 8, 6 },
    },
    header = {
      radius = 0,
      border = { width = 0 },
      text = "foreground",
      secondary = cyan,
      padding = { 8, 10, 10, 10 },
      draw = gradient_rule,
    },
    row = { radius = 5, padding = { 4, 10 } },
    row_selected = {
      fill = "accent/22",
      border = { width = 1, color = "accent/70" },
      shadow = "0 0 12 0 accent/55",
      text = "#ffffff",
      padding = { 4, 10 },
    },
    heading = { text = cyan, bold = true },
    button = { radius = 5, border = { width = 1, color = cyan }, text = cyan, shadow = "0 0 10 0 " .. cyan .. "/40" },
    scrollbar = { fill = "accent/75", shadow = "0 0 6 0 accent/60" },
    swatch = { shape = "pill", border = { width = 1, color = "foreground/40" } },

    status = { margin = { 0, 16, 14, 16 } },
    status_left = {
      shape = "pill",
      fill = "status_bar",
      border = { width = 1, color = "accent" },
      shadow = "0 0 14 1 accent/55",
      padding = { 5, 16 },
    },
    status_right = {
      border = { width = 1, color = cyan },
      shadow = "0 0 14 1 " .. cyan .. "/45",
      text = cyan,
    },
    prompt = { text = "accent" },
    cursor = { fill = "accent", width = 2, shadow = "0 0 6 0 accent" },
    input_selection = { fill = "accent/35" },

    hint = {
      radius = 3,
      fill = "accent",
      text = "hint_foreground",
      secondary = "hint_foreground/55",
      shadow = "0 0 10 1 accent/70",
      padding = { 2, 6 },
    },
    overview_selection = {
      radius = 6,
      border = { width = 2, color = "accent" },
      shadow = "0 0 18 4 accent/60, 0 0 40 8 " .. cyan .. "/25",
      padding = 4,
    },
    link_preview = {
      radius = 8,
      border = { width = 1, color = "accent/80" },
      shadow = "0 0 20 2 accent/45, 0 0 46 8 " .. cyan .. "/16",
    },
    page = { shadow = "0 0 24 2 accent/25, 0 0 60 10 " .. cyan .. "/10" },
    loader = { fill = "accent", draw = sunset },
    autoscroll_marker = { fill = "#1d0b3de0", border = { width = 1.5, color = "accent" } },

    title_bar = { fill = "status_bar" },
    title_close = { fill = "accent", text = "#ffffff" },
  },
}
