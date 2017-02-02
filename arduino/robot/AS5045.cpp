// Copyright 2015 Lawrence Kesteloot

#include "Arduino.h"
#include "AS5045.h"

// 0x111111111111000000: mask to obtain first 12 digits with position info.
static const long ANGLE_MASK = 262080;

// 0x000000000000111111; mask to obtain last 6 digits containing status info.
static const long STATUS_MASK = 63;

AS5045::AS5045(int csPin, int clockPin, int dataPin) {
    mCsPin = csPin;
    mClockPin = clockPin;
    mDataPin = dataPin;

    pinMode(mClockPin, OUTPUT);
    pinMode(mCsPin, OUTPUT);
    pinMode(mDataPin, INPUT);
}

AS5045Data AS5045::getData() {
    AS5045Data data;

    // CS needs to cycle from high to low to initiate transfer. Then clock
    // cycles. As it goes high again, data will appear on data.
    digitalWrite(mCsPin, HIGH); // CSn high
    digitalWrite(mClockPin, HIGH); // CLK high
    delayMicroseconds(100); // wait for 1 second for no particular reason
    digitalWrite(mCsPin, LOW); // CSn low: start of transfer
    delayMicroseconds(100); // delay for chip -- 1000x as long as it needs to be
    digitalWrite(mClockPin, LOW); // CLK goes low: start clocking
    delayMicroseconds(100); // hold low for 10 ms

    long packeddata = 0; // two bytes concatenated from inputstream
    for (int x=0; x < 18; x++) // clock signal, 18 transitions, output to clock pin
    { 
        digitalWrite(mClockPin, HIGH); // clock goes high
        delayMicroseconds(100); // wait 10ms
        int inputstream = digitalRead(mDataPin); // read one bit of data from pin
        packeddata = ((packeddata << 1) + inputstream); // left-shift summing variable, add pin value
        digitalWrite(mClockPin, LOW);
        delayMicroseconds(100); // end of one clock cycle
    } // end of entire clock cycle

    // Angle.
    long angle = packeddata & ANGLE_MASK; // mask rightmost 6 digits of packeddata to zero, into angle.
    angle = (angle >> 6); // shift 18-digit angle right 6 digits to form 12-digit value
    data.angle = angle * 0.08789; // angle * (360/4096) == actual degrees

    // Status bits.
    long statusbits = packeddata & STATUS_MASK;
    data.movingAway = statusbits & 2; // goes high if magnet moved away from IC
    data.movingToward = statusbits & 4; // goes high if magnet moved towards IC
    data.linearityError = statusbits & 8; // goes high for linearity alarm
    data.cordicOverflow = statusbits & 16; // goes high for cordic overflow: data invalid
    data.chipReady = statusbits & 32; // this is 1 when the chip startup is finished.

    return data;
}

void AS5045Data::print() {
    int written = Serial.print(angle);
    for (int i = written; i < 4; i++) {
      Serial.print(" ");
    }
    
    Serial.print(movingAway);
    Serial.print(" ");
    Serial.print(movingToward);
    Serial.print(" ");
    Serial.print(linearityError);
    Serial.print(" ");
    Serial.print(cordicOverflow);
    Serial.print(" ");
    Serial.print(chipReady);
    Serial.println();
}

