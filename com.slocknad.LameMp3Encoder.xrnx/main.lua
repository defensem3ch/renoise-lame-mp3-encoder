local function render()
    local vb = renoise.ViewBuilder()
    local DIALOG_MARGIN = renoise.ViewBuilder.DEFAULT_DIALOG_MARGIN
    local CONTENT_SPACING = renoise.ViewBuilder.DEFAULT_CONTROL_SPACING
    local FILE_PATH = string.match(renoise.song().file_name, "(.+\\)[a-z|0-9]+.xrns")
    local SONG_TITLE = string.match(renoise.song().file_name, "([a-z|0-9]+).xrns")

    local dialog_title = "Render as MP3"
    
    local dialog_content = vb:column {
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
                    width = 200,
                    value = FILE_PATH
                }
            },
            vb:row {
                vb:text {
                    text = "Song title: "
                },
                vb:textfield {
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
                    width = 200,
                    items = {"Real Time", "Offline"},
                    value = 1
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
                text = "Render as MP3"
            },
            vb:column {
                style = "plain",
                vb:text {
                    text = "0%",
                    width = 1
                    notifier = function() button_click() end
                }
            }
        }
    }

    renoise.app():show_custom_dialog(dialog_title,dialog_content)
end


renoise.tool():add_menu_entry {
    name = "Main Menu:File:Render Song As MP3",
    invoke = function() render() end
}