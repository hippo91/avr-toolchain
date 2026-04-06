cmake_minimum_required( VERSION 3.10 )

# Search for sysroot in the environment otherwise try
# to locate avr-gcc to determine sysroot
if(NOT CMAKE_SYSROOT)
  if(DEFINED ENV{AVR_TOOLCHAIN_PATH})
    set(CMAKE_SYSROOT "$ENV{AVR_TOOLCHAIN_PATH}")
    message(STATUS "AVR toolchain path from AVR_TOOLCHAIN_PATH environment variable: ${CMAKE_SYSROOT}")
  elseif(DEFINED ENV{AVR_SYSROOT})
    set(CMAKE_SYSROOT "$ENV{AVR_SYSROOT}")
    message(STATUS "AVR toolchain path from AVR_SYSROOT environment variable: ${CMAKE_SYSROOT}")
  else()
    # Fall back to common installation paths
    foreach(path IN ITEMS "/usr" "/usr/local" "/opt/avr")
      if(EXISTS "${path}/bin/avr-gcc")
        set(CMAKE_SYSROOT ${path})
        message(STATUS "AVR toolchain found at: ${CMAKE_SYSROOT}")
        break()
      endif()
    endforeach()
  endif()
  
  if(NOT CMAKE_SYSROOT)
    message(FATAL_ERROR 
      "AVR toolchain not found. Please set CMAKE_SYSROOT manually or set the AVR_TOOLCHAIN_PATH or AVR_SYSROOT environment variable.")
  endif()
endif()

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/avr-toolchain.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/avr-toolchain.cmake @ONLY)
# Set the toolchain file BEFORE project() call
# This is necessary and intentional, not a bug:
# - Forces CMake to load and test the AVR compilers during configuration
# - Ensures proper compiler detection for architecture validation
# - Validates that CMAKE_SIZEOF_VOID_P=2 (16-bit pointers for AVR)
# - Generates correct architecture specifications for downstream projects
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_BINARY_DIR}/avr-toolchain.cmake")
project("avr toolchain (for Arduino and others)" VERSION 1.0.0)

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
    message(FATAL_ERROR
    "In source build is prohibited!\
    Please remove manually the following CMake generated files:\
    ${CMAKE_SOURCE_DIR}/CMakeFiles\
    ${CMAKE_SOURCE_DIR}/CMakeCache.txt")
endif()

# Ensure the toolchain is correctly set up
# by checking that the size of pointer is 16-bit
if(NOT CMAKE_SIZEOF_VOID_P EQUAL 2)
    message(FATAL_ERROR "AVR requires 16-bit pointers")
endif()

# make cache variables for install destinations
include(GNUInstallDirs)
set(qualified_install_libdir ${CMAKE_INSTALL_LIBDIR}/AvrToolchain)
set(qualified_install_cmakedir ${CMAKE_INSTALL_LIBDIR}/AvrToolchain/cmake)
set(qualified_install_incdir ${CMAKE_INSTALL_INCLUDEDIR}/AvrToolchain)

include(CMakePackageConfigHelpers)

# generate the version file for the config file
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/AvrToolchainConfigVersion.cmake"
  VERSION "${PROJECT_VERSION}"
  COMPATIBILITY AnyNewerVersion
)

install(FILES
        "${CMAKE_CURRENT_BINARY_DIR}/avr-toolchain.cmake"
        "${CMAKE_CURRENT_SOURCE_DIR}/AvrToolchainConfig.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/AvrToolchainConfigVersion.cmake"
        "${CMAKE_CURRENT_SOURCE_DIR}/ArduinoUnoConfig.cmake"
        DESTINATION ${qualified_install_cmakedir}
)
