-- forest-rain: a onon theme for reading in a warm cabin while it rains.
--
-- Deep pine and wet moss around warm, lamplit pages, with ember amber for
-- the fire in the grate. Menus drift down and settle as rain does, their
-- rows falling into place one by one, rain gathers in drops along the sill
-- under each title, and the loader is rain falling into a puddle. :colors
-- alt turns the lamp down: dark pages, read by the fire.
--
-- With onon.options.shaders = true, the menus, status pill, tabs and link
-- preview draw forest-rain.glsl, beside this file: the cabin's window, the
-- page behind it misted by the warmth inside, with a few beads of rain on
-- the glass and drops running slowly down, clearing a path as they go,
-- catching the lamplight, and the fire glowing low on the glass.
--
-- Showcases: an animated shader, path shapes (leaf-cut link hints), draw
-- functions with paths built from canvas:path(), and motion that falls
-- rather than rises.
--
-- Pick it with :theme forest-rain.

local function fmt(...) return string.format(...) end

-- A drop of rain hanging from (cx, top), its round foot r across.
local function hanging(canvas, cx, top, r)
  local k = 0.5523 * r
  local cy = top + 1.6 * r
  return canvas:path()
    :move_to(cx, top)
    :cubic_to(cx + 0.3 * r, top + 0.6 * r, cx + r, cy - 0.7 * r, cx + r, cy)
    :cubic_to(cx + r, cy + k, cx + k, cy + r, cx, cy + r)
    :cubic_to(cx - k, cy + r, cx - r, cy + k, cx - r, cy)
    :cubic_to(cx - r, cy - 0.7 * r, cx - 0.3 * r, top + 0.6 * r, cx, top)
    :close()
end

-- Panels: the pane, lit warm along its top by the lamp above. The canvas
-- has no gradients, so the light is layers of faint amber, each a little
-- taller, brightest where they all overlap.
local function lamplit(canvas, box, state)
  canvas:default()
  local h, layers = math.min(36, box.h / 3), 6
  for i = 1, layers do
    canvas:rect(1, 1, box.w - 2, h * i / layers, "accent/1", 6)
  end
  canvas:rect(12, 1, box.w - 24, 1, "accent/22")
end

-- A menu's title, over a sill where the rain has gathered, two drops
-- hanging from it.
local function sill(canvas, box, state)
  canvas:default()
  local y = box.h - 1
  canvas:rect(14, y, box.w - 28, 1, "border")
  canvas:fill(hanging(canvas, box.w - 34, y + 1, 1.8), "muted/70")
  canvas:fill(hanging(canvas, box.w - 52, y + 1, 1.3), "muted/50")
end

-- The selected row: a warm wash, and an ember glowing at its left.
local function ember(canvas, box, state)
  canvas:default()
  canvas:rect(5, 5, 3, box.h - 10, "accent", 1.5)
  canvas:rect(3, 3, 7, box.h - 6, "accent/18", 3.5)
end

-- The tab shown: lit by the ember beneath it.
local function ember_tab(canvas, box, state)
  canvas:default()
  canvas:rect(12, box.h - 3, box.w - 24, 2, "accent", 1)
end

-- The loader: rain falling into a puddle, each drop sending out a ripple
-- as it lands.
local function puddle(canvas, box, state)
  local cx, y = box.w / 2, box.h / 2 + 22
  local period, fall = 1.8, 0.45
  canvas:rect(cx - 70, y + 1, 140, 1, "muted/25", 0.5)
  for i = 0, 4 do
    local x = cx + (i - 2) * 26 + (i % 2) * 6
    local p = (state.time / period + i * 0.37) % 1
    if p < fall then
      -- falling: a streak that quickens as it comes down
      local t = p / fall
      local dy = 70 * t * t
      canvas:rect(x - 0.75, y - 70 + dy, 1.5, 6 + 6 * t, fmt("accent/%d", math.floor(40 + 50 * t)), 0.75)
    else
      -- landed: a ripple widening and fading
      local t = (p - fall) / (1 - fall)
      local rx = 3 + 18 * t
      local alpha = math.floor(80 * (1 - t))
      canvas:stroke(canvas:path():ellipse(x, y, rx, rx * 0.3), fmt("accent/%d", alpha), 1.2)
      if t > 0.25 then
        local u = (t - 0.25) / 0.75
        canvas:stroke(canvas:path():ellipse(x, y, rx * 0.55, rx * 0.17), fmt("accent/%d", math.floor(60 * (1 - u))), 1)
      end
    end
  end
end

-- Link hints are cut as leaves, round at two corners and pointed at two.
local leaf = "M8,0 H100% V100%-8 Q100%,100% 100%-8,100% H0 V8 Q0,0 8,0 Z"

