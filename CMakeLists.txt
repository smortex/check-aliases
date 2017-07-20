cmake_minimum_required(VERSION 2.8)
cmake_policy(VERSION 2.8)

project(check-aliases C)

if(NOT CMAKE_BUILD_TYPE)
	message("Warning: CMAKE_BUILD_TYPE is not set.\nYou are advised to set it to one of Debug, Release, RelWithDebInfo or MinSizeRel.\nSee https://cmake.org/cmake/help/latest/variable/CMAKE_BUILD_TYPE.html")
endif(NOT CMAKE_BUILD_TYPE)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -Wall -Wextra")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -Werror")

if("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
	add_definitions("-D_GNU_SOURCE")
endif("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")

add_executable(check-aliases main.c)

add_custom_target(style DEPENDS style_fix_space style_astyle)
add_custom_target(style_fix_space COMMAND find . -name '*.[ch]' -exec perl -pi -e 's/[ \\t]+$$//' '{}' '\\;' COMMENT "Fixing invalid space sequences")
add_custom_target(style_astyle COMMAND find . -name '*.[ch]' -exec astyle --style=linux --indent=force-tab-x --lineend=linux {} '\\;' COMMENT "Checking source code style" DEPENDS style_fix_space)

