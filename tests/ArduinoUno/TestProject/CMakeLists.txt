find_package(AvrToolchain REQUIRED)
avr_init()
avr_select_board(ArduinoUno)

# I target a recent cmake, it shouldn't be a problem on a dev machine
cmake_minimum_required( VERSION 3.10 )
# Largely inspired from https://www.kuon.ch/post/2018-07-11-avr-cmake/
# Project name
project("Atmega328p blink test" VERSION 1.0.0)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/../../test_wrapper.sh.in
               ${CMAKE_CURRENT_BINARY_DIR}/test_wrapper.sh @ONLY)

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(exe_name "TestArduinoUno")
add_executable(${exe_name})
target_sources(${exe_name} PRIVATE blink.c)


