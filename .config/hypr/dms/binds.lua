-- DMS default keybinds (Hyprland 0.55+ Lua)

-- =========================================================================
-- === APPLICATION LAUNCHERS & APPS ===
-- =========================================================================
hl.bind("SUPER + space",       hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
hl.bind("ALT + space",         hl.dsp.exec_cmd("dms ipc call spotlight-bar toggle"))
hl.bind("SUPER + V",           hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
hl.bind("SUPER + comma",       hl.dsp.exec_cmd("dms ipc call settings focusOrToggle"))
hl.bind("SUPER + N",           hl.dsp.exec_cmd("dms ipc call notifications toggle"))
hl.bind("SUPER + SHIFT + N",   hl.dsp.exec_cmd("dms ipc call notepad toggle"))
hl.bind("SUPER + TAB",         hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"))
hl.bind("SUPER + X",           hl.dsp.exec_cmd("dms ipc call powermenu toggle"))

-- === Help & Security ===
hl.bind("SUPER + SHIFT + Slash", hl.dsp.exec_cmd("dms ipc call keybinds toggle hyprland"))
hl.bind("SUPER + ALT + L",       hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind("CTRL + ALT + Delete",   hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"))
hl.bind("SUPER + SHIFT + E",     hl.dsp.exit())

-- =========================================================================
-- === HARDWARE CONTROLS (MEDIA & OUTPUTS) ===
-- =========================================================================
-- === Media Controls (MPRIS) ===
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("dms ipc call mpris previous"),  { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("dms ipc call mpris next"),      { locked = true })

-- === Media Volume (CTRL + Vol) ===
hl.bind("CTRL + XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call mpris increment 3"), { locked = true, repeating = true })
hl.bind("CTRL + XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call mpris decrement 3"), { locked = true, repeating = true })

-- === System Controls ===
hl.bind("SUPER + P",         hl.dsp.exec_cmd("dms ipc call outputs cycleProfile"))
hl.bind("SUPER + SHIFT + P", hl.dsp.dpms({ action = "toggle" }))

-- =========================================================================
-- === WINDOW MANAGEMENT & NAVIGATION ===
-- =========================================================================
-- === Window State ===
hl.bind("SUPER + C",         hl.dsp.window.close())
hl.bind("SUPER + F",         hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + T",         hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + W",         hl.dsp.group.toggle())
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("dms ipc call window-rules toggle"))

-- === Focus Navigation (Vim Keys + Flechas) ===
for _, key in ipairs({ { "left", "l" }, { "H", "l" }, { "down", "d" }, { "J", "d" }, { "up", "u" }, { "K", "u" }, { "right", "r" }, { "L", "r" } }) do
    hl.bind("SUPER + " .. key[1], hl.dsp.focus({ direction = key[2] }))
end
hl.bind("SUPER + Home", hl.dsp.focus({ window = "first" }))
hl.bind("SUPER + End",  hl.dsp.focus({ window = "last" }))

-- === Window Movement (Vim Keys + Flechas) ===
for _, key in ipairs({ { "left", "l" }, { "H", "l" }, { "down", "d" }, { "J", "d" }, { "up", "u" }, { "K", "u" }, { "right", "r" }, { "L", "r" } }) do
    hl.bind("SUPER + SHIFT + " .. key[1], hl.dsp.window.move({ direction = key[2] }))
end

-- === Monitor Navigation & Window Moving ===
for _, key in ipairs({ { "left", "l" }, { "H", "l" }, { "down", "d" }, { "J", "d" }, { "up", "u" }, { "K", "u" }, { "right", "r" }, { "L", "r" } }) do
    hl.bind("SUPER + CTRL + " .. key[1],       hl.dsp.focus({ monitor = key[2] }))
    hl.bind("SUPER + SHIFT + CTRL + " .. key[1], hl.dsp.window.move({ monitor = key[2] }))
end

-- =========================================================================
-- === WORKSPACE MANAGEMENT ===
-- =========================================================================
-- === Navigation (Page Keys, Vim Alternatives & Mouse Wheel) ===
hl.bind("SUPER + Page_Down",  hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + Page_Up",    hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + U",          hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + O",          hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- === Moving Windows to Relative Workspaces ===
hl.bind("SUPER + CTRL + down",       hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + CTRL + up",         hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("SUPER + CTRL + U",          hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + CTRL + I",          hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("SUPER + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + Page_Up",   hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("SUPER + SHIFT + U",         hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + I",         hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("SUPER + CTRL + mouse_down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + CTRL + mouse_up",   hl.dsp.window.move({ workspace = "e-1" }))

-- === Workspace Management ===
hl.bind("CTRL + SHIFT + R", hl.dsp.exec_cmd("dms ipc call workspace-rename open"))
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- === Numbered Workspaces (1-9) ===
for i = 1, 9 do
    hl.bind("SUPER + " .. i,         hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end

-- =========================================================================
-- === LAYOUTS & MOUSE DRAGGING ===
-- =========================================================================
hl.bind("SUPER + bracketleft",  hl.dsp.layout("preselect l"))
hl.bind("SUPER + bracketright", hl.dsp.layout("preselect r"))
hl.bind("SUPER + R",            hl.dsp.layout("togglesplit"))
hl.bind("SUPER + CTRL + F",     hl.dsp.window.fullscreen({ mode = "maximized", action = "set" }))

-- === Mouse Window Controls ===
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- === Manual Resizing (Teclas físicas fijas) ===
hl.bind("SUPER + code:20", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { description = "Expand window left" })
hl.bind("SUPER + code:21", hl.dsp.window.resize({ x = 100, y = 0, relative = true }),  { description = "Shrink window left" })

hl.bind("SUPER + minus", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + equal", hl.dsp.window.resize({ x = 100, y = 0, relative = true }),  { repeating = true })

-- =========================================================================
-- === SCREENSHOTS ===
-- =========================================================================
hl.bind("Print",        hl.dsp.exec_cmd("dms screenshot"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("dms screenshot full"))
hl.bind("ALT + Print",  hl.dsp.exec_cmd("dms screenshot window"))
