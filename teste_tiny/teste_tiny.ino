#include <SoftwareSerial.h>

SoftwareSerial mySerial(1, 2);


void setup()
{
 mySerial.begin(2400);
 mySerial.println("Hello, world?");
 pinMode(0, OUTPUT);
}

void loop() {
 digitalWrite(0, digitalRead(0) ^ 1); // set the LED on
 delay(1000); // wait for a second
 mySerial.println("Vai...");
 //digitalWrite(0, LOW); // set the LED off
 //delay(1000); // wait for a second
}
