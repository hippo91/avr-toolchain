get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/" ABSOLUTE)

set(AvrToolchain_LOCATION ${PACKAGE_PREFIX_DIR}/avr-toolchain.cmake)
set(ArduinoUnoConfig_LOCATION ${PACKAGE_PREFIX_DIR}/ArduinoUnoConfig.cmake)
if(EXISTS ${AvrToolchain_LOCATION})
  set(AvrToolchain_FOUND True)
else()
  message(AvrToolchain not found!)
  set(AvrToolchain_FOUND False)
endif()

