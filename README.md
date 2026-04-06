# AVR Toolchain

This project provides a fully CMake-compatible toolchain for building AVR microcontroller projects, including support for Arduino boards like the Arduino Uno. After installation, users can seamlessly integrate it into their CMake projects using the standard `find_package` command, ensuring compatibility with modern CMake workflows.

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/hippo91/avr-toolchain.git
   cd avr-toolchain
   ```

2. Install:
   ```
   mkdir build
   cd build
   cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_SYSROOT=/path/to/avr/gcc ..
   make install
   ```

   **Note:** There are no file to compile in this project, that's why the build step is useless
   **Note:** You must specify `CMAKE_INSTALL_PREFIX` to set the installation directory. This prefix will also be used as `CMAKE_STAGING_PREFIX` for all downstream AVR projects using this toolchain. Optionally, set `CMAKE_SYSROOT` to the path where AVR GCC is installed. If not set, this project will try to locate AVR GCC in standard places.

## Usage

This toolchain is designed to be fully compatible with CMake's package discovery mechanism. After installation, you can use the `find_package` command in your CMakeLists.txt to locate and use the AVR toolchain.

### Using find_package

```cmake
cmake_minimum_required(VERSION 3.10)

find_package(AvrToolchain REQUIRED)
avr_init()
avr_select_board(ArduinoUno)

project(MyAvrProject)

add_executable(myapp main.c)
```

## Files Description

- `ArduinoUnoConfig.cmake`: Configuration for Arduino Uno board.
- `avr-toolchain.cmake.in`: Template for the toolchain file.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
