// Copyright 2015 Lawrence Kesteloot

#include <Arduino.h>
#include "Shoulder.h"

Shoulder::Shoulder(int dir1Pin, int dir2Pin) {
  mDir1Pin = dir1Pin;
  mDir2Pin = dir2Pin;

  pinMode(mDir1Pin, OUTPUT);
  pinMode(mDir2Pin, OUTPUT);
  pinMode(PWM_PIN, OUTPUT);
  TCCR2A = _BV(COM2A1) | _BV(COM2B1) | _BV(WGM21) | _BV(WGM20);
  TCCR2B = _BV(CS22) | _BV(CS21) | _BV(CS20); // 60 Hz
}

void Shoulder::move(int delta) {
  if (delta == 0) {
    // Break.
    digitalWrite(mDir1Pin, HIGH);
    digitalWrite(mDir2Pin, HIGH);
    OCR2B = 255;
  } 
  else if (delta < 0) {
    if (delta < -255) {
      delta = -255;
    }
    digitalWrite(mDir1Pin, HIGH);
    digitalWrite(mDir2Pin, LOW);
    OCR2B = -delta;
  } 
  else {
    if (delta > 255) {
      delta = 255;
    }
    digitalWrite(mDir1Pin, LOW);
    digitalWrite(mDir2Pin, HIGH);
    OCR2B = delta;
  }
}


