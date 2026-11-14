find_package(AvrToolchain REQUIRED)
avr_init()
avr_select_board(ArduinoUno)

# I target a recent cmake, it shouldn't be a problem on a dev machine
cmake_minimum_required( VERSION 3.10 )
# Largely inspired from https://www.kuon.ch/post/2018-07-11-avr-cmake/
# Project name
project("Atmega328p serial debugging" VERSION 1.0.0)

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)



