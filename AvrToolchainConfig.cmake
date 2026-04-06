# ##############################################################################
# AvrToolchain cmake module eases the way to correctly set up compiler and
# settings necessary to use avr based boards such as Arduino Uno
#
# Standard way to use this module is described by the 3 following lines:
#
# find_package(AvrToolchain REQUIRED)
# avr_init()
# avr_select_board(ArduinoUno)
# ##############################################################################
get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/" ABSOLUTE)
set(AVR_TOOLCHAIN_PACKAGE_PREFIX_DIR
    ${PACKAGE_PREFIX_DIR}
    CACHE PATH "Path to AvrToolchain cmake directory")
set(AVR_TOOLCHAIN_PATH
    ${AVR_TOOLCHAIN_PACKAGE_PREFIX_DIR}/avr-toolchain.cmake
    CACHE PATH "Path to AvrToolchain file")

# ##############################################################################
# avr_select_board function sets up the processor, the crystal board frequency
# and other specific board settings by including board specifications file
#
# param board_name : name of the board
# ##############################################################################
function(avr_select_board board_name)
  if(${board_name} STREQUAL "ArduinoUno")
    message(STATUS "Selected board : ArduinoUno")
    include(${AVR_TOOLCHAIN_PACKAGE_PREFIX_DIR}/ArduinoUnoConfig.cmake)
  else()
    message(FATAL_ERROR "Unknown board!")
  endif()
endfunction()

# ##############################################################################
# avr_init function declares to the calling script where avr toolchain to be
# used is located
# ##############################################################################
function(avr_init)
  message(STATUS "Toolchain set to ${AVR_TOOLCHAIN_PATH}")
  set(CMAKE_TOOLCHAIN_FILE
      ${AVR_TOOLCHAIN_PATH}
      PARENT_SCOPE)
endfunction()

if(EXISTS ${AVR_TOOLCHAIN_PATH})
  message(STATUS "AvrToolchain found!")
  set(AvrToolchain_FOUND True)
else()
  message(STATUS AvrToolchain not found!)
  set(AvrToolchain_FOUND False)
endif()
