#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

// Every C function exposed to Lua must have this signature:
// int function_name(lua_State *L)
static int l_add_numbers(lua_State *L) {
    // 1. Read arguments from the stack (1 is the first arg, 2 is the second)
    double a = luaL_checknumber(L, 1);
    double b = luaL_checknumber(L, 2);
    
    // 2. Perform the C operation
    double sum = a + b;
    
    // 3. Push the result back onto the top of the stack
    lua_pushnumber(L, sum);
    
    // 4. Return the number of return values (Lua supports multiple returns)
    return 1; 
}

// 1. Create an array of all the functions you want to export
static const struct luaL_Reg math_ext_funcs[] = {
    {"add_in_c", l_add_numbers},
    {NULL, NULL} // Sentinel value to tell Lua where the array ends
};

// 2. Modify the entry point to create and return a table
int luaopen_math_ext(lua_State *L) {
    // luaL_newlib creates a new table and registers the functions inside it
    luaL_newlib(L, math_ext_funcs);
    return 1; // Tell Lua we are returning 1 thing (the table)
}

// Register the function GLOBAL
// int luaopen_math_ext(lua_State *L) {
//     lua_register(L, "add_in_c", l_add_numbers);
//     return 0;
// }