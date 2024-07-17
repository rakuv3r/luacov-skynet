#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <stdio.h>
#include <unistd.h>

static int file_exists(lua_State *L) {
    const char *filename = luaL_checkstring(L, 1);

    int exists = access(filename, F_OK) != -1;

    lua_pushboolean(L, exists);

    return 1;
}

static const luaL_Reg mylib[] = {
        {"file_exists", file_exists},
        {NULL, NULL}
};

int luaopen_fileutil(lua_State *L) {
    luaL_newlib(L, mylib);
    return 1;
}