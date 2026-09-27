# AVR Toolchain

This project provides a CMake toolchain for cross-compiling AVR microcontroller projects. It currently includes a board profile for the Arduino Uno.

## Requirements

- CMake 3.13 or newer.
- AVR GCC, including `avr-gcc` and `avr-g++`.

The AVR GCC installation prefix is the directory containing `bin/avr-gcc` (for example, `/usr`).

## Installation

Clone the repository and configure it with an installation prefix and the AVR GCC installation prefix:

```sh
git clone https://github.com/hippo91/avr-toolchain.git
cd avr-toolchain
cmake -S . -B build \
   -DCMAKE_INSTALL_PREFIX=/usr/local \
   -DCMAKE_SYSROOT=/path/to/avr/gcc
cmake --install build
```

This repository does not build a library or executable, so `cmake --build` is not needed. Configuration generates the toolchain file, and installation places it and the CMake package files under `${CMAKE_INSTALL_LIBDIR}/AvrToolchain/cmake` (typically `/usr/local/lib/AvrToolchain/cmake`). The configured install prefix is also used as `CMAKE_STAGING_PREFIX` by AVR projects using this toolchain.

If `CMAKE_SYSROOT` is omitted, configuration checks the `AVR_TOOLCHAIN_PATH` and `AVR_SYSROOT` environment variables, then looks for `avr-gcc` under `/usr`, `/usr/local`, and `/opt/avr`. For example, set one of these variables to the AVR GCC installation prefix before configuring:

```sh
export AVR_SYSROOT=/path/to/avr/gcc
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/usr/local
```

## Usage

The package is installed in a project-specific CMake directory. Pass that directory as `AvrToolchain_DIR` when configuring a downstream project. The path below assumes the default `lib` install directory; adjust it if `CMAKE_INSTALL_LIBDIR` was customized.

For an Arduino Uno project, use this ordering in `CMakeLists.txt`: initialize the toolchain and select the board before calling `project()`.

```cmake
cmake_minimum_required(VERSION 3.13)

find_package(AvrToolchain REQUIRED)
avr_init()
avr_select_board(ArduinoUno)

project(MyAvrProject LANGUAGES C CXX)

add_executable(myapp main.c)
```

Configure and build it with:

```sh
cmake -S /path/to/MyAvrProject -B /path/to/MyAvrProject/build \
   -DAvrToolchain_DIR=/usr/local/lib/AvrToolchain/cmake
cmake --build /path/to/MyAvrProject/build
```

The Arduino Uno profile defaults to `MCU=atmega328p`, `F_CPU=16000000UL`, `BAUD=9600`, and the corresponding AVR processor macros. Override the cache variables at configure time when needed, for example:

```sh
cmake -S /path/to/MyAvrProject -B /path/to/MyAvrProject/build \
   -DAvrToolchain_DIR=/usr/local/lib/AvrToolchain/cmake \
   -DF_CPU=8000000UL \
   -DBAUD=115200
```

If changing `MCU`, also ensure the processor macros (`PROC` and `PROC_ID`) match the selected device. Only `ArduinoUno` is currently supported; `avr_select_board()` reports an error for other board names.

## Troubleshooting

- **AVR toolchain not found:** Set `CMAKE_SYSROOT` to the AVR GCC installation prefix, or set `AVR_TOOLCHAIN_PATH` or `AVR_SYSROOT` in the environment. The prefix should contain `bin/avr-gcc`.
- **`find_package` cannot find `AvrToolchain`:** Set `AvrToolchain_DIR` to the installed `AvrToolchain/cmake` directory, such as `/usr/local/lib/AvrToolchain/cmake`.
- **Pointer-size check fails:** This toolchain requires an AVR compiler that reports 2-byte pointers. Check that `CMAKE_SYSROOT` points to the intended AVR GCC installation and that its compiler can compile and link test programs.

## Files

- `ArduinoUnoConfig.cmake`: Configuration for Arduino Uno board.
- `avr-toolchain.cmake.in`: Template for the toolchain file.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
