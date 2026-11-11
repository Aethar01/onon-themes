-- lcd: gameboy with the page seen through its screen.
--
-- The menus, status pill, tabs and link preview draw lcd.glsl, beside this
-- file: what is behind each pane in the four greens, in big pixels with
-- ordered dithering between the shades, and a faint grid between them.
--
-- Showcases: an element's shader, with a thin fill over it. Shaders are
-- experimental: they run with onon.options.shaders = true in config.lua,
-- and without them this is gameboy, its panes see-through.
--
-- Pick it with :theme lcd.

local dir = debug.getinfo(1, "S").source:gsub("^@", ""):match("^(.*[/\\])") or ""
local theme = dofile(dir .. "gameboy.lua")
local e = theme.elements

for _, name in ipairs({ "panel", "status_left", "tab", "link_preview" }) do
  e[name].shader = "lcd.glsl"
end
e.panel.fill = "panel/35"
e.status_left.fill = "panel/35"
e.tab.fill = "panel/35"
e.link_preview.fill = "panel/35"
for _, name in ipairs({ "panel", "status_left", "tab", "link_preview" }) do
  e[name].shadow = false -- the shader is drawn over what is behind it, not over a shadow
end

return theme
