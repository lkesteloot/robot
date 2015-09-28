// Copyright 2015 Lawrence Kesteloot

#ifndef __shoulder_h__
#define __shoulder_h__

class Shoulder {
public:
    static const int PWM_PIN = 3;

    Shoulder(int dir1Pin, int dir2Pin);

    // Delta is -255 to 255.
    void move(int delta);

private:

    int mDir1Pin;
    int mDir2Pin;
};


#endif // __shoulder_h__
