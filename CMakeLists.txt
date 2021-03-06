cmake_minimum_required(VERSION 2.8)
cmake_policy(VERSION 2.8)

project(check-aliases C)

if(NOT CMAKE_BUILD_TYPE)
	message("Warning: CMAKE_BUILD_TYPE is not set.\nYou are advised to set it to one of Debug, Release, RelWithDebInfo or MinSizeRel.\nSee https://cmake.org/cmake/help/latest/variable/CMAKE_BUILD_TYPE.html")
endif(NOT CMAKE_BUILD_TYPE)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -Wall -Wextra")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -Werror")

# FIXME: Workaround for CI:
# src/aliases_lexer.c:1125:44: error: comparison of integers of different signs:
#       'int' and 'yy_size_t' (aka 'unsigned long') [-Werror,-Wsign-compare]
#   ...(int) ((yy_n_chars) + number_to_move) > YY_CURRENT_BUFFER_LVALUE->yy_buf_size) {
#      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 1 error generated.
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -Wno-error=sign-compare")

if("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
	add_definitions("-D_GNU_SOURCE")
endif("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")

file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin ${CMAKE_CURRENT_BINARY_DIR}/src)

add_executable(bin/check-aliases src/main.c ${CMAKE_CURRENT_BINARY_DIR}/src/aliases_lexer.c ${CMAKE_CURRENT_BINARY_DIR}/src/aliases_parser.c)

add_custom_command(COMMAND lex ARGS -osrc/aliases_lexer.c ${CMAKE_CURRENT_SOURCE_DIR}/src/aliases_lexer.l DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/aliases_lexer.l OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/src/aliases_lexer.c ${CMAKE_CURRENT_BINARY_DIR}/src/aliases_parser.h)
add_custom_command(COMMAND yacc ARGS -d -v -o src/aliases_parser.c ${CMAKE_CURRENT_SOURCE_DIR}/src/aliases_parser.y DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/aliases_parser.y ${CMAKE_CURRENT_BINARY_DIR}/src/aliases_parser.h OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/src/aliases_parser.c)

add_custom_target(style DEPENDS style_fix_space style_astyle)
add_custom_target(style_fix_space COMMAND find src -name '*.[ch]' -exec perl -pi -e 's/[ \\t]+$$//' '{}' '\\;' COMMENT "Fixing invalid space sequences")
add_custom_target(style_astyle COMMAND find src -name '*.[ch]' -exec astyle --style=linux --indent=force-tab-x --lineend=linux {} '\\;' COMMENT "Checking source code style" DEPENDS style_fix_space)

