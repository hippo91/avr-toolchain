set(PLATFORM_TEST_DIR ${CMAKE_BINARY_DIR}/tests/ArduinoUno)
set(PLATFORM_TEST_INSTALL_DIR ${PLATFORM_TEST_DIR}/toolchain_install)
set(PLATFORM_TEST_PROJECT_BUILD_DIR ${PLATFORM_TEST_DIR}/test_project_build)
file(MAKE_DIRECTORY ${PLATFORM_TEST_INSTALL_DIR})
file(MAKE_DIRECTORY ${PLATFORM_TEST_PROJECT_BUILD_DIR})

add_custom_command(
  OUTPUT ${PLATFORM_TEST_INSTALL_DIR}/avr-toolchain.cmake
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  COMMAND ${CMAKE_COMMAND} --install . --prefix ${PLATFORM_TEST_INSTALL_DIR}
  COMMENT "Installing ArduinoUno test project" 
)

add_custom_target(InstallStepForTest ALL DEPENDS ${PLATFORM_TEST_INSTALL_DIR}/avr-toolchain.cmake)

add_test(
  NAME ArduinoUnoConfigurationTest
  COMMAND ${CMAKE_COMMAND} -DCMAKE_PREFIX_PATH=${PLATFORM_TEST_INSTALL_DIR}/lib/AvrToolchain/cmake -S ${CMAKE_CURRENT_SOURCE_DIR}/TestProject -B ${PLATFORM_TEST_PROJECT_BUILD_DIR}
)

add_test(
  NAME ArduinoUnoBuildTest
  COMMAND ${CMAKE_COMMAND} --build .
  WORKING_DIRECTORY ${PLATFORM_TEST_PROJECT_BUILD_DIR}
)

add_test(
  NAME ArduinoUnoBinaryTest
  COMMAND bash "-c" "file ${PLATFORM_TEST_PROJECT_BUILD_DIR}/TestArduinoUno | grep 'Atmel AVR 8-bit'"
  WORKING_DIRECTORY ${PLATFORM_TEST_PROJECT_BUILD_DIR}
)

set_tests_properties(ArduinoUnoBuildTest PROPERTIES DEPENDS ArduinoUnoConfigurationTest)
set_tests_properties(ArduinoUnoBinaryTest PROPERTIES DEPENDS ArduinoUnoBuildTest)