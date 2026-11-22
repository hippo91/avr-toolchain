# ##############################################################################
# attiny84 based Board Configuration
# ##############################################################################

# ^^^^^^^^^^^^^^^^^^^^^
# Variables definitions
# ^^^^^^^^^^^^^^^^^^^^^

# Set frequency of the crystal
set(F_CPU
    20000000UL
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
    attiny84
    CACHE STRING "Processor")

set(PROC_ID
    __AVR_ATtiny84__
    CACHE STRING "MCU include guard")

# The programmer to use, read avrdude manual for list
set(PROG_TYPE
    arduino
    CACHE STRING "Programmer to use")

# ^^^^^^^^^^^^^^^^^^^^^^^^^
# Compiler and linker setup
# ^^^^^^^^^^^^^^^^^^^^^^^^^
add_compile_definitions(-DF_CPU=${F_CPU} -DBAUD=${BAUD} -DMCU="${MCU}" -D${PROC_ID})
# mmcu MUST be passed to both the compiler and linker, this handle the linker
add_compile_options(-mmcu=${MCU})
add_link_options(-mmcu=${MCU})
