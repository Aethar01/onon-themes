-- vhs: synthwave played back off a worn tape.
--
-- The menus, status pill, tabs and link preview draw vhs.glsl, beside this
-- file: what is behind each pane with its red and blue split apart, a
-- tracking line drifting slowly down through it, and a neon rim fading
-- from pink to cyan.
--
-- Showcases: an element's shader, with a thin fill over it. Shaders are
-- experimental: they run with onon.options.shaders = true in config.lua,
-- and without them this is synthwave, its panes see-through.
--
-- Pick it with :theme vhs.

local dir = debug.getinfo(1, "S").source:gsub("^@", ""):match("^(.*[/\\])") or ""
local theme = dofile(dir .. "synthwave.lua")
local e = theme.elements

for _, name in ipairs({ "panel", "status_left", "tab", "link_preview" }) do
  e[name].shader = "vhs.glsl"
end
e.panel.fill = "panel/40"
e.status_left.fill = "status_bar/40"
e.tab.fill = "status_bar/40"
e.link_preview.fill = "panel/40"

return theme
