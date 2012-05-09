/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.


#define LED1_RED 2
#define LED1_GREEN 3
#define DELAY_ON 100
#define DELAY_OFF 150
 */
int leds[] = {6, 7, 8, 9, 10, 11, 12, 13};
int leds_size = 8;
//int steps[] = {1,3,7,15,31,63,127,255,254,250,234,170};
int steps[] = {1,5,21,85,87,95,127,255,254,250,234,170};
int steps_size = 12;

int animation_state = 0;
boolean animation = false;
boolean forward = true;
int leds_status = 0;

int leds_green[] = {6, 8, 10, 12};
int leds_red[] = {7, 9, 11, 13};
int real_leds_size = 4;

void leds_off(void) {
  write_byte(0);
  leds_status = 0;
}

void leds_on(void) {
  int mask = 0xFFFF;
  mask = mask << leds_size;
  write_byte(~mask);
  leds_status = 1;
}

void leds_blink(void){
  if (leds_status == 0) {
    leds_on();
  } else {
    leds_off();
  }
}


void write_byte(int number)
{
  int mask = 0;
  int power = 0;
  
  for(int i = 0; i < leds_size; i++){
    mask = B1 << i;
    if(true && (mask & number)){
      power = HIGH;
    } else {
      power = LOW;
    }
    digitalWrite(leds[i], power);
  }
}


void setup() {
  for(int i = 0; i < leds_size; i++){
    pinMode(leds[i], OUTPUT);
    digitalWrite(leds[i], LOW);
  }
}


void loop() {
  /*
  digitalWrite(LED1_RED, HIGH);
  delay(DELAY_ON);
  digitalWrite(LED1_RED, LOW);
  delay(DELAY_OFF);
  
  digitalWrite(LED1_GREEN, HIGH);
  delay(DELAY_ON);
  digitalWrite(LED1_GREEN, LOW);
  delay(DELAY_OFF);
  
  digitalWrite(LED1_RED, HIGH);
  digitalWrite(LED1_GREEN, HIGH);
  delay(DELAY_ON);
  digitalWrite(LED1_RED, LOW);
  digitalWrite(LED1_GREEN, LOW);
  delay(DELAY_OFF);
  */
  

  if(animation){  
    write_byte(animation_state);
    
    if(forward) {
      if(animation_state == 0) {
        animation_state = 1;
      }
      else {
        animation_state = animation_state << 1;
      }
    }
    else {
      animation_state = animation_state >> 1;
    }

    
    if( animation_state == 0x1 << leds_size ) {
      forward = false;
      animation_state = animation_state >> 2;
    }
    else if(animation_state == 1) {
      forward = true;
    }
    
    delay(500);
  }
 

 for(int i = 0; i < steps_size; i++){
   write_byte(steps[i]);
   delay(500);
 } 
 

 /*
 for(int i = 0; i < 256; i++){
   write_byte(i);
   delay(50);
 } 
  */
  
}
