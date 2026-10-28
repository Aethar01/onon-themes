-- phosphor: a onon theme after the green-screen terminals of the 1980s.
--
-- Green on black, square and still: no rounded corners, no animation, a
-- monospace font and a block cursor. Panels are drawn with scanlines, and
-- the selected row is shown in inverse video. :colors alt burns the pages
-- themselves into phosphor green.
--
-- Showcases: fonts, the cursor element, draw functions writing text with
-- canvas:text, and a theme that turns motion off altogether.
--
-- Pick it with :theme phosphor.

local mono = ({ macos = "Menlo", windows = "Consolas" })[onon.platform.os] or "DejaVu Sans Mono"

-- Panels: the default box, then a dark line across every third pixel row.
local function scanlines(canvas, box, state)
  canvas:default()
  for y = 1, box.h - 2, 3 do
    canvas:rect(1, y, box.w - 2, 1, "#000000/28")
  end
end

-- The loader: RENDERING and a blinking block cursor, then a bar of blocks
-- filling one at a time, as a terminal would draw progress.
local function terminal_loader(canvas, box, state)
  local label = "RENDERING"
  local w, lh = canvas:measure(label, true)
  local x, y = (box.w - w) / 2 - 6, box.h / 2 - lh
  canvas:rect(x - 14, y - 12, w + 40, lh * 2 + 30, "#020603")
  canvas:text(x, y, label, "accent", true)
  if math.floor(state.time * 2) % 2 == 0 then
    canvas:rect(x + w + 3, y + 2, lh * 0.55, lh - 4, "accent")
  end
  local cells, filled = 10, math.floor(state.time * 8) % 11
  local cw = (w + 12) / cells
  for i = 0, cells - 1 do
    canvas:rect(x + i * cw, y + lh + 6, cw - 2, 6, i < filled and "accent" or "accent/18")
  end
end

return {
  base = "classic",

  background = "#020603",
  page = "#d8e8d8",
  foreground = "#7dff9a",
  muted = "#3f9455",
  accent = "#39ff6a",
  panel = "#031008",
  border = "#12401f",
  status_bar = "#030c05",
  selection = "#a8f0b8", -- multiplied over white pages
  search = "#e6f59a",
  search_current = "#7fe08f",
  hint_foreground = "#021004",
  presentation = "#000000",

  -- :colors alt: the pages glow green on black too.
  alt = {
    background = "#010402",
    page = "#020803",
    foreground = "#74f590",
    muted = "#3a8a4e",
    accent = "#39ff6a",
    panel = "#031008",
    border = "#12401f",
    status_bar = "#020a04",
    selection = "#0f5a24", -- added over dark pages
    search = "#4a5a10",
    search_current = "#1a7a35",
    hint_foreground = "#021004",
    presentation = "#000000",
  },

  font = { family = mono, weight = "medium" },
  radius = 0,
  padding = 6,
  shadow = false,
  status_bar_style = "bar",
  status_bar_padding = 8,

  motion = { scale = 0 }, -- a terminal redraws; it does not glide

  elements = {
    panel = {
      border = { width = 1, color = "accent/70" },
      shadow = "0 0 14 0 accent/22", -- the bloom of a phosphor screen
      padding = { 0, 0, 6, 0 },
      draw = scanlines,
    },
    completion = { padding = { 3, 0 } },
    header = {
      radius = 0,
      border = { width = 1, color = "accent/40", sides = "bottom" },
      text = "accent",
      secondary = "muted",
      padding = { 4, 10 },
    },
    row = { padding = { 3, 10 } },
    row_selected = {
      fill = "accent", -- inverse video
      border = { width = 0 },
      text = "panel",
      secondary = "panel/70",
      padding = { 3, 10 },
    },
    heading = { text = "accent", bold = true },
    button = { radius = 0, border = { width = 1, color = "accent/70" }, text = "accent" },
    scrollbar = { shape = "rect", fill = "accent/60", width = 5, margin = { 0, 3, 0, 0 } },
    swatch = { radius = 0, border = { width = 1, color = "accent/50" } },

    status = { border = { width = 1, color = "accent/40", sides = "top" } },
    status_left = { text = "foreground", padding = { 3, 8 } },
    status_right = { text = "muted", padding = { 3, 8 } },
    prompt = { text = "accent" },
    cursor = { fill = "accent/75", width = 8 }, -- a block, as terminals have
    input_selection = { fill = "accent/35" },
    -- Text fields, buttons and check boxes in plugins' views; a button with
    -- the keys is inverse video, as the selected row is.
    input = { radius = 0, fill = "none", border = { width = 1, color = "accent/45" }, text = "accent", secondary = "accent/50" },
    input_focused = { border = { width = 1, color = "accent" } },
    button_focused = { fill = "accent", text = "panel" },
    check = { radius = 0, fill = "accent" },

    hint = {
      radius = 0,
      fill = "accent",
      text = "hint_foreground",
      secondary = "hint_foreground/50",
      shadow = "0 0 8 0 accent/45",
      padding = { 1, 4 },
    },
    overview_selection = {
      radius = 0,
      border = { width = 2, color = "accent" },
      shadow = "0 0 12 2 accent/35",
      padding = 3,
    },
    link_preview = {
      radius = 0,
      border = { width = 1, color = "accent/70" },
      shadow = "0 0 16 0 accent/22",
    },
    page = { shadow = "0 0 0 1 accent/30, 0 0 26 0 accent/12" },
    loader = { fill = "accent", draw = terminal_loader },
    autoscroll_marker = { fill = "#020603e0", border = { width = 1.5, color = "accent" } },

    title_bar = { fill = "status_bar" },
    title_button = { fill = "accent/20" },
    title_close = { fill = "accent", text = "panel" },
  },
}
