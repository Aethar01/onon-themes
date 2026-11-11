-- halftone: brutalist printed on a coarse screen.
--
-- The menus, status pill, tabs and link preview draw halftone.glsl, beside
-- this file: a coarse screen of black dots on white, growing toward the
-- hard shadow, or white on black with :colors alt.
--
-- Showcases: an element's shader, with a thin fill over it. Shaders are
-- experimental: they run with onon.options.shaders = true in config.lua,
-- and without them this is brutalist, its panes see-through.
--
-- Pick it with :theme halftone.

local dir = debug.getinfo(1, "S").source:gsub("^@", ""):match("^(.*[/\\])") or ""
local theme = dofile(dir .. "brutalist.lua")
local e = theme.elements

for _, name in ipairs({ "panel", "status_left", "tab", "link_preview" }) do
  e[name].shader = "halftone.glsl"
end
e.panel.fill = "panel/25"
e.status_left.fill = "#ffe500c0" -- the safety yellow, the dots faint through it
e.tab.fill = "panel/25"
e.link_preview.fill = "panel/25"

return theme
