// Copyright 2015 Lawrence Kesteloot

#ifndef __as5045_h__
#define __as5045_h__

struct AS5045Data {
    // In degrees.
    float angle;

    // Status codes.
    bool movingAway;
    bool movingToward;
    bool linearityError;
    bool cordicOverflow;  // Data invalid.
    bool chipReady;
    
    void print();
};

class AS5045 {
public:
    AS5045(int csPin, int clockPin, int dataPin);

    AS5045Data getData();

private:
    int mCsPin;
    int mClockPin;
    int mDataPin;
};

#endif // __as5045_h__
