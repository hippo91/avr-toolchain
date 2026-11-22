set(PLATFORM_TEST_DIR ${CMAKE_BINARY_DIR}/tests/attiny84)
set(PLATFORM_TEST_INSTALL_DIR ${PLATFORM_TEST_DIR}/toolchain_install)
set(PLATFORM_TEST_PROJECT_BUILD_DIR ${PLATFORM_TEST_DIR}/test_project_build)
file(MAKE_DIRECTORY ${PLATFORM_TEST_INSTALL_DIR})
file(MAKE_DIRECTORY ${PLATFORM_TEST_PROJECT_BUILD_DIR})

add_custom_command(
  OUTPUT ${PLATFORM_TEST_INSTALL_DIR}/avr-toolchain.cmake
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  COMMAND ${CMAKE_COMMAND} --install . --prefix ${PLATFORM_TEST_INSTALL_DIR}
  COMMENT "Installing attiny84 test project" 
)

add_custom_target(InstallStepForTest_attiny84 ALL DEPENDS ${PLATFORM_TEST_INSTALL_DIR}/avr-toolchain.cmake)

add_test(
  NAME attiny84ConfigurationTest
  COMMAND ${CMAKE_COMMAND} -DCMAKE_PREFIX_PATH=${PLATFORM_TEST_INSTALL_DIR}/lib/AvrToolchain/cmake -S ${CMAKE_CURRENT_SOURCE_DIR}/TestProject -B ${PLATFORM_TEST_PROJECT_BUILD_DIR}
)

add_test(
  NAME attiny84BuildTest
  COMMAND ${CMAKE_COMMAND} --build .
  WORKING_DIRECTORY ${PLATFORM_TEST_PROJECT_BUILD_DIR}
)

add_test(
  NAME attiny84BinaryTest
  COMMAND bash "-c" "file ${PLATFORM_TEST_PROJECT_BUILD_DIR}/Testattiny84 | grep 'Atmel AVR 8-bit'"
  WORKING_DIRECTORY ${PLATFORM_TEST_PROJECT_BUILD_DIR}
)

configure_file(
  ${CMAKE_CURRENT_LIST_DIR}/test_wrapper.sh.in
  ${PLATFORM_TEST_PROJECT_BUILD_DIR}/test_wrapper.sh
  @ONLY)

add_test(
  NAME attiny84RunTest
  COMMAND bash "${PLATFORM_TEST_PROJECT_BUILD_DIR}/test_wrapper.sh" "--test-exe" "${PLATFORM_TEST_PROJECT_BUILD_DIR}/Testattiny84"
)

set_tests_properties(attiny84RunTest
  PROPERTIES
    PASS_REGULAR_EXPRESSION "SIMAVR: IOPORT @0x38<-0x0\n\nSIMAVR: IOPORT @0x38<-0x8"
)

set_tests_properties(attiny84BuildTest PROPERTIES DEPENDS attiny84ConfigurationTest)
set_tests_properties(attiny84BinaryTest PROPERTIES DEPENDS attiny84BuildTest)
set_tests_properties(attiny84RunTest PROPERTIES DEPENDS attiny84BinaryTest)