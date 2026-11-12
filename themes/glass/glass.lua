-- glass: a onon theme of frosted, floating panes.
--
-- Translucent menus and status pills with soft rounded corners and deep
-- diffuse shadows, so the document shows through everything that floats
-- over it. Everything moves alike, on one spring: menus and messages pop
-- in as bubbles of glass, the selection, the tabs and the status pills
-- glide into place, and the pills glide in and out from the window's
-- edges, what a choice moves stretching as a drop of glass does. :colors
-- alt is the same glass at night.
--
-- With onon.options.shaders = true, the menus, status pills, tabs and the
-- selection draw glass.glsl, beside this file: what is behind each pane,
-- softened, what lies just beyond it bent in at its rim as by a lens, and
-- light caught along its edge. Their fills are
-- thinner then, tinting the shader rather than standing in for it.
--
-- Showcases: translucent fills ("#RRGGBBAA" and "colour/opacity"), element
-- opacity, one motion shared by every target through Lua locals, springs
-- and stretch, and a reduced motion table that crossfades where the rest
-- moves.
--
-- Pick it with :theme glass.

-- Panels: the pane, then a sheen along its top edge where light catches it,
-- fading out down the header. The canvas has no gradients, so the sheen is
-- layers of faint glass, each a little taller, brightest where they all
-- overlap at the top.
local function sheen(canvas, box, state)
  canvas:default()
  local h, layers = math.min(44, box.h / 2), 8
  for i = 1, layers do
    canvas:rect(1, 1, box.w - 2, h * i / layers, "#ffffff/1", 15)
  end
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

-- The glass's one motion: how everything moves, and how far what a choice
-- moves stretches; and so how panes come, a bubble of glass, and go.
local move = "380ms spring(260, 27)"
local stretch = "stretch:35ms"
local come = "fade scale:0.9 " .. move .. " " .. stretch
local go = "fade scale:0.96 180ms ease-in"

local theme = {
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
  tab_bar_style = "pill",

  -- Everything that moves moves alike, as the tab shown does: on one
  -- spring, settling with a little give (move). What a choice moves
  -- stretches as it goes (stretch), as a drop of glass does, and panes
  -- and messages pop in as bubbles of it (come), and go quickly (go);
  -- what only follows the pointer does not stretch.
  motion = {
    panel = { enter = come, exit = go },
    rows = "none", -- they come with their pane
    message = { enter = come, exit = go },
    -- The selection follows the pointer, so it glides there without a
    -- stretch. Held down, by Enter or the pointer, the glass gives under
    -- it, and springs back as it is let go and the row is chosen.
    selection = { change = "glide " .. move, press = "scale:0.96 " .. move },
    overview_selection = "glide " .. move,
    -- The tab shown, which a choice moves, stretches towards the tab, its
    -- far end catching up after. The tabs glide to their places as they
    -- open, close and move, and a tab held down gives as a row does.
    tab_selection = { change = "glide " .. move .. " " .. stretch, press = "scale:0.96 " .. move },
    hover = { enter = "fade 140ms ease-out", exit = "fade 260ms ease-out" },
    -- Another tab's document clears into view as the last one fades.
    document = "fade " .. move,
    -- The status pill stretches thin to take a prompt's or a message's
    -- text, and swells a little as it settles, as the tab shown does.
    prompt = "glide " .. move .. " " .. stretch,
    cursor = "glide 90ms ease-out", -- quick, to keep up with typing
    -- The pills glide in from the edges, stretching as they come.
    edges = "fade slide " .. move .. " " .. stretch,
    -- With less motion the glass only clears and clouds: nothing moves, and
    -- the selection crossfades from row to row.
    reduced = {
      panel = { enter = "fade 220ms ease-out", exit = "fade 160ms ease-in" },
      selection = "crossfade 160ms ease-in-out",
      overview_selection = "crossfade 160ms ease-in-out",
      tab_selection = "crossfade 160ms ease-in-out",
      document = "fade 180ms ease-out",
    },
  },

  elements = {
    panel = {
      radius = 16,
      fill = "panel/76",
      border = { width = 1, color = "border/45" },
      shadow = "0 18 44 0 shadow/70, 0 2 6 0 shadow/35",
      padding = { 0, 10, 10, 10 },
      draw = sheen,
    },
    completion = { radius = 14, padding = { 6, 6 } },
    header = {
      radius = 0,
      border = { width = 0 },
      text = "foreground",
      secondary = "muted",
      padding = { 12, 18, 10, 18 },
    },
    row = { radius = 14, padding = { 5, 8 } }, -- the theme's radius, so its selection is rounded as the panes are
    row_selected = {
      fill = "accent/16",
      border = { width = 0 },
      padding = { 5, 8 },
    },
    row_disabled = { opacity = 0.6 },
    heading = { text = "accent" },
    button = { radius = 10, fill = "accent/12", border = { width = 1, color = "accent/30" }, text = "accent" },
    scrollbar = { fill = "foreground/25", width = 3, margin = { 0, 4, 0, 0 } },
    swatch = { shape = "pill", border = { width = 1, color = "foreground/20" } },

    status = { margin = { 0, 16, 16, 16 }, gap = 10 },
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

    -- Tabs: frosted pills floating over the page, as the status bar's are,
    -- the tab shown only by its name, in bold.
    tab_bar = { margin = { 16, 16, 0, 16 }, gap = 8 },
    tab = {
      shape = "pill",
      fill = "status_bar/70",
      border = { width = 1, color = "border/45", sides = "all" },
      shadow = "0 10 28 0 shadow/55, 0 1 3 0 shadow/30",
      text = "muted",
      padding = { 4, 16 },
    },
    -- The tab shown is a brighter pane that glides over the others, which
    -- clear where it passes.
    tab_selected = {
      fill = "panel/85",
      border = { width = 1, color = "border/80", sides = "all" },
      shadow = "0 12 30 0 shadow/60, 0 1 3 0 shadow/30",
      text = "foreground",
      bold = true,
    },
    tab_hover = { fill = "status_bar/88", border = { width = 1, color = "border/65", sides = "all" }, text = "foreground" },

    title_bar = { fill = "status_bar/80" },
    title_button = { fill = "foreground/10" },
  },
}

-- With shaders on, the panes draw glass.glsl, under fills thin enough
-- to show it. Glass lets most light through, so it casts lighter shadows
-- than the frosted panes do, which show through it.
if onon.options.shaders then
  local e = theme.elements
  e.panel.shadow = "0 18 44 0 shadow/30, 0 2 6 0 shadow/20"
  e.link_preview.shadow = e.panel.shadow
  e.status_left.shadow = "0 10 28 0 shadow/25, 0 1 3 0 shadow/18"
  e.tab.shadow = e.status_left.shadow

  for _, name in ipairs({ "panel", "status_left", "tab", "link_preview" }) do
    e[name].shader = "glass.glsl"
  end
  e.panel.fill = "panel/38"
  e.status_left.fill = "status_bar/30"
  e.tab.fill = "status_bar/30"
  -- The selection is a pane of the same glass, glass.glsl, under the row
  -- or tab it selects, its text drawn clear over it, untinted, with the
  -- panes' rim and shadow.
  e.row_selected.shader = "glass.glsl"
  e.row_selected.fill = "panel/30"
  e.row_selected.border = { width = 1, color = "border/45", sides = "all" }
  e.tab_selected.shader = "glass.glsl"
  e.tab_selected.fill = "panel/45"
  e.tab_selected.shadow = e.tab.shadow
  e.tab_hover.fill = "status_bar/48"
end

return theme
