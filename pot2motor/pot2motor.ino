
int pwmPin = 9;
int dirPin = 8;

void setup()  { 
  pinMode(dirPin, OUTPUT);
} 

void loop()  { 
  int sensorValue = analogRead(A0) - 512;
  
  if (sensorValue < 0) {
    digitalWrite(dirPin, HIGH);
    analogWrite(pwmPin, (sensorValue + 512)/2);
  } else {
    digitalWrite(dirPin, LOW);
    analogWrite(pwmPin, sensorValue/2);
  }

  delay(1);
}


