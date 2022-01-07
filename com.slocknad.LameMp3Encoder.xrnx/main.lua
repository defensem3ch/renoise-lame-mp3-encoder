local function render()
    local vb = renoise.ViewBuilder()
    local dialog_title = "Render as MP3"
    local dialog_content = vb:column {
        vb:row {
            style="group",
            margin=4,
            vb:chooser {
                items = {"Entire Song", "Selection in Sequence"},
                value = 1
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