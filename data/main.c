#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

// A helper function to pass data to Lua and read the results
void process_data_through_lua(lua_State *L, double temp, double humidity) {
    // 1. Put the Lua function on the stack
    lua_getglobal(L, "format_sensor_data");

    // 2. Push the raw C data as arguments
    lua_pushnumber(L, temp);     // first argument
    lua_pushnumber(L, humidity); // second argument

    // 3. Call Lua: 2 arguments in, expecting 2 return values back.
    if (lua_pcall(L, 2, 2, 0) != LUA_OK) {
        fprintf(stderr, "Lua Error: %s\n", lua_tostring(L, -1));
        lua_pop(L, 1); // Remove the error message from the stack
        return;
    }

    // 4. Read the return values. 
    // Since Lua pushes them in order, the string is at -2, and the boolean is at -1 (top).
    const char* formatted_string = lua_tostring(L, -2);
    int is_critical = lua_toboolean(L, -1);

    // 5. Let C handle the final I/O based on Lua's logic
    if (is_critical) {
        printf("!!! ALARM !!! %s\n", formatted_string);
    } else {
        printf("LOG: %s\n", formatted_string);
    }

    // 6. Clean up the stack by popping the 2 return values
    lua_pop(L, 2);
}

int main(void) {
    // Initialize Lua
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    // Load the script
    if (luaL_dofile(L, "processor.lua") != LUA_OK) {
        fprintf(stderr, "Failed to load script: %s\n", lua_tostring(L, -1));
        lua_close(L);
        return 1;
    }

    printf("--- Starting C Program ---\n");

    // Simulate pushing raw data (e.g., from hardware sensors)
    process_data_through_lua(L, 22.0, 45.0); // Normal
    process_data_through_lua(L, 28.5, 50.0); // Normal
    process_data_through_lua(L, 35.0, 65.0); // Very hot

    // Close Lua
    lua_close(L);
    return 0;
}