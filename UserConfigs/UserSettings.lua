hl.config({
    dwindle = {
        preserve_split      = true,
        special_scale_factor = 0.8,
    },
    master = {
        new_status = "master",
        new_on_top = 1,
        mfact      = 0.5,
    },
    general = {
        resize_on_border = true,
        layout = "dwindle",
    },
    input = {
        kb_layout               = "us",
        kb_variant              = "",
        kb_model                = "",
        kb_options              = "",
        kb_rules                = "",
        repeat_rate             = 50,
        repeat_delay            = 300,
        sensitivity             = 0,
        numlock_by_default      = true,
        left_handed             = false,
        follow_mouse            = 1,
        float_switch_override_focus = false,
        touchpad = {
            disable_while_typing  = true,
            natural_scroll        = true,
            clickfinger_behavior  = false,
            middle_button_emulation = false,
            tap_to_click          = true,
            drag_lock             = false,
        },
        touchdevice = {
            enabled = true,
        },
        tablet = {
            transform   = 0,
            left_handed = 0,
        },
    },
    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        vrr                      = 2,
        mouse_move_enables_dpms  = true,
        enable_swallow           = false,
        swallow_regex            = "^(kitty)$",
        focus_on_activate        = false,
        initial_workspace_tracking = 0,
        middle_click_paste       = false,
        enable_anr_dialog        = true,
        anr_missed_pings         = 15,
        allow_session_lock_restore = true,
    },
    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles   = true,
        pass_mouse_when_bound    = false,
    },
    xwayland = {
        enabled            = true,
        force_zero_scaling = true,
    },
    render = {
        direct_scanout = 0,
    },
    cursor = {
        sync_gsettings_theme     = true,
        no_hardware_cursors      = 2,
        enable_hyprcursor        = true,
        warp_on_change_workspace = 2,
        no_warps                 = true,
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
    invert    = true,
    distance  = 500,
})
