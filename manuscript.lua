-- manuscript: a onon theme written in iron-gall ink on vellum.
--
-- Cream paper ruled in faint blue with a red margin, headings in rubric
-- red, and panels torn from the page. The selected row is underlined by
-- hand, and the loader is a pen writing a line. :colors alt turns the
-- pages to sepia for reading by lamplight.
--
-- Showcases: shape functions (the torn paper is computed in Lua), strokes,
-- and the font's style.
--
-- Pick it with :theme manuscript.

local serif = onon.platform.os == "linux" and "DejaVu Serif" or "Georgia"

-- A repeatable "random" number in [0, 1) for point i, so a torn edge keeps
-- its shape each time it is drawn at the same size.
local function noise(i, seed)
  local x = math.sin(i * 12.9898 + seed * 78.233) * 43758.5453
  return x - math.floor(x)
end

-- Panels: a sheet with a ragged top and a deeply torn bottom.
local function torn(path, w, h)
  local n = math.max(2, math.floor(w / 7))
  path:move_to(0, 0)
  for i = 1, n do
    path:line_to(i * w / n, noise(i, 1) * 2.5)
  end
  path:line_to(w, h - 4)
  for i = n - 1, 0, -1 do
    path:line_to(i * w / n, h - 1 - noise(i, 2) * 5)
  end
  return path:close()
end

-- Link hints: little labels pinned on slightly askew.
local askew = "M1,1 L100%,0 L100%-1,100% L0,100%-1 Z"

-- Panels: the sheet, ruled in blue with a double red margin.
local function ruled(canvas, box, state)
  canvas:default()
  for y = 30, box.h - 8, 22 do
    canvas:rect(2, y, box.w - 4, 1, "#4a73b5/16")
  end
  canvas:rect(9, 4, 1, box.h - 10, "accent/35")
  canvas:rect(12, 4, 1, box.h - 10, "accent/35")
end

-- A wavy line from x0 to x1 along y, as path data.
local function squiggle(x0, x1, y, amp, period, phase)
  local parts = { string.format("M%f,%f", x0, y) }
  local x, up = x0, phase or 1
  while x < x1 do
    local nx = math.min(x + period, x1)
    parts[#parts + 1] = string.format("Q%f,%f %f,%f", (x + nx) / 2, y - amp * up, nx, y)
    x, up = nx, -up
  end
  return table.concat(parts, " ")
end

-- The selected row: a faint wash, and the row underlined by hand.
local function underlined(canvas, box, state)
  canvas:default()
  canvas:stroke(squiggle(22, box.w - 16, box.h - 3, 1.4, 9), "accent", 1.3)
end

-- The loader: a pen writes a line across the page, then starts it again.
local function writing(canvas, box, state)
  local width, y = 150, box.h / 2
  local x0 = (box.w - width) / 2
  local t = (state.time % 2.2) / 1.8
  local x1 = x0 + width * math.min(t, 1)
  canvas:rect(x0 - 6, y + 12, width + 12, 1, "#4a73b5/30")
  if x1 > x0 + 2 then
    canvas:stroke(squiggle(x0, x1, y, 4, 7), "foreground", 1.6)
  end
  -- the nib, and a blot where it rests
  canvas:fill(string.format("M%f,%f L%f,%f L%f,%f Z", x1, y, x1 + 5, y - 15, x1 + 9, y - 13), "foreground")
  canvas:rect(x1 - 1.5, y - 1.5, 3, 3, "foreground", 1.5)
end

return {
  base = "birch",

  background = "#d9ccb2",
  page = "#fbf6ea",
  foreground = "#2b2620",
  muted = "#7d715f",
  accent = "#9b2d20", -- rubric red
  panel = "#fbf5e6",
  border = "#c9b994",
  status_bar = "#f3ead6",
  selection = "#f0d6a2",
  search = "#f6e08a",
  search_current = "#eda36a",
  hint_foreground = "#fbf5e6",
  presentation = "#1a1610",

  -- :colors alt: sepia pages on a dark desk.
  alt = {
    background = "#3a2c1e",
    page = "#efe2c4",
    foreground = "#3d2b1a",
    muted = "#806548",
    accent = "#8a2c18",
    panel = "#f1e4c8",
    border = "#c4ab7e",
    status_bar = "#e8d8b6",
    selection = "#e2c08a", -- the sepia pages are light, so highlights multiply
    search = "#edd27a",
    search_current = "#e3955c",
    hint_foreground = "#f6ebd2",
    presentation = "#1a1209",
  },

  font = { family = serif, style = "italic" },
  radius = 0,
  padding = 8,
  shadow = true,
  status_bar_style = "bar",

  motion = {
    panel = "220ms ease-out", -- the sheet settles onto the desk
    message = "260ms ease",
    selection = "140ms ease-in-out",
  },

  elements = {
    panel = {
      shape = torn,
      border = { width = 0 },
      shadow = "1 3 6 0 shadow/70, 0 0 1 0 shadow/50",
      padding = { 2, 0, 12, 0 },
      draw = ruled,
    },
    completion = { padding = { 6, 0, 10, 0 } },
    header = {
      radius = 0,
      border = { width = 0 },
      text = "accent",
      secondary = "muted",
      padding = { 8, 22, 6, 22 },
    },
    row = { padding = { 4, 22 } },
    row_selected = {
      fill = "accent/7",
      border = { width = 0 },
      padding = { 4, 22 },
      draw = underlined,
    },
    heading = { text = "accent", bold = true },
    button = { radius = 0, border = { width = 1, color = "accent/50" }, text = "accent" },
    scrollbar = { fill = "muted/45", width = 3, margin = { 0, 6, 0, 0 } },
    swatch = { shape = "pill", border = { width = 1, color = "foreground/40" } },

    status = { border = { width = 1, color = "border", sides = "top" } },
    status_left = { padding = { 4, 12 } },
    status_right = { text = "muted", padding = { 4, 12 } },
    prompt = { text = "accent" },
    cursor = { fill = "foreground", width = 1.5 },
    input_selection = { fill = "accent/20" },

    hint = {
      shape = askew,
      fill = "accent",
      text = "hint_foreground",
      secondary = "hint_foreground/55",
      shadow = "1 2 3 0 shadow/60",
      padding = { 2, 6 },
    },
    overview_selection = {
      radius = 0,
      border = { width = 2, color = "accent" },
      padding = 4,
    },
    link_preview = {
      radius = 0,
      border = { width = 1, color = "border" },
      shadow = "1 4 10 0 shadow/70",
    },
    page = { shadow = "0 1 2 0 shadow/60, 1 5 14 0 shadow/40" },
    loader = { fill = "foreground", draw = writing },
    autoscroll_marker = { fill = "#fbf5e6e0", border = { width = 1.2, color = "foreground" } },

    title_bar = { fill = "status_bar" },
    title_close = { fill = "accent", text = "#ffffff" },
  },
}
