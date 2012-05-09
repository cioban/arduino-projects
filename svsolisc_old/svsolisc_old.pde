#include <FlexiTimer2.h>

#include <Metro.h>



#define led1 10
#define led2 11
#define led3 12
#define led4 13

#define button1 2
#define button2 3
#define button3 4
#define button4 5

int leds_status = 0;
Metro ledMetro1 = Metro(1000);



void setup(){
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);
  pinMode(led4, OUTPUT);
  
  pinMode(button1, INPUT);
  pinMode(button2, INPUT);
  pinMode(button3, INPUT);
  pinMode(button4, INPUT);
  
  digitalWrite(led1, LOW);
  digitalWrite(led2, LOW);
  digitalWrite(led3, LOW);
  digitalWrite(led4, LOW);
}





void leds_off(void) {
  /* Apaga todos os leds  */
  digitalWrite(led1, LOW);
  digitalWrite(led2, LOW);
  digitalWrite(led3, LOW);
  digitalWrite(led4, LOW);  
  leds_status = 0;
}


void leds_on(void) {
  digitalWrite(led1, HIGH);
  digitalWrite(led2, HIGH);
  digitalWrite(led3, HIGH);
  digitalWrite(led4, HIGH);
  leds_status = 1;
}


void leds_blink(void){
  if (leds_status == 0) {
    leds_on();
  } else {
    leds_off();
  }
}


void loop(){
  if (ledMetro1.check() == 1) {
    leds_blink();
  }
/*
  digitalWrite(led1, HIGH);
  delay(1000);
  digitalWrite(led1, LOW);
  digitalWrite(led2, HIGH);
  delay(1000);
  digitalWrite(led2, LOW);
  digitalWrite(led3, HIGH);
  delay(1000);
  digitalWrite(led3, LOW);
  digitalWrite(led4, HIGH);
  delay(1000);
  digitalWrite(led4, LOW);

  if (buttonState == HIGH) {     
    // turn LED on:    
    digitalWrite(ledPin, HIGH);  
  } 
  else {
    // turn LED off:
    digitalWrite(ledPin, LOW); 
  }
*/
}

