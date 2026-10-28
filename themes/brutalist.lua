-- brutalist: a onon theme of black lines, hard shadows and safety yellow.
--
-- No rounded corners, no soft shadows, no animation. Every box has a thick
-- black frame and casts a hard shadow, the status bar is two blocks, and
-- the selected row is inverted with an arrow cut into it. :colors alt
-- inverts everything, the pages included.
--
-- Showcases: shadows as graphics (offset, unblurred), borders on chosen
-- sides, colours fixed regardless of colour mode beside palette colours
-- that follow it, and drawing that steps rather than glides.
--
-- Pick it with :theme brutalist.

local yellow, black = "#ffe500", "#000000"

-- The selected row: inverted, with an arrow at its right end.
local function pointed(canvas, box, state)
  canvas:default()
  canvas:fill("M100%-24,50%-6 L100%-12,50% L100%-24,50%+6 Z", "panel")
end

-- The loader: four blocks stamped down one at a time.
local function stamping(canvas, box, state)
  local size, gap = 18, 8
  local x0 = (box.w - (4 * size + 3 * gap)) / 2
  local y = box.h / 2 - size / 2
  local n = math.floor(state.time * 5) % 5
  for i = 0, 3 do
    local x = x0 + i * (size + gap)
    if i < n then
      canvas:rect(x + 4, y + 4, size, size, "border")
      canvas:rect(x, y, size, size, yellow)
      canvas:fill(string.format("M%f,%f H%f V%f H%f Z M%f,%f V%f H%f V%f Z",
        x, y, x + size, y + size, x, x + 2, y + 2, y + size - 2, x + size - 2, y + 2), black)
    else
      canvas:rect(x, y, size, size, "border/15")
    end
  end
end

return {
  base = "classic",

  background = "#e9e6dc",
  page = "#ffffff",
  foreground = "#000000",
  muted = "#3d3d3d",
  accent = "#ff3b00", -- safety orange
  panel = "#ffffff",
  border = "#000000",
  status_bar = "#ffffff",
  selection = yellow,
  search = "#9be7ff",
  search_current = "#ff8ad8",
  hint_foreground = black,
  presentation = "#000000",

  -- :colors alt: everything inverted, white lines and white shadows on
  -- black, and black pages with white ink.
  alt = {
    background = "#111111",
    page = "#0a0a0a",
    foreground = "#ffffff",
    muted = "#bdbdbd",
    accent = "#ff5a1f",
    panel = "#000000",
    border = "#ffffff",
    status_bar = "#000000",
    selection = "#5c5200", -- added over dark pages
    search = "#004a66",
    search_current = "#7a1a5e",
    hint_foreground = black,
    presentation = "#000000",
  },

  font = { weight = "bold" },
  radius = 0,
  padding = 10,
  shadow = true,
  status_bar_style = "pill",

  motion = { scale = 0 },

  elements = {
    panel = {
      radius = 0,
      border = { width = 3, color = "border" },
      shadow = "8 8 0 0 border",
      padding = { 0, 0, 10, 0 },
    },
    completion = { shadow = "6 6 0 0 border", padding = { 0, 0, 4, 0 } },
    header = {
      radius = 0,
      fill = yellow,
      border = { width = 3, color = "border", sides = "bottom" },
      text = black,
      secondary = "#000000/60",
      padding = { 8, 14 },
      gap = 12,
    },
    row = { padding = { 5, 14 } },
    row_selected = {
      fill = "foreground",
      border = { width = 0 },
      text = "panel",
      secondary = "panel/70",
      padding = { 5, 40, 5, 14 },
      draw = pointed,
    },
    heading = {
      text = "accent",
      border = { width = 2, color = "border", sides = "top" },
    },
    button = {
      radius = 0,
      fill = yellow,
      border = { width = 3, color = black },
      shadow = "4 4 0 0 border",
      text = black,
    },
    scrollbar = { shape = "rect", fill = "foreground", width = 6, margin = { 0, 6, 0, 0 } },
    swatch = { radius = 0, border = { width = 2, color = "border" } },

    status = { margin = { 0, 16, 16, 16 }, gap = 14 },
    status_left = {
      shape = "rect",
      radius = 0,
      fill = yellow,
      border = { width = 3, color = black },
      shadow = "5 5 0 0 border",
      text = black,
      padding = { 6, 14 },
    },
    status_right = {
      fill = "panel",
      border = { width = 3, color = "border" },
      text = "foreground",
    },
    prompt = { text = black },
    cursor = { fill = black, width = 3 },
    input_selection = { fill = "#000000/25" },
    -- Text fields, buttons and check boxes in plugins' views.
    input = { radius = 0, fill = "#ffffff", border = { width = 3, color = black }, text = black, secondary = "#000000/45" },
    input_focused = { fill = yellow, border = { width = 3, color = black }, shadow = "4 4 0 0 border" },
    button_focused = { fill = black, border = { width = 3, color = black }, text = yellow },
    check = { radius = 0, fill = black },

    hint = {
      radius = 0,
      fill = yellow,
      border = { width = 2, color = black },
      shadow = "3 3 0 0 #000000",
      text = black,
      secondary = "#000000/45",
      padding = { 2, 6 },
    },
    overview_selection = {
      radius = 0,
      border = { width = 5, color = "accent" },
      padding = 6,
    },
    link_preview = {
      radius = 0,
      border = { width = 3, color = "border" },
      shadow = "8 8 0 0 border",
    },
    page = { border = { width = 2, color = "border" }, shadow = "7 7 0 0 border" },
    loader = { fill = "border", draw = stamping },
    autoscroll_marker = { fill = yellow, border = { width = 3, color = black } },

    title_bar = { fill = "panel", border = { width = 3, color = "border", sides = "bottom" } },
    title_button = { fill = yellow, text = black },
    title_close = { fill = "accent", text = "#ffffff" },
  },
}
