

#include <Arduino.h>

void setup() {
  Serial.begin(9600);
    //analogWrite(3, 128);
   
    // Our PWM is on pin 3, which is on Timer 2 output B.

     pinMode(3, OUTPUT);
  TCCR2A = _BV(COM2A1) | _BV(COM2B1) | _BV(WGM21) | _BV(WGM20);
  TCCR2B = _BV(CS22) | _BV(CS21) | _BV(CS20);
   OCR2B = 50;
   pinMode(4, OUTPUT);
   pinMode(8, OUTPUT);
   digitalWrite(4, HIGH);
   digitalWrite(8, LOW);
   

/*  
    int timer2_offset = 0x6C; // Timer 2.
    uint8_t wgm = 5;
 #define TCCRA_8(tmr_offset)     _SFR_MEM8(0x44 + tmr_offset)
 #define TCCRB_8(tmr_offset)     _SFR_MEM8(0x45 + tmr_offset)
#define OCRA_8(tmr_offset)      _SFR_MEM8(0x47 + tmr_offset)
    TCCRA_8(timerOffset) = (TCCRA_8(timerOffset) & B11111100) | (wgm & 3);
    TCCRB_8(timerOffset) = (TCCRB_8(timerOffset) & B11110111) | ((wgm & 12) << 1);
    SetFrequency_8(timerOffset, 500);
    }*/
  }

void loop() {
   int potValue = analogRead(A0) / 4;
   Serial.println(potValue);
   OCR2B = potValue;
}

