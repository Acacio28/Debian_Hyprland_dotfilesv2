-- /* ---- 💫 https://github.com/Acacio28 ---- */
-- Fallback defaults + applies hyprland-gui.conf at startup

-- Apply saved GUI settings from .conf (callable on startup & lid open)
local function apply_gui_conf()
  local f = io.open(os.getenv("HOME") .. "/.config/hypr/hyprland-gui.conf", "r")
  if not f then return end
  for line in f:lines() do
    line = line:gsub("#.*", "")
    local key, val = line:match("^%s*([^=]+)%s*=%s*(.-)%s*$")
    if key and val and not key:match("^monitor") then
      val = val:gsub("%s*%d+deg%s*$", "")
      local parts = {}
      for p in key:gmatch("[^:%.]+") do
        table.insert(parts, p)
      end
      if #parts > 0 then
        local inner = "{" .. table.concat(parts, "={") .. "=" .. string.format("%q", val) .. string.rep("}", #parts)
        hl.exec_cmd("hyprctl eval 'hl.config(" .. inner .. ")'")
      end
    end
  end
  f:close()
end

hl.on("hyprland.start", apply_gui_conf)
hl.on("monitor.added", apply_gui_conf)

hl.env("XCURSOR_THEME", "Breeze_Light")
hl.env("XCURSOR_SIZE", "24")

hl.config({
    general = {
        allow_tearing    = false,
        border_size      = 2,
        layout = "dwindle",
    },
    input = {
        natural_scroll = false,
        scroll_factor  = 0.8,
    },
})

hl.curve("easeOut", { type = "bezier", points = { {0.0, 0.0}, {0.58, 1.0} } })

hl.animation({ leaf = "windowsMove", enabled = true, speed = 6.0, bezier = "easeOut", style = "slide" })
hl.animation({ leaf = "layers",      enabled = true, speed = 7.5, bezier = "default", style = "slide" })
