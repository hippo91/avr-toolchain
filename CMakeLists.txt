cmake_minimum_required( VERSION 3.10 )
# Project name
project("avr toolchain (for Arduino and others)" VERSION 1.0.0)

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
    message(FATAL_ERROR
    "In source build is prohibited!\
    Please remove manually the following CMake generated files:\
    ${srcdir}/CMakeFiles\
    ${srcdir}/CMakeCache.txt")
endif()

# make cache variables for install destinations
include(GNUInstallDirs)
set(qualified_install_libdir ${CMAKE_INSTALL_LIBDIR}/AvrToolchain)
set(qualified_install_cmakedir ${CMAKE_INSTALL_LIBDIR}/AvrToolchain/cmake)
set(qualified_install_incdir ${CMAKE_INSTALL_INCLUDEDIR}/AvrToolchain)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/avr-toolchain.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/avr-toolchain.cmake @ONLY)

include(CMakePackageConfigHelpers)

# generate the version file for the config file
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/AvrToolchainConfigVersion.cmake"
  VERSION "${version}"
  COMPATIBILITY AnyNewerVersion
)

install(FILES
        "${CMAKE_CURRENT_BINARY_DIR}/avr-toolchain.cmake"
        "${CMAKE_CURRENT_SOURCE_DIR}/AvrToolchainConfig.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/AvrToolchainConfigVersion.cmake"
        DESTINATION ${qualified_install_cmakedir}
)
