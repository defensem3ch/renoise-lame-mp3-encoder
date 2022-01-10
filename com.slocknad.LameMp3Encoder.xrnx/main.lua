local vb = renoise.ViewBuilder()
local views = vb.views
local dialog_content = nil
local init_flag = false
local init_file = nil
--local render_flag = false



local function get_options()
    -- switch function found in http://lua-users.org/wiki/SwitchStatement
    local switch = function(cases,arg)
        if (tostring(cases[arg]) == cases[arg]) then
            return assert (loadstring ('return "' .. cases[arg] .. '"'))()
        else
            return assert (loadstring ('return ' .. cases[arg]))()
        end
    end
      
    --sample rate
    local case = views.sample_rate.value
    local sample_rate = switch({
        [1] = 22050,
        [2] = 44100,
        [3] = 48000,
        [4] = 88200,
        [5] = 96000,
        [6] = 192000
    }, case)

    --bit depth
    case = views.bit_depth.value
    local bit_depth = switch({
        [1] = 16,
        [2] = 24,
        [3] = 32,
    }, case)

    --interpolation
    case = views.interpolation.value
    local interpolation = switch({
        [1] = "default",
        [2] = "precise"
    }, case)

    --priority
    local priority = nil
    if (views.render_mode.value == 1) then
        priority = "realtime"
    else
        case = views.priority.value
        local priority = switch({
            [1] = "low",
            [2] = "high"
        }, case)
    end

    return {nil, nil, sample_rate, bit_depth, interpolation, priority}
end

local function rendering_done()
    --render_flag = false
    local title = views.views_path.text .. views.views_title.text
    views.progress_bar.text = "Successfully rendered."
    views.render_button.text = "Render as MP3"
    os.execute("lame \"" .. title .. ".wav\" \"" .. title .. ".mp3\"")
    os.execute("del\"" .. title .. ".wav\"")
end

local function render_mode_click()
    if (views.render_mode.value == 1) then
        views.priority.value = 2
        views.priority.active = false
        views.interpolation.value = 1
        views.interpolation.active = false
        views.sample_rate.value = 2
        views.sample_rate.active = false
    else
        views.priority.active = true
        views.interpolation.active = true
        views.sample_rate.active = true
    end
end

local function render_button_click()
    if (views.render_button.text == "Stop rendering") then
        renoise.song():cancel_rendering()
        views.render_button.text = "Render as MP3"
        views.progress_bar.text = "Cancelled."
    else
        views.render_button.text = "Stop rendering"
        if (string.match(views.views_title.text, ".+.mp3")) then
            views.views_title.text = string.match(views.views_title.text, "(.+).mp3")
        end
        local options = get_options()
        local title = views.views_path.text .. views.views_title.text
        local flag = renoise.song():render(options, title, function() rendering_done() end)
        views.progress_bar.text = "Rendering..."
        --render_flag = true
        --[[while (render_flag)
        do
            local rounded_progress =  math.floor(renoise.song().rendering_progress * 10 + 0.5) * 10
            views.progress_bar.text = tostring(rounded_progress)
            if (rounded_progress > 0) then
                views.progress_bar.width = rounded_progress
            end
        end]]--
    end
end

