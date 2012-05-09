int leds[] = {6, 7, 8, 9};
int leds_size = 4;
int leds_steps[] = {1, 2, 4, 8};

int buttons[] = {2, 3, 4, 5};
int buttons_size = 4;
int buttons_value[] = {1, 2, 4, 8};

int leds_status = 0;
int leds_enable = true;
long previousMillis = 0;
long interval = 200;

int last_state = -1;
int prize = 0;

int animation_state = 0;
boolean animation = true;
boolean forward = true;

void leds_off(void) {
  /* Apaga todos os leds  */
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

void setup(){
  Serial.begin(9600);
  for(int i = 0; i < leds_size; i++){
    pinMode(leds[i], OUTPUT);
  }

  for(int i = 0; i < buttons_size; i++){
    pinMode(buttons[i], INPUT);
  }
  
  for(int i = 0; i < leds_size; i++){
    digitalWrite(leds[i], LOW);
  }
  
  prize = random(0, leds_size);
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



void loop(){
  if(animation) {
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
    else if(animation_state == 0) {
      animation = false;
      forward = true;
    }
    
    delay(100);
  }
  else {
    unsigned long currentMillis = millis();
   
    if(currentMillis - previousMillis > interval) {
      // save the last time you blinked the LED 
      previousMillis = currentMillis;
      if(leds_enable == true){
        leds_blink();
      }
    }
  
    int state = -1;
    for(int i = 0; i < buttons_size; i++){
      if (digitalRead(buttons[i]) == LOW){
        state = i;
      }
    }
    
    if(state != last_state && state == -1 && prize == last_state) {
       prize = random(0, leds_size);
       animation = true;
       leds_on();
       delay(600);
       leds_off();
       delay(600);
       leds_on();
       delay(600);
    }
    
    last_state = state;
  }
}
