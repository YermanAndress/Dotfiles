-- Atajos de usuario personalizados y sobreescrituras para DMS

-- =========================================================================
-- === HARDWARE OVERRIDES (INCREMENTOS PERSONALIZADOS DE 5) ===
-- =========================================================================
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("dms ipc call audio increment 5"),            { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("dms ipc call audio decrement 5"),            { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("dms ipc call audio mute"),                    { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]), { locked = true, repeating = true })
hl.bind("XF86TouchpadToggle",    hl.dsp.exec_cmd("~/Scripts/touchpad_toggle.sh"),             { locked = true })

-- =========================================================================
-- === PERSONAL APPLICATION LAUNCHERS (UWSM ENVIROMENT) ===
-- =========================================================================
hl.bind("SUPER + Q",         hl.dsp.exec_cmd("uwsm-app kitty"))
hl.bind("SUPER + E",         hl.dsp.exec_cmd("uwsm-app thunar"))
hl.bind("SUPER + B",         hl.dsp.exec_cmd("uwsm-app helium-browser"))
hl.bind("SUPER + I",         hl.dsp.exec_cmd("uwsm-app intellij-idea-ultimate-edition &"))
hl.bind("SUPER + Y",         hl.dsp.exec_cmd("uwsm-app spotify-launcher"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("uwsm-app code"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

-- =========================================================================
-- === CUSTOM SIZING & LAYOUT ADJUSTMENTS ===
-- =========================================================================
-- Redimensionamiento Vertical (Tus binds del SHIFT + minus/equal corregidos en número)
hl.bind("SUPER + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 100, relative = true }),  { repeating = true })

-- Inversión de división de ventanas en Dwindle
hl.bind("SUPER + SHIFT + R", hl.dsp.layout("swapsplitq"))
