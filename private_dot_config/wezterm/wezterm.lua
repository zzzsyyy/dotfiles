local wezterm = require 'wezterm'

local function get_theme()
	local _time = os.date("*t").hour
	if _time >= 5 and _time < 20 then
		return "dawnfox"
  else
    return "nordfox"
	end
end

local config = {
    -- Window
    check_for_updates = false,
    enable_scroll_bar = true,
    window_background_opacity = 0.96,
    adjust_window_size_when_changing_font_size = true,
    window_padding = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5
    },
    window_background_image_hsb = {
        brightness = 0.8,
        hue = 1.0,
        saturation = 1.0
    },

    -- Fonts
    font = wezterm.font_with_fallback {'Iosevka ZT', 'Noto Sans CJK SC', monospace},
    font_size = 13,

    -- Tab bar
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,
    show_tab_index_in_tab_bar = false,
    tab_max_width = 25,
    -- tab_bar_at_bottom = true,
    -- use_fancy_tab_bar = false,

    -- Keys
    disable_default_key_bindings = false,
    leader = {
        key = 'b',
        mods = 'CTRL'
    },

    keys = {{
        key = 't',
        mods = 'CTRL',
        action = wezterm.action {
            SpawnTab = 'CurrentPaneDomain'
        }
    }, {
        key = 'q',
        mods = 'CTRL',
        action = wezterm.action {
            CloseCurrentTab = {
                confirm = true
            }
        }
    }, {
        key = 'a',
        mods = 'CTRL',
        action = wezterm.action.SendString '\x01'
    }, -- Pane navigation
    {
        key = 'LeftArrow',
        mods = 'ALT',
        action = wezterm.action {
            ActivatePaneDirection = 'Left'
        }
    }, {
        key = 'DownArrow',
        mods = 'ALT',
        action = wezterm.action {
            ActivatePaneDirection = 'Down'
        }
    }, {
        key = 'UpArrow',
        mods = 'ALT',
        action = wezterm.action {
            ActivatePaneDirection = 'Up'
        }
    }, {
        key = 'RightArrow',
        mods = 'ALT',
        action = wezterm.action {
            ActivatePaneDirection = 'Right'
        }
    }, -- Tab navigation
    {
        key = 'z',
        mods = 'ALT',
        action = 'TogglePaneZoomState'
    }, {
        key = '1',
        mods = 'ALT',
        action = wezterm.action {
            ActivateTab = 0
        }
    }, {
        key = '2',
        mods = 'ALT',
        action = wezterm.action {
            ActivateTab = 1
        }
    }, {
        key = '3',
        mods = 'ALT',
        action = wezterm.action {
            ActivateTab = 2
        }
    }, {
        key = '4',
        mods = 'ALT',
        action = wezterm.action {
            ActivateTab = 3
        }
    }, {
        key = '5',
        mods = 'ALT',
        action = wezterm.action {
            ActivateTab = 4
        }
    }, {
        key = '6',
        mods = 'ALT',
        action = wezterm.action {
            ActivateTab = 5
        }
    }, -- Split
    {
        key = '-',
        mods = 'CTRL',
        action = wezterm.action.SplitVertical {
            domain = 'CurrentPaneDomain'
        }
    }, {
        key = '=',
        mods = 'CTRL',
        action = wezterm.action.SplitHorizontal {
            domain = 'CurrentPaneDomain'
        }
    }, -- V12
    {
        key = '[',
        mods = 'CTRL',
        action = wezterm.action.Multiple {wezterm.action.SplitPane {
            direction = 'Right',
            size = {
                Percent = 40
            }
        }, wezterm.action.SplitPane {
            direction = 'Down',
            size = {
                Percent = 40
            }
        }}
    }, -- H12
    {
        key = ']',
        mods = 'CTRL',
        action = wezterm.action.Multiple {wezterm.action.SplitPane {
            direction = 'Down',
            size = {
                Percent = 40
            }
        }, wezterm.action.SplitPane {
            direction = 'Left',
            size = {
                Percent = 60
            }
        }}
    }, -- Square
    {
        key = ';',
        mods = 'CTRL',
        action = wezterm.action.Multiple {wezterm.action.SplitPane {
            direction = 'Right',
            size = {
                Percent = 40
            }
        }, wezterm.action.SplitPane {
            direction = 'Down',
            size = {
                Percent = 50
            }
        }, wezterm.action.SplitPane {
            direction = 'Down',
            size = {
                Percent = 40
            },
            top_level = true
        }}
    }, -- Copy/paste buffer
    {
        key = '[',
        mods = 'LEADER',
        action = 'ActivateCopyMode'
    }, {
        key = ']',
        mods = 'LEADER',
        action = 'QuickSelect'
    }},

    color_scheme = get_theme(),
    inactive_pane_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.0
    },
    mouse_bindings = { -- Paste on right-click
    {
        event = {
            Down = {
                streak = 1,
                button = 'Right'
            }
        },
        mods = 'NONE',
        action = wezterm.action {
            PasteFrom = 'Clipboard'
        }
    }, -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
        event = {
            Up = {
                streak = 1,
                button = 'Left'
            }
        },
        mods = 'NONE',
        action = wezterm.action {
            CompleteSelection = 'PrimarySelection'
        }
    }, -- CTRL-Click open hyperlinks
    {
        event = {
            Up = {
                streak = 1,
                button = 'Left'
            }
        },
        mods = 'CTRL',
        action = 'OpenLinkAtMouseCursor'
    }},
    -- default_prog = default_prog,
    default_cursor_style = "BlinkingBar",
    cursor_blink_rate = 400,
    window_decorations = "RESIZE",
    use_ime = true,
    enable_wayland = true
}

return config
