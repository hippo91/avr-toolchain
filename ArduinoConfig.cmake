# AVR Chip Configuration Set frequency of the crystal on your board,
set(F_CPU
    16000000UL
    CACHE STRING "Crystal board frequency")

# Default Baudrate for UART, read avr include/util/setbaud.h for usage
set(BAUD
    9600
    CACHE STRING "Baudrate for UART")
set_property(
  CACHE BAUD
  PROPERTY STRINGS
           2400
           4800
           9600
           14400
           19200
           28800
           38400
           57600
           76800
           115200)

# CPU, you can find the list here:
# https://gcc.gnu.org/onlinedocs/gcc/AVR-Options.html
set(MCU
    atmega328p
    CACHE STRING "Processor")

set(PROC
    __AVR_ATmega328P__
    CACHE STRING "Processeur defines")

set(PROC_ID
  __AVR_ATmega328P__
  CACHE STRING "MCU include guard")

# The programmer to use, read avrdude manual for list
set(PROG_TYPE
    arduino
    CACHE STRING "Programmer to use")
