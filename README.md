# AVR Toolchain Documentation

## Installation Instructions
To install the AVR Toolchain, follow these steps:

1. **Download** the latest release from the [Releases page](https://github.com/hippo91/avr-toolchain/releases).
2. **Extract** the downloaded archive to your preferred location.
3. **Add** the `bin` directory to your system's `PATH` environment variable.

## Usage

### Initializing the Library
To initialize the library, call the `avr_init()` function:
```c
avr_init();
```

### Selecting a Board
To select the Arduino Uno board, you can use the following function:
```c
avr_select_board(ArduinoUno);
```

## Example Code
Here's a simple example demonstrating the use of the library:
```c
#include <avr_toolchain.h>

int main() {
    avr_init();
    avr_select_board(ArduinoUno);
    // Your code here
    return 0;
}
```

## MIT License
This project is licensed under the MIT License. See the LICENSE file for details.