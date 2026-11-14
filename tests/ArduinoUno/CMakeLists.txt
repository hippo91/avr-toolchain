set(TMP_DIR ${CMAKE_BINARY_DIR}/tests/ArduinoUno)
set(TMP_INSTALL_DIR ${CMAKE_BINARY_DIR}/tests/ArduinoUno/install)
file(MAKE_DIRECTORY ${TMP_INSTALL_DIR})

add_custom_command(
  OUTPUT ${TMP_INSTALL_DIR}/avr-toolchain.cmake
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  COMMAND ${CMAKE_COMMAND} --install . --prefix ${TMP_INSTALL_DIR}
  COMMENT "Installing ArduinoUno test project" 
)

add_custom_target(InstallStepForTest ALL DEPENDS ${TMP_INSTALL_DIR}/avr-toolchain.cmake)

add_test(
  NAME ArduinoUno
  COMMAND cmake -G "${CMAKE_GENERATOR}" -DCMAKE_PREFIX_PATH="${TMP_INSTALL_DIR}" ${CMAKE_CURRENT_SOURCE_DIR}/TestProject
  WORKING_DIRECTORY ${TMP_DIR}
)