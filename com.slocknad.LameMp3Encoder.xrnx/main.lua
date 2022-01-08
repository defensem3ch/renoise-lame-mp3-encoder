local function render()
    local vb = renoise.ViewBuilder()
    local dialog_title = "Render as MP3"
    local dialog_content = vb:column {
        margin = 4,
        vb:column {
            style = "group",
            margin = 4,
            --[[vb:row {
                vb:text{
                    height = 20,
                    width = 400,
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
                vb:text{
                    height = 20,
                    width = 400,
                    align = "center",
                    font = "bold",
                    style = "strong",
                    text = "Destination"
                }
            },
            vb:row {
                vb:textfield {
                    value = "C:\\"
                }
            }
        },
        vb:column {
            style = "group",
            margin = 4,
            vb:row {
                vb:text{
                    height = 20,
                    width = 400,
                    align = "center",
                    font = "bold",
                    style = "strong",
                    text = "Render Mode"
                }
            },
            vb:row {
                vb:switch {
                    width = 200;
                    items = {"Real Time", "Offline"},
                    value = 1
                }
            }
        },
        vb:column {
            style = "group",
            margin = 4,
            vb:text{
                height = 20,
                width = 381,
                align = "center",
                font = "bold",
                style = "strong",
                text = "Render Options"
            },
            vb:row{
                vb:text{
                    height = 20,
                    width = 100,
                    align = "right",
                    text = "Priority"
                },
                vb:popup {
                    height = 20,
                    width = 300,
                    value = 2,
                    items = {"Low (render in background)", "High (as fast as possible)"},
                    notifier = function(value) rnd_options_priority(value) end
                }
            },
            vb:row{
                vb:text{
                    height = 20,
                    width = 100,
                    align = "right",
                    text = "Interpolation"
                },
                vb:popup {
                    height = 20,
                    width = 300,
                    value = 2,
                    items = {"Default (as played)","Precise (HQ, but slow)"},
                }
            },
            vb:row{
                vb:text{
                    height = 20,
                    width = 100,
                    align = "right",
                    text = "Sample Rate"
                },
                vb:popup {
                    height = 20,
                    width = 300,
                    value = 3,
                    items = {"22.050 Hz","44.100 Hz","48.000 Hz","88.200 Hz","96.000 Hz","192.000 Hz"},
                }
            },
            vb:row{
                vb:text{
                    height = 20,
                    width = 100,
                    align = "right",
                    text = "Bit depth"
                },
                vb:popup {
                    height = 20,
                    width = 300,
                    value = 2,
                    items = {"16 Bit","24 Bit","32 Bit"},
                }
            }
        }
    }
    local dialog_buttons = {"Nothing"}
    renoise.app():show_custom_prompt (
        dialog_title, dialog_content, dialog_buttons
    )
end


renoise.tool():add_menu_entry {
    name = "Main Menu:File:Render Song As MP3",
    invoke = function() render() end
}