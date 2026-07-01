# Lua Playground

This is a place to learn Lua. I would call it a Luau, but unforntunately that is another language based on Lua 5.1 developed by Roblox!

* See [extra/](./extra/) for some more basic examples
* See [config/](./config/) for C calling a Lua config
* See [data/](./data/) for a full example of C calling Lua Scripts/config that affect the C output.

There are no dragons here unless you don't know C or Lua.

## Install

```sh
sudo apt install lua5.4 luarocks
sudo apt install build-essential liblua5.4-dev lua5.4 # for C libs
```

## Build

Do not forget to build the C programs as needed. In order to run [main.lua](./main.lua), compile `gcc -shared -fPIC -O2 math_ext.c -o math_ext.so -I/usr/include/lua5.4` depending on your version of Lua. Similarly with `data/` and `config/`