-- nosferatu: vampire with blood seeping into its panes.
--
-- The menus, status pill, tabs and link preview draw nosferatu.glsl, beside
-- this file: what is behind each pane dim and drained of colour, with
-- blood seeping in from the edges, its reach rising and falling with a
-- slow heartbeat.
--
-- Showcases: an element's shader, with a thin fill over it. Shaders are
-- experimental: they run with onon.options.shaders = true in config.lua,
-- and without them this is vampire, its panes see-through.
--
-- Pick it with :theme nosferatu.

local dir = debug.getinfo(1, "S").source:gsub("^@", ""):match("^(.*[/\\])") or ""
local theme = dofile(dir .. "vampire.lua")
local e = theme.elements

for _, name in ipairs({ "panel", "status_left", "tab", "link_preview" }) do
  e[name].shader = "nosferatu.glsl"
end
e.panel.fill = "panel/40"
e.status_left.fill = "status_bar/40"
e.tab.fill = "status_bar/40"
e.link_preview.fill = "panel/40"

return theme
