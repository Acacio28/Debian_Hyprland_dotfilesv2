-- /* ---- 💫 https://github.com/Acacio28 ---- */
mainMod = "SUPER"
scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"
UserConfigs = os.getenv("HOME") .. "/.config/hypr/UserConfigs"

local Touchpad_Device = "asue1209:00-04f3:319f-touchpad"
local TOUCHPAD_ENABLED = true

hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd(scriptsDir .. "/BrightnessKbd.sh --dec"), { repeating = true })
hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd(scriptsDir .. "/BrightnessKbd.sh --inc"), { repeating = true })
hl.bind("XF86Launch1",           hl.dsp.exec_cmd("rog-control-center"))
hl.bind("XF86Launch3",           hl.dsp.exec_cmd("asusctl led-mode -n"))
hl.bind("XF86Launch4",           hl.dsp.exec_cmd("asusctl profile -n"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --dec"), { repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --inc"), { repeating = true })
hl.bind("XF86TouchpadToggle",    hl.dsp.exec_cmd(scriptsDir .. "/TouchPad.sh"))

hl.bind(mainMod .. " + F6",           hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --now"))
hl.bind(mainMod .. " + SHIFT + F6",   hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --area"))
hl.bind(mainMod .. " + CTRL + F6",    hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --in5"))
hl.bind(mainMod .. " + ALT + F6",     hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --in10"))
hl.bind("ALT + F6",                   hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --active"))

hl.device({
    name    = Touchpad_Device,
    enabled = TOUCHPAD_ENABLED,
})
