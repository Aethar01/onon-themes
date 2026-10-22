-- vampire: a onon theme for reading after dark.
--
-- Blood on black, with a crypt-dark alternate mode (:colors alt) that turns
-- pages to parchment-pale ink on near-black. Showcases palettes, element
-- shapes (gothic panels, coffin status pills, fanged link hints), glowing
-- shadows, draw functions (a dripping selection ribbon, a bleeding loader)
-- and motion.
--
-- Pick it with :theme vampire.

-- Path data helpers -----------------------------------------------------------

local function fmt(...) return string.format(...) end

-- A drop of blood: a circle of radius r centred on (cx, cy) with a point
-- rising above it, as one path.
local function drop(path, cx, cy, r)
  local k = 0.5523 * r -- cubic handle for a quarter circle
  return path
    :move_to(cx, cy - 2.1 * r)
    :cubic_to(cx + 0.35 * r, cy - 1.3 * r, cx + r, cy - 0.75 * r, cx + r, cy)
    :cubic_to(cx + r, cy + k, cx + k, cy + r, cx, cy + r)
    :cubic_to(cx - k, cy + r, cx - r, cy + k, cx - r, cy)
    :cubic_to(cx - r, cy - 0.75 * r, cx - 0.35 * r, cy - 1.3 * r, cx, cy - 2.1 * r)
    :close()
end

local function ease_in(t) return t * t * t end

-- Draw functions --------------------------------------------------------------

-- The selected row: its wash of colour, then a ribbon down its left edge
-- that runs on past the bottom in a single drip.
local function bleeding_ribbon(canvas, box, state)
  canvas:default()
  canvas:fill("M0,0 H3 V100%-1 C3,100%+3 4.5,100%+4 1.5,100%+8 C-1.5,100%+4 0,100%+3 0,100%-1 Z", "accent")
end

-- A menu's title, underlined by a rule that thins out toward the right, with
-- a drop hanging from its middle.
local function dripping_rule(canvas, box, state)
  canvas:default()
  local y = box.h - 1
  canvas:fill(fmt("M14,%f H%f L%f,%f H14 Z", y - 1, box.w - 14, box.w - 40, y, y), "accent/70")
  canvas:fill(drop(canvas:path(), 22, y + 5, 2.2), "accent")
end

-- The loader, shown on a page still rendering: three drips swell at the top
-- of the page's middle, let go and fall, each in its turn.
local function bleeding_loader(canvas, box, state)
  local cx, top = box.w / 2, box.h / 2 - 34
  local period, fall = 1.6, 56
  for i = -1, 1 do
    local x = cx + i * 18
    local p = (state.time / period + (i + 1) / 3) % 1
    if p < 0.6 then
      -- the drip swells, hanging from its thread
      local t = ease_in(p / 0.6)
      local len, r = 4 + 14 * t, 1.5 + 2.5 * t
      canvas:rect(x - 1, top, 2, len, "accent/80", 1)
      canvas:fill(drop(canvas:path(), x, top + len + r, r), "accent")
    else
      -- it falls and fades; the thread draws back up
      local t = (p - 0.6) / 0.4
      local y = top + 18 + 4 + fall * t * t
      canvas:rect(x - 1, top, 2, 4 * (1 - t) + 1, "accent/80", 1)
      canvas:fill(drop(canvas:path(), x, y, 4), fmt("accent/%d", math.floor(100 * (1 - t))))
    end
  end
  canvas:rect(cx - 30, top - 2, 60, 2, "accent/60", 1)
end

-- Shapes ----------------------------------------------------------------------

-- Panels with their corners cut, like a gothic window's frame.
local gothic = "M9,0 H100%-9 L100%,9 V100%-9 L100%-9,100% H9 L0,100%-9 V9 Z"

-- The status pills are coffins, laid head to head.
local coffin_left = "M0,32% L12,0 H100%-7 L100%,22% V78% L100%-7,100% H12 L0,68% Z"
local coffin_right = "M0,22% L7,0 H100%-12 L100%,32% V68% L100%-12,100% H7 L0,78% Z"

