# Process sensor data

```sh
gcc main.c -o sensor_app -I/usr/include/lua5.3 -llua5.3 -lm
```

Run it with `./sensor_app`. The output might look like the following:
```log
--- Starting C Program ---
LOG: [SENSOR] Temp: 68.9F | Humidity: 45.0%
LOG: [SENSOR] Temp: 80.6F | Humidity: 50.0%
!!! ALARM !!! [SENSOR] Temp: 92.3F | Humidity: 65.0%
```

Modify the Lua `CONFIG` data to see changes in the C program output!
```lua
local CONFIG = {
    use_fahrenheit = false,   -- Change to false
    temp_offset = 0.0,        -- Remove the offset
    warning_threshold = 30.0  -- Lower the threshold for Celsius
}
```