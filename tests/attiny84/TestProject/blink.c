#include <assert.h>
#include <avr/io.h>
#include <stdio.h>
#include <util/delay.h>

#ifndef BLINK_FREQ
#define BLINK_FREQ 20
#endif
static_assert(BLINK_FREQ > 0, "Please select a strictly positive integer frequency");

#ifndef LED_PIN
#define LED_PIN PB3
#endif

typedef struct {
  const uint8_t register_bitmask[5];
  const uint32_t value[5];
  enum prescaler_e {NO, EIGHT, SIXFOUR, TWOFIVESIX, ONEZEROTWOFOUR} prescale;
} prescaler_t;

uint8_t get_prescaler_register_bitmask(const prescaler_t const* prescaler) {
  return prescaler->register_bitmask[prescaler->prescale];
}

uint32_t get_prescaler_value(const prescaler_t const* prescaler) {
  return prescaler->value[prescaler->prescale];
}

prescaler_t TCCR1B_PRESCALER = {
  .register_bitmask = {
    (0<<CS12|0<<CS11|1<<CS10),
    (0<<CS12|1<<CS11|0<<CS10),
    (0<<CS12|1<<CS11|1<<CS10),
    (1<<CS12|0<<CS11|0<<CS10),
    (1<<CS12|0<<CS11|1<<CS10)}, 
  .value = {1UL, 8UL, 64UL, 256UL, 1024UL},
  .prescale = NO
};

int main(void)
{
  // Next 2 lines configure the TCCR1 to normal mode
  TCCR1A |= (0<<WGM11|0<<WGM10);
  TCCR1B |= (0<<WGM13|0<<WGM12);
  // Set the prescaler to 256
  TCCR1B_PRESCALER.prescale = TWOFIVESIX;
  TCCR1B |= get_prescaler_register_bitmask(&TCCR1B_PRESCALER);

  // Setup: set the LED_PIN as an output pin
  DDRB |= (1<<LED_PIN);

  // Compute the period in milliseconds
  int period_ms = (int) 1000. / BLINK_FREQ;
  int half_period_ms = period_ms / 2;

  uint16_t start, duration;

  while(1)
  {
    // Set the PIN in HIGH state
    PORTB |= (1<<LED_PIN);
    // Wait for half period
    _delay_ms(half_period_ms);
    // Set the PIN in LOW state
    PORTB &= ~(1<<LED_PIN);
    // Wait for half period
    _delay_ms(half_period_ms);
  }

  return 0;
}

