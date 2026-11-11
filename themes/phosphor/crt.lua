-- crt: phosphor with its panes drawn on a green phosphor tube.
--
-- The menus, status pill, tabs and link preview draw crt.glsl, beside this
-- file: what is behind each pane in phosphor green, bulging toward the
-- edges, with scanlines, a soft bloom and a faint flicker as a refresh
-- rolls up the glass.
--
-- Showcases: an element's shader, with a thin fill over it. Shaders are
-- experimental: they run with onon.options.shaders = true in config.lua,
-- and without them this is phosphor, its panes see-through.
--
-- Pick it with :theme crt.

local dir = debug.getinfo(1, "S").source:gsub("^@", ""):match("^(.*[/\\])") or ""
local theme = dofile(dir .. "phosphor.lua")
local e = theme.elements

for _, name in ipairs({ "panel", "status_left", "tab", "link_preview" }) do
  e[name].shader = "crt.glsl"
end
e.panel.draw = nil -- the shader draws the scanlines
e.panel.fill = "panel/30"
e.status_left.fill = "status_bar/30"
e.tab.fill = "status_bar/30"
e.link_preview.fill = "panel/30"

return theme
