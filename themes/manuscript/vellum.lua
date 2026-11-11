-- vellum: manuscript on a sheet of calfskin.
--
-- The menus, status pill, tabs and link preview draw vellum.glsl, beside
-- this file: what is behind each pane faint and yellowed through the
-- sheet, with its fibres and grain, and ink soaked in along its torn
-- edges.
--
-- Showcases: an element's shader, with a thin fill over it. Shaders are
-- experimental: they run with onon.options.shaders = true in config.lua,
-- and without them this is manuscript, its panes see-through.
--
-- Pick it with :theme vellum.

local dir = debug.getinfo(1, "S").source:gsub("^@", ""):match("^(.*[/\\])") or ""
local theme = dofile(dir .. "manuscript.lua")
local e = theme.elements

for _, name in ipairs({ "panel", "status_left", "tab", "link_preview" }) do
  e[name].shader = "vellum.glsl"
end
e.panel.fill = "panel/30"
e.status_left.fill = "status_bar/30"
e.tab.fill = "status_bar/30"
e.link_preview.fill = "panel/30"

return theme
