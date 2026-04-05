# AVR Toolchain

This project provides a fully CMake-compatible toolchain for building AVR microcontroller projects, including support for Arduino boards like the Arduino Uno. After installation, users can seamlessly integrate it into their CMake projects using the standard `find_package` command, ensuring compatibility with modern CMake workflows.

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/hippo91/avr-toolchain.git
   cd avr-toolchain
   ```

2. Build and install:
   ```
   mkdir build
   cd build
   cmake ..
   make
   make install
   ```

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