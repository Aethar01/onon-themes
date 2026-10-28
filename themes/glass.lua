-- glass: a onon theme of frosted, floating panes.
--
-- Translucent menus and status pills with soft rounded corners and deep
-- diffuse shadows, so the document shows through everything that floats
-- over it. Menus and messages fade in and out, and the selection and the
-- status pills ease into place. :colors alt is the same glass at night.
--
-- Showcases: translucent fills ("#RRGGBBAA" and "colour/opacity"), element
-- opacity, and the fade transitions that are off by default.
--
-- Pick it with :theme glass.

-- Panels: the pane, then a sheen along its top edge where light catches it.
local function sheen(canvas, box, state)
  canvas:default()
  canvas:rect(1, 1, box.w - 2, math.min(40, box.h / 3), "#ffffff/7", 15)
  canvas:rect(16, 1, box.w - 32, 1, "#ffffff/45")
end

-- The loader: three beads orbiting, each brightening as it passes the top.
local function orbit(canvas, box, state)
  local cx, cy, r = box.w / 2, box.h / 2, 16
  for i = 0, 2 do
    local a = state.time * 3 + i * 2 * math.pi / 3
    local glow = (1 - math.sin(a)) / 2 -- brightest at the top
    local size = 6 + 4 * glow
    local x, y = cx + r * math.cos(a), cy + r * math.sin(a)
    canvas:rect(x - size / 2, y - size / 2, size, size, "accent/" .. math.floor(35 + 60 * glow), size / 2)
  end
end

return {
  base = "moss",

  background = "#dfe4ec",
  page = "#ffffff",
  foreground = "#1c2433",
  muted = "#6b7488",
  accent = "#3b6cf6",
  panel = "#f7f9fc",
  border = "#ffffff",
  status_bar = "#f4f6fa",
  selection = "#c4d6ff",
  search = "#ffe9a3",
  search_current = "#ffc078",
  hint_foreground = "#ffffff",
  presentation = "#0c0f16",

  -- :colors alt: smoked glass over a dark desk and dark pages.
  alt = {
    background = "#0e1118",
    page = "#161a23",
    foreground = "#e3e8f2",
    muted = "#8a93a6",
    accent = "#7aa2ff",
    panel = "#1c2130",
    border = "#ffffff",
    status_bar = "#1a1f2b",
    selection = "#2a3f73", -- added over dark pages
    search = "#5c4a14",
    search_current = "#7a4a1c",
    hint_foreground = "#0e1118",
    presentation = "#05070b",
  },

  radius = 14,
  padding = 10,
  shadow = true,
  status_bar_style = "pill",

  motion = {
    panel = "260ms ease-out", -- menus fade in and out
    message = "320ms ease-in-out", -- and so do messages
    selection = "200ms cubic-bezier(0.22, 1, 0.36, 1)",
    prompt = "240ms cubic-bezier(0.22, 1, 0.36, 1)",
    cursor = "90ms ease-out",
  },

  elements = {
    panel = {
      radius = 16,
      fill = "panel/76",
      border = { width = 1, color = "border/45" },
      shadow = "0 18 44 0 shadow/70, 0 2 6 0 shadow/35",
      padding = { 0, 6, 8, 6 },
      draw = sheen,
    },
    completion = { radius = 14, padding = { 6, 6 } },
    header = {
      radius = 0,
      border = { width = 0 },
      text = "foreground",
      secondary = "muted",
      padding = { 10, 10, 6, 10 },
    },
    row = { radius = 10, padding = { 5, 10 } },
    row_selected = {
      fill = "accent/16",
      border = { width = 0 },
      padding = { 5, 10 },
    },
    row_disabled = { opacity = 0.6 },
    heading = { text = "accent" },
    button = { radius = 10, fill = "accent/12", border = { width = 1, color = "accent/30" }, text = "accent" },
    scrollbar = { fill = "foreground/25", width = 4, margin = { 0, 4, 0, 0 } },
    swatch = { shape = "pill", border = { width = 1, color = "foreground/20" } },

    status = { margin = { 0, 0, 16, 0 }, gap = 10 },
    status_left = {
      shape = "pill",
      fill = "status_bar/70",
      border = { width = 1, color = "border/45" },
      shadow = "0 10 28 0 shadow/55, 0 1 3 0 shadow/30",
      padding = { 6, 16 },
    },
    status_right = { text = "muted", opacity = 0.9 },
    prompt = { text = "accent" },
    cursor = { fill = "accent", width = 2, radius = 1 },
    input_selection = { fill = "accent/25", radius = 3 },
    -- Text fields, buttons and check boxes in plugins' views.
    input = { radius = 10, fill = "background/40", border = { width = 1, color = "foreground/15" } },
    input_focused = { border = { width = 1, color = "accent/70" }, shadow = "0 0 0 3 accent/20" },
    button_focused = { fill = "accent/28", border = { width = 1, color = "accent/60" } },
    check = { radius = 3, fill = "accent" },

    hint = {
      shape = "pill",
      fill = "accent/88",
      text = "hint_foreground",
      secondary = "hint_foreground/55",
      shadow = "0 3 8 0 shadow/60",
      padding = { 2, 8 },
    },
    overview_selection = {
      radius = 10,
      border = { width = 2, color = "accent/80" },
      shadow = "0 0 18 0 accent/30",
      padding = 5,
    },
    link_preview = {
      radius = 12,
      border = { width = 1, color = "border/50" },
      shadow = "0 18 44 0 shadow/70, 0 2 6 0 shadow/35",
    },
    page = { shadow = "0 12 32 0 shadow/45, 0 1 3 0 shadow/35" },
    loader = { fill = "accent", draw = orbit },
    autoscroll_marker = { fill = "panel/80", border = { width = 1, color = "foreground/30" } },

    title_bar = { fill = "status_bar/80" },
    title_button = { fill = "foreground/10" },
  },
}
