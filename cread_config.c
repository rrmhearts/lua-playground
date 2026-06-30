#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

int main(void) {
    // 1. Spin up the Lua interpreter
    lua_State *L = luaL_newstate();
    
    // 2. Load standard Lua libraries (math, string, etc.)
    luaL_openlibs(L); 

    // 3. Load and execute the config file
    // luaL_dofile returns LUA_OK (0) on success.
    if (luaL_dofile(L, "configc.lua") != LUA_OK) {
        // If it fails, the error message is pushed to the top of the stack (-1)
        fprintf(stderr, "Error loading script: %s\n", lua_tostring(L, -1));
        lua_close(L);
        return 1;
    }

    // --- READING A VARIABLE ---
    
    // Tell Lua to push the global variable "window_title" onto the stack
    lua_getglobal(L, "window_title"); 
    
    if (lua_isstring(L, -1)) {
        printf("Config loaded for: %s\n", lua_tostring(L, -1));
    }
    
    // Pop the variable off the stack to keep things clean (pop 1 item)
    lua_pop(L, 1); 


    // --- CALLING A FUNCTION ---
    
    // 1. Push the function onto the stack
    lua_getglobal(L, "calculate_window_size");
    
    // 2. Push the argument(s) onto the stack (e.g., 16:9 aspect ratio)
    lua_pushnumber(L, 16.0 / 9.0);
    
    // 3. Call the function using lua_pcall(Lua_State, Num_Args, Num_Returns, Error_Handler)
    // We are passing 1 argument and expecting 2 return values.
    if (lua_pcall(L, 1, 2, 0) != LUA_OK) {
        fprintf(stderr, "Error calling function: %s\n", lua_tostring(L, -1));
    } else {
        // The function executed successfully! 
        // The 2 return values are now sitting on the stack.
        // -2 is the first return value (width)
        // -1 is the second return value (height)
        
        double width = lua_tonumber(L, -2);
        double height = lua_tonumber(L, -1);
        
        printf("Calculated Size: %.0fx%.0f\n", width, height);
        
        // Clean up the stack by popping the 2 return values
        lua_pop(L, 2); 
    }

    // 4. Shut down the interpreter and free memory
    lua_close(L);
    return 0;
}
// gcc cread_config.c -o configapp -I/usr/include/lua5.4 -llua5.4 -lm