local theme = {
  base = "moss",

  -- Lamplight: warm cream pages in a cabin of pine and moss.
  background = "#121812",
  page = "#f4ecdc",
  foreground = "#e8dcc4",
  muted = "#8a9384",
  accent = "#e39a4c", -- ember
  panel = "#1a221b",
  border = "#2f3a2f",
  status_bar = "#161d17",
  selection = "#f2c98f", -- multiplied over the cream pages, so pale
  search = "#e8d48a",
  search_current = "#e8a060",
  hint_foreground = "#1a1408",
  presentation = "#070a07",

  -- :colors alt: the lamp turned down, dark pages read by the fire.
  alt = {
    background = "#0c0f0c",
    page = "#1b1a16",
    foreground = "#e6d8bd",
    muted = "#858a7c",
    accent = "#eaa25a",
    panel = "#171915",
    border = "#2c3029",
    status_bar = "#131511",
    selection = "#5a3e1c", -- added over dark pages, so deep
    search = "#5a4c18",
    search_current = "#7a4418",
    hint_foreground = "#14100a",
    presentation = "#040504",
  },

  radius = 6,
  padding = 9,
  shadow = true,
  status_bar_style = "pill",
  tab_bar_style = "pill",

  motion = {
    -- Panes drift down and settle, as rain does, and lift away as they go;
    -- their rows fall into place one by one. The selection keeps up with
    -- the keyboard, so it is quick.
    panel = {
      enter = "fade y:-8px 320ms cubic-bezier(0.22, 1, 0.36, 1)",
      exit = "fade 200ms ease-in",
    },
    rows = { enter = "fade y:-4px 260ms ease-out stagger:14ms" },
    message = "fade drop 320ms ease-out",
    selection = "glide 90ms ease-out",
    overview_selection = "glide 110ms ease-out",
    prompt = "glide 200ms ease-out",
    cursor = "glide 80ms ease-out",
    edges = "fade slide 260ms ease-out",
    -- The ember drips to the next tab, a long tail running after it.
    tab_selection = "glide 300ms ease-out stretch:70ms",
    hover = "fade 160ms ease-out",
    -- A document runs down the pane and away as the next falls into place.
    document = "fade y:14px 340ms ease-out",
    -- With less motion the rain stops: things only fade in and out.
    reduced = {
      panel = { enter = "fade 240ms ease-out", exit = "fade 180ms ease-in" },
      selection = "crossfade 90ms ease-out",
      overview_selection = "crossfade 110ms ease-out",
      tab_selection = "crossfade 120ms ease-out",
      document = "fade 200ms ease-out",
    },
  },

  elements = {
    panel = {
      radius = 8,
      border = { width = 1, color = "border" },
      shadow = "0 0 26 0 #e39a4c/10, 0 14 32 0 shadow/70",
      padding = { 2, 0, 10, 0 },
      draw = lamplit,
    },
    completion = { radius = 8, padding = { 6, 0 } },
    header = {
      radius = 0,
      border = { width = 0 },
      text = "foreground",
      secondary = "accent",
      padding = { 9, 18, 9, 18 },
      draw = sill,
    },
    row = { padding = { 4, 18 } },
    row_selected = {
      fill = "accent/12",
      border = { width = 0 },
      text = "#fff4e2",
      padding = { 4, 18 },
      draw = ember,
    },
    heading = { text = "accent" },
    button = { radius = 6, fill = "accent/10", border = { width = 1, color = "accent/40" }, text = "accent" },
    scrollbar = { fill = "muted/40", width = 3, margin = { 0, 5, 0, 0 } },
    swatch = { shape = "pill", border = { width = 1, color = "foreground/25" } },

    status = { margin = { 0, 14, 14, 14 }, gap = 10 },
    status_left = {
      shape = "pill",
      fill = "status_bar",
      border = { width = 1, color = "border" },
      shadow = "0 0 18 0 #e39a4c/8, 0 8 20 0 shadow/60",
      padding = { 5, 16 },
    },
    status_right = { text = "muted" },
    prompt = { text = "accent" },
    cursor = { fill = "accent", width = 2, radius = 1 },
    input_selection = { fill = "accent/28", radius = 2 },
    -- Text fields, buttons and check boxes in plugins' views; a check is
    -- an ember.
    input = { radius = 6, fill = "background/60", border = { width = 1, color = "border" } },
    input_focused = { border = { width = 1, color = "accent/70" }, shadow = "0 0 10 0 #e39a4c/25" },
    button_focused = { fill = "accent/24", text = "#fff4e2" },
    check = { shape = "pill", fill = "accent" },

    hint = {
      shape = leaf,
      fill = "accent",
      text = "hint_foreground",
      secondary = "hint_foreground/55",
      shadow = "0 2 6 0 shadow/60",
      padding = { 2, 7 },
    },
    overview_selection = {
      radius = 6,
      border = { width = 2, color = "accent/85" },
      shadow = "0 0 18 0 #e39a4c/35",
      padding = 5,
    },
    link_preview = {
      radius = 8,
      border = { width = 1, color = "border" },
      shadow = "0 0 26 0 #e39a4c/10, 0 14 32 0 shadow/70",
    },
    page = { shadow = "0 0 40 0 #e39a4c/8, 0 10 28 0 shadow/60" },
    loader = { fill = "accent", draw = puddle },
    autoscroll_marker = { fill = "#1a221be0", border = { width = 1.2, color = "accent" } },

    -- Tabs: pills floating over the page, as the status bar's is, the tab
    -- shown lit by an ember beneath it.
    tab_bar = { margin = { 12, 14, 0, 14 }, gap = 8 },
    tab = {
      shape = "pill",
      fill = "status_bar",
      border = { width = 1, color = "border", sides = "all" },
      text = "muted",
      padding = { 4, 16 },
    },
    tab_selected = {
      border = { width = 1, color = "accent/45", sides = "all" },
      text = "foreground",
      draw = ember_tab,
    },

    title_bar = { fill = "status_bar" },
    title_close = { fill = "accent", text = "hint_foreground" },
  },
}

-- With shaders on, the panes are the cabin's window, forest-rain.glsl,
-- under fills thin enough to show the rain on it.
if onon.options.shaders then
  local e = theme.elements

  for _, name in ipairs({ "panel", "status_left", "tab", "link_preview" }) do
    e[name].shader = "forest-rain.glsl"
  end
  e.panel.fill = "panel/35"
  e.status_left.fill = "status_bar/35"
  e.tab.fill = "status_bar/35"
  e.link_preview.fill = "panel/35"
end

return theme