local function render()
    local DIALOG_MARGIN = renoise.ViewBuilder.DEFAULT_DIALOG_MARGIN
    local CONTENT_SPACING = renoise.ViewBuilder.DEFAULT_CONTROL_SPACING
    local FILE_PATH = string.match(renoise.song().file_name, "(.+\\)[%w|%s]+.xrns")
    local SONG_TITLE = string.match(renoise.song().file_name, "([%w|%s]+).xrns")
    local dialog_title = "Render as MP3"

    if (init_flag) then
        views.progress_bar.text = ""
        if (not(init_file == SONG_TITLE)) then
            views.views_title.text = SONG_TITLE
            views.views_path.text = FILE_PATH
            init_file = SONG_TITLE
        end
    end

    if (not(dialog_content)) then
        init_flag = true
        init_file = SONG_TITLE
        dialog_content = vb:column {
            margin = DIALOG_MARGIN,
            spacing = CONTENT_SPACING,
            vb:column {
                style = "group",
                margin = DIALOG_MARGIN,
                spacing = CONTENT_SPACING,
                --[[vb:row {
                    vb:text{
                        height = 20,
                        width = 300,
                        align = "center",
                        font = "bold",
                        style = "strong",
                        text = "Part to Render"
                    }
                },
                vb:row {
                    vb:chooser {
                        items = {"Entire Song", "Selection in Sequence"},
                        value = 1
                    }
                },]]
                vb:row {
                    vb:text {
                        height = 20,
                        width = 300,
                        align = "center",
                        font = "bold",
                        style = "strong",
                        text = "Destination"
                    }
                },
                vb:row {
                    vb:text {
                        text = "File path: "
                    },
                    vb:textfield {
                        id = "views_path",
                        width = 200,
                        value = FILE_PATH
                    }
                },
                vb:row {
                    vb:text {
                        text = "Song title: "
                    },
                    vb:textfield {
                        id = "views_title",
                        value = SONG_TITLE
                    }
                }
            },
            vb:column {
                style = "group",
                margin = DIALOG_MARGIN,
            spacing = CONTENT_SPACING,
                vb:row {
                    vb:text{
                        align = "center",
                        height = 20,
                        width = 300,
                        font = "bold",
                        style = "strong",
                        text = "Render Mode"
                    }
                },
                vb:row {
                    vb:switch {
                        id = "render_mode",
                        width = 200,
                        items = {"Real Time", "Offline"},
                        value = 2,
                        notifier = function() render_mode_click() end
                    }
                }
            },
            vb:column {
                style = "group",
                margin = DIALOG_MARGIN,
                spacing = CONTENT_SPACING,
                vb:text{
                    height = 20,
                    width = 300,
                    align = "center",
                    font = "bold",
                    style = "strong",
                    text = "Render Options"
                },
                vb:row{
                    vb:text{
                        height = 20,
                        width = 100,
                        text = "Priority"
                    },
                    vb:popup {
                        id = "priority",
                        height = 20,
                        width = 200,
                        value = 2,
                        items = {"Low (render in background)", "High (as fast as possible)"},
                    }
                },
                vb:row{
                    vb:text{
                        height = 20,
                        width = 100,
                        text = "Interpolation"
                    },
                    vb:popup {
                        id = "interpolation",
                        height = 20,
                        width = 200,
                        value = 2,
                        items = {"Default (as played)","Precise (HQ, but slow)"},
                    }
                },
                vb:row{
                    vb:text{
                        height = 20,
                        width = 100,
                        text = "Sample Rate"
                    },
                    vb:popup {
                        id = "sample_rate",
                        height = 20,
                        width = 200,
                        value = 3,
                        items = {"22.050 Hz","44.100 Hz","48.000 Hz","88.200 Hz","96.000 Hz","192.000 Hz"},
                    }
                },
                vb:row{
                    vb:text{
                        height = 20,
                        width = 100,
                        text = "Bit depth"
                    },
                    vb:popup {
                        id = "bit_depth",
                        height = 20,
                        width = 200,
                        value = 2,
                        items = {"16 Bit","24 Bit","32 Bit"},
                    }
                }
            },
            vb:row {
                style = "group",
                margin = DIALOG_MARGIN,
                spacing = CONTENT_SPACING,
                width = 350,
                vb:button {
                    id = "render_button",
                    text = "Render as MP3",
                    notifier = function() render_button_click() end
                },
                vb:column {
                    style = "plain",
                    vb:text {
                        id = "progress_bar",
                        width = 200
                    }
                }
            }
        }
    end

    renoise.app():show_custom_dialog(dialog_title,dialog_content)
end

renoise.tool():add_menu_entry {
    name = "Main Menu:File:Render Song As MP3",
    invoke = function() render() end
}