-- Link hints bare a pair of fangs below them.
local fanged = "M2,0 H100%-2 Q100%,0 100%,2 V100% H86% L79%,100%+5 L72%,100% H28% L21%,100%+5 L14%,100% H0 V2 Q0,0 2,0 Z"

return {
  base = "moss",

  -- Night: the UI in black and crimson around the document as it is.
  background = "#0c0708",
  page = "#efe6da",
  foreground = "#eadbd5",
  muted = "#8f777a",
  accent = "#c0142f",
  panel = "#170c0f",
  border = "#3a1a21",
  status_bar = "#120a0c",
  selection = "#f0a7b2", -- multiplied over white pages, so pale
  search = "#f2cd8c",
  search_current = "#ea6f80",
  hint_foreground = "#fff1f1",
  presentation = "#050203",

  -- The crypt: :colors alt recolours the pages too, pale ink on near-black.
  alt = {
    background = "#060304",
    page = "#130a0c",
    foreground = "#e6d5cf",
    muted = "#8b7075",
    accent = "#e2324f",
    panel = "#1a0d10",
    border = "#3f1f27",
    status_bar = "#0f070a",
    selection = "#741629", -- added over dark pages, so deep
    search = "#6a4610",
    search_current = "#9c1d31",
    hint_foreground = "#12060a",
    presentation = "#000000",
  },

  radius = 2,
  padding = 8,
  shadow = true,
  status_bar_style = "pill",

  motion = {
    panel = "180ms ease-out", -- menus rise out of the dark
    message = "240ms ease-in-out",
    selection = "120ms cubic-bezier(0.2, 0.9, 0.25, 1)",
    prompt = "150ms ease-out",
    cursor = "60ms ease-out",
  },

  elements = {
    panel = {
      shape = gothic,
      border = { width = 1, color = "accent/45" },
      shadow = "0 0 22 0 #8a0a1f/45, 0 12 28 shadow",
      padding = { 2, 0, 10, 0 },
    },
    completion = { padding = { 6, 0 } },
    header = {
      border = { width = 0 },
      text = "foreground",
      secondary = "accent",
      padding = { 7, 16, 9, 16 },
      draw = dripping_rule,
    },
    row = { padding = { 4, 16 } },
    row_selected = {
      fill = "accent/18",
      border = { width = 0 },
      text = "#ffffff",
      secondary = "foreground",
      padding = { 4, 16 },
      draw = bleeding_ribbon,
    },
    heading = { text = "accent", bold = true },
    button = { radius = 0, shape = gothic, border = { width = 1, color = "accent/60" } },
    scrollbar = { fill = "accent/50", width = 3 },
    swatch = { shape = "pill", border = { width = 1, color = "foreground/30" } },

    status = { margin = { 0, 14, 12, 14 } },
    status_left = {
      shape = coffin_left,
      fill = "status_bar",
      border = { width = 1, color = "accent/50" },
      shadow = "0 0 14 0 #8a0a1f/40, 0 4 12 shadow",
      padding = { 5, 20 },
    },
    status_right = {
      shape = coffin_right,
      text = "muted",
      padding = { 5, 20 },
    },
    prompt = { text = "accent" },
    cursor = { fill = "accent", width = 2 },
    input_selection = { fill = "accent/35" },

    hint = {
      shape = fanged,
      fill = "accent",
      text = "hint_foreground",
      secondary = "hint_foreground/50",
      shadow = "0 0 8 0 accent/60",
      padding = { 2, 6 },
    },
    overview_selection = {
      radius = 2,
      border = { width = 2.5, color = "accent" },
      shadow = "0 0 16 3 accent/50",
      padding = 4,
    },
    link_preview = {
      radius = 2,
      border = { width = 1, color = "accent/55" },
      shadow = "0 0 20 0 #8a0a1f/45, 0 8 20 shadow",
    },
    page = { shadow = "0 0 0 1 #000000/50, 0 10 30 0 #4a000c/45" },
    loader = { fill = "accent", draw = bleeding_loader },
    autoscroll_marker = { fill = "#170c0fe0", border = { width = 1.5, color = "accent" } },

    title_bar = { fill = "status_bar" },
    title_close = { fill = "accent", text = "#ffffff" },
  },
}
