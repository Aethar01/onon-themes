-- gameboy: a onon theme in the four greens of a 1989 handheld.
--
-- Every colour is one of four greens. Panels have stair-stepped pixel
-- corners and hard pixel shadows, the selected row gets the triangle
-- cursor of an RPG menu, and pages still rendering show a pixel
-- heart beating over a loading bar. :colors alt prints the pages
-- themselves on the green screen.
--
-- Showcases: a small fixed palette, shape functions generating pixel
-- stairs at any size, and pixel art drawn from a bitmap in Lua.
--
-- Pick it with :theme gameboy.

local darkest, dark, light, lightest = "#0f380f", "#306230", "#8bac0f", "#9bbc0f"

local mono = ({ macos = "Menlo", windows = "Consolas" })[onon.platform.os] or "DejaVu Sans Mono"

-- Stairs adds to path a w by h box at (x, y) whose corners step in by two
-- pixels of size s, as pixel art rounds them.
local function stairs(path, x, y, w, h, s)
  local r, b = x + w, y + h
  return path
    :move_to(x + 2 * s, y):line_to(r - 2 * s, y)
    :line_to(r - 2 * s, y + s):line_to(r - s, y + s):line_to(r - s, y + 2 * s):line_to(r, y + 2 * s)
    :line_to(r, b - 2 * s)
    :line_to(r - s, b - 2 * s):line_to(r - s, b - s):line_to(r - 2 * s, b - s):line_to(r - 2 * s, b)
    :line_to(x + 2 * s, b)
    :line_to(x + 2 * s, b - s):line_to(x + s, b - s):line_to(x + s, b - 2 * s):line_to(x, b - 2 * s)
    :line_to(x, y + 2 * s)
    :line_to(x + s, y + 2 * s):line_to(x + s, y + s):line_to(x + 2 * s, y + s)
    :close()
end

-- A shape with pixel corners of size s, for any size of box.
local function pixel(s)
  return function(path, w, h) return stairs(path, 0, 0, w, h, s) end
end

-- Draws a bitmap, rows of 0 and 1, with its top left at (x, y) in pixels
-- of size p.
local function sprite(canvas, rows, x, y, p, color)
  for r, row in ipairs(rows) do
    for c = 1, #row do
      if row:sub(c, c) == "1" then
        canvas:rect(x + (c - 1) * p, y + (r - 1) * p, p, p, color)
      end
    end
  end
end

local arrow = { "1000", "1100", "1110", "1111", "1110", "1100", "1000" }

-- The selected row: the triangle cursor of an RPG menu at its left.
local function menu_cursor(canvas, box, state)
  canvas:default()
  sprite(canvas, arrow, 6, box.h / 2 - 7, 2, darkest)
end

local heart = {
  "01100110",
  "11111111",
  "11111111",
  "11111111",
  "01111110",
  "00111100",
  "00011000",
}

-- The loader: a heart beating twice a second over a loading bar filling a
-- block at a time.
local function beating_heart(canvas, box, state)
  local beat = state.time % 1
  local p = (beat < 0.12 or (beat > 0.24 and beat < 0.36)) and 6 or 5
  local cx, cy = box.w / 2, box.h / 2 - 16
  sprite(canvas, heart, cx - 4 * p, cy - 3.5 * p, p, darkest)
  local cells, filled = 8, math.floor(state.time * 4) % 9
  local x0, y = cx - cells * 6, cy + 32
  canvas:fill(stairs(canvas:path(), x0 - 3, y, cells * 12 + 6, 18, 2), dark)
  for i = 0, cells - 1 do
    canvas:rect(x0 + 3 + i * 12, y + 4, 9, 10, i < filled and darkest or light)
  end
end

return {
  base = "classic",

  background = light,
  page = lightest,
  foreground = darkest,
  muted = dark,
  accent = darkest,
  panel = lightest,
  border = darkest,
  status_bar = light,
  selection = "#a8c64a", -- multiplied over white pages
  search = "#c4dc6a",
  search_current = light,
  hint_foreground = lightest,
  presentation = darkest,

  -- :colors alt: the pages print on the green screen.
  alt = {
    background = darkest,
    page = lightest,
    foreground = darkest,
    muted = dark,
    accent = darkest,
    panel = lightest,
    border = darkest,
    status_bar = light,
    selection = light, -- the green pages are light, so highlights multiply
    search = "#b0c840",
    search_current = "#6a8c2a",
    hint_foreground = lightest,
    presentation = darkest,
  },

  font = { family = mono, weight = "bold" },
  radius = 0,
  padding = 6,
  shadow = false,
  status_bar_style = "bar",

  motion = { panel = "none", message = "none", selection = "none", prompt = "none", cursor = "none" },

  elements = {
    panel = {
      shape = pixel(4),
      border = { width = 3, color = darkest },
      shadow = "4 4 0 0 " .. dark, -- shadows follow the shape, stairs and all
      padding = { 3, 0, 8, 0 },
    },
    completion = { shape = pixel(3), padding = { 6, 0 } },
    header = {
      radius = 0,
      border = { width = 3, color = darkest, sides = "bottom" },
      text = darkest,
      secondary = dark,
      padding = { 5, 14 },
    },
    row = { padding = { 4, 22 } },
    row_selected = {
      fill = "none",
      border = { width = 0 },
      text = darkest,
      padding = { 4, 22 },
      draw = menu_cursor,
    },
    row_disabled = { text = light },
    heading = { text = dark, bold = true },
    button = { shape = pixel(2), fill = light, border = { width = 2, color = darkest }, text = darkest },
    scrollbar = { shape = "rect", fill = darkest, width = 4, margin = { 0, 6, 0, 0 } },
    swatch = { radius = 0, border = { width = 2, color = darkest } },

    status = { border = { width = 3, color = darkest, sides = "top" } },
    status_left = { text = darkest, padding = { 4, 10 } },
    status_right = { text = dark, padding = { 4, 10 } },
    prompt = { text = darkest },
    cursor = { fill = darkest .. "/70", width = 7 },
    input_selection = { fill = dark .. "/40" },
    -- Text fields, buttons and check boxes in plugins' views.
    input = { shape = pixel(2), fill = lightest, border = { width = 2, color = darkest }, text = darkest, secondary = dark },
    input_focused = { fill = light, border = { width = 2, color = darkest } },
    button_focused = { fill = darkest, border = { width = 2, color = darkest }, text = lightest },
    check = { shape = pixel(1), fill = darkest },

    hint = {
      shape = pixel(1.5),
      fill = darkest,
      text = lightest,
      secondary = lightest .. "/50",
      padding = { 2, 5 },
    },
    overview_selection = {
      shape = pixel(3),
      border = { width = 3, color = darkest },
      padding = 4,
    },
    link_preview = {
      radius = 0,
      border = { width = 3, color = darkest },
      shadow = "4 4 0 0 " .. dark,
    },
    page = { shadow = "4 4 0 0 " .. dark },
    loader = { fill = darkest, draw = beating_heart },
    autoscroll_marker = { fill = lightest, border = { width = 3, color = darkest } },

    title_bar = { fill = light },
    title_button = { fill = dark, text = lightest },
    title_close = { fill = darkest, text = lightest },
  },
}
