-- config.lua
window_title = "My Awesome App"

-- A function we will call from C
function calculate_window_size(aspect_ratio)
    local width = 1920
    local height = width / aspect_ratio
    return width, height -- Lua can return multiple values!
end