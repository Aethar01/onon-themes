-- liquid: the glass theme with its panes run through a shader.
--
-- The menus, status pills and tabs draw liquid.glsl, beside this file:
-- what is behind each pane, softened, bent at the rim as by a lens, and
-- lit along its edge. Their fills are thinner than glass's, tinting the
-- shader rather than standing in for it.
--
-- Showcases: an element's shader, with a fill over it. Shaders are
-- experimental: they run with onon.options.shaders = true in config.lua,
-- and without them this is glass.
--
-- Pick it with :theme liquid.

local dir = debug.getinfo(1, "S").source:gsub("^@", ""):match("^(.*[/\\])") or ""
local theme = dofile(dir .. "glass.lua")
local e = theme.elements

for _, name in ipairs({ "panel", "status_left", "tab", "link_preview" }) do
  e[name].shader = "liquid.glsl"
end
e.panel.fill = "panel/38"
e.status_left.fill = "status_bar/30"
e.tab.fill = "status_bar/30"

return theme
