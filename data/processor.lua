-- processor.lua

-- Configuration variables (Change these to test!)
local CONFIG = {
    use_fahrenheit = true,
    temp_offset = -1.5,       -- Calibration offset applied to raw temp
    warning_threshold = 85.0  -- Trigger alarm if temp exceeds this
}

-- The function our C program will call
function format_sensor_data(raw_temp, raw_humidity)
    -- 1. Apply calibration offset
    local adjusted_temp = raw_temp + CONFIG.temp_offset

    -- 2. Convert units based on configuration
    local final_temp = adjusted_temp
    local unit = "C"
    
    if CONFIG.use_fahrenheit then
        final_temp = (adjusted_temp * 9/5) + 32
        unit = "F"
    end

    -- 3. Determine if this is a critical warning
    local is_critical = final_temp > CONFIG.warning_threshold

    -- 4. Format the final string
    local output_str = string.format("[SENSOR] Temp: %.1f%s | Humidity: %.1f%%", final_temp, unit, raw_humidity)

    -- Return TWO values back to C: the string and the boolean flag
    return output_str, is_critical
end