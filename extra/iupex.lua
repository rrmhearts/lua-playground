-- Load the IUP Lua binding
require("iuplua")

-- 1. Create the multiline text area
local text_box = iup.text {
    multiline = "YES",
    expand = "YES", -- Tells the widget to fill all available window space
    font = "Courier, 12"
}

-- 2. Create a "Clear" button to show how event callbacks work
local btn_clear = iup.button {
    title = "Clear Text"
}

-- Define what happens when the button is clicked
function btn_clear:action()
    text_box.value = "" -- Clear the text inside the box
    return iup.DEFAULT
end

-- 3. Arrange the widgets in a vertical box layout (vbox)
local layout = iup.vbox {
    text_box,
    btn_clear
}

-- 4. Create the main application window (dialog)
local main_window = iup.dialog {
    layout,
    title = "Simple Lua Editor",
    size = "QUARTERxQUARTER" -- Takes up a quarter of the screen
}

-- 5. Show the window
main_window:showxy(iup.CENTER, iup.CENTER)

-- 6. Start the GUI event loop to keep the program running
if (iup.MainLoopLevel() == 0) then
    iup.MainLoop()
end