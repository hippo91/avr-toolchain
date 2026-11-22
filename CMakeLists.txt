cmake_minimum_required(VERSION 3.13)

file(STRINGS Version.txt AVR_TOOLCHAIN_VERSION)

# Search for sysroot in the environment, then use standard CMake discovery
# before falling back to common install prefixes. This is more robust than
# hard-coding only /usr, /usr/local, and /opt/avr.
if(NOT CMAKE_SYSROOT)
  set(_avr_toolchain_hints)
  if(DEFINED ENV{AVR_TOOLCHAIN_PATH})
    list(APPEND _avr_toolchain_hints "$ENV{AVR_TOOLCHAIN_PATH}")
  endif()
  if(DEFINED ENV{AVR_SYSROOT})
    list(APPEND _avr_toolchain_hints "$ENV{AVR_SYSROOT}")
  endif()
  if(CMAKE_PREFIX_PATH)
    list(APPEND _avr_toolchain_hints ${CMAKE_PREFIX_PATH})
  endif()
  list(APPEND _avr_toolchain_hints "/usr" "/usr/local" "/opt/avr")

  find_program(AVR_GCC_EXECUTABLE
    NAMES avr-gcc
    HINTS ${_avr_toolchain_hints}
    PATH_SUFFIXES bin
    NO_CACHE
  )

  if(AVR_GCC_EXECUTABLE)
    get_filename_component(_avr_gcc_bin_dir "${AVR_GCC_EXECUTABLE}" DIRECTORY)
    get_filename_component(AVR_TOOLCHAIN_PREFIX "${_avr_gcc_bin_dir}" DIRECTORY)

    if(EXISTS "${AVR_TOOLCHAIN_PREFIX}/bin/avr-gcc")
      set(CMAKE_SYSROOT "${AVR_TOOLCHAIN_PREFIX}")
      message(STATUS "AVR toolchain found at: ${CMAKE_SYSROOT}")
    endif()
  endif()
endif()

if(NOT CMAKE_SYSROOT)
  message(
    FATAL_ERROR
      "AVR toolchain not found. Please set CMAKE_SYSROOT manually or set the AVR_TOOLCHAIN_PATH or AVR_SYSROOT environment variable."
  )
endif()

if(NOT EXISTS "${CMAKE_SYSROOT}/bin/avr-gcc")
  message(
    FATAL_ERROR
      "CMAKE_SYSROOT does not contain an AVR GCC installation: ${CMAKE_SYSROOT}"
  )
endif()

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/avr-toolchain.cmake.in
               ${CMAKE_CURRENT_BINARY_DIR}/avr-toolchain.cmake @ONLY)
# Set the toolchain file BEFORE project() call.
# This is necessary and intentional, not a bug:
# - Forces CMake to load and test the AVR compilers during configuration
# - Ensures proper compiler detection for architecture validation
# - Validates that pointer size is 2 bytes
# - Generates correct architecture specifications for downstream projects
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_BINARY_DIR}/avr-toolchain.cmake")
project("avr toolchain (for Arduino and others)" VERSION "${AVR_TOOLCHAIN_VERSION}")

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
  message(
    FATAL_ERROR
      "In source build is prohibited!\
    Please remove manually the following CMake generated files:\
    ${CMAKE_SOURCE_DIR}/CMakeFiles\
    ${CMAKE_SOURCE_DIR}/CMakeCache.txt")
endif()

# Ensure the toolchain is correctly set up by checking that the size of pointer
# is 2 bytes
message(CHECK_START "Check for AVR pointer size")
if(NOT CMAKE_SIZEOF_VOID_P EQUAL 2)
  set(ERR_MSG "AVR requires 2 bytes pointers. Actual size: ${CMAKE_SIZEOF_VOID_P} bytes")
  message(CHECK_FAIL ${ERR_MSG})
  message(FATAL_ERROR ${ERR_MSG})
endif()
message(CHECK_PASS "AVR pointer size is 2 bytes")

# For now using GNUInstallDir generate a false positive warning about the CMAKE_INSTALL_LIBDIR variable not being set.
# See https://gitlab.kitware.com/cmake/cmake/-/issues/23461 for more details.
include(GNUInstallDirs)
set(qualified_install_libdir ${CMAKE_INSTALL_LIBDIR}/AvrToolchain)
set(qualified_install_cmakedir ${CMAKE_INSTALL_LIBDIR}/AvrToolchain/cmake)
set(qualified_install_incdir ${CMAKE_INSTALL_INCLUDEDIR}/AvrToolchain)

include(CMakePackageConfigHelpers)

# generate the version file for the config file
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/AvrToolchainConfigVersion.cmake"
  VERSION "${PROJECT_VERSION}"
  COMPATIBILITY AnyNewerVersion)

install(
  FILES "${CMAKE_CURRENT_BINARY_DIR}/avr-toolchain.cmake"
        "${CMAKE_CURRENT_SOURCE_DIR}/AvrToolchainConfig.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/AvrToolchainConfigVersion.cmake"
        "${CMAKE_CURRENT_SOURCE_DIR}/ArduinoUnoConfig.cmake"
        "${CMAKE_CURRENT_SOURCE_DIR}/attiny84Config.cmake"
  DESTINATION ${qualified_install_cmakedir})


enable_testing()
add_subdirectory(tests)