#include <Arduino.h>

#include "AS5045.h"
#include "Shoulder.h"

AS5045 as5045(6, 7, 2);
Shoulder shoulder(4, 8);

void setup()
{
  Serial.begin(9600);
  shoulder.move(0);
}

#if 0
// Control motor position with pot.
void loop()
{
  AS5045Data data = as5045.getData();
  int potValue = analogRead(A0) - 512;

  int target = int(potValue*0.35);
  int error = target - data.angle;
  if (error > 180) {
    error -= 360;
  }
  if (error < -180) {
    error += 360;
  }

  shoulder.move(error);
  Serial.println(data.angle, DEC);

  delay(100);
}
#endif

#if 0
// Control motor speed with pot.
void loop()
{
  int potValue = analogRead(A0) - 512;

  Serial.println(potValue);
  shoulder.move(potValue / 2);

  delay(100);
}
#endif

#if 1
// Run through all PWM values and display speed.
void loop()
{
  delay(2000);
  
  for (int speed = -255; speed <= 255; speed += 10) {
    Serial.print("Speed ");
    Serial.println(speed);
    shoulder.move(speed);

    for (int j = 0; j < 3000; j++) {
      AS5045Data data = as5045.getData();
      Serial.print(j);
      Serial.print(" ");
      Serial.println(data.angle);
    }
  }
}
#endif

