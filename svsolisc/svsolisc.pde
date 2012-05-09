
//int leds[] = {10, 11, 12, 13};
int leds[] = {6, 7, 8, 9};
int leds_size = 4;
int leds_steps[] = {1, 2, 4, 8};

int buttons[] = {2, 3, 4, 5};
int buttons_size = 4;
int buttons_state[] = {0, 0, 0, 0};
int buttons_value[] = {1, 2, 4, 8};


int leds_status = 0;
int leds_enable = true;
long previousMillis = 0;
long interval = 200;



void leds_off(void) {
  /* Apaga todos os leds  */
  for(int i = 0; i < leds_size; i++){
    digitalWrite(leds[i], LOW);
  }  
  leds_status = 0;
}

void leds_on(void) {
  /* Acende todos os leds */
  for(int i = 0; i < leds_size; i++){
    digitalWrite(leds[i], HIGH);
  }
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
    //buttons_state[i] = digitalRead(buttons[i]);
    if (digitalRead(buttons[i]) == LOW){
      state = i;
    }
  }


  
  Serial.println(state);
  switch(state)
  {
    case -1:
        leds_enable = true;
    break;
    case 0:
      leds_enable = false;
      leds_off();
    break;
    case 1:
      leds_enable = false;
      leds_off();
    break;
    case 2:
      leds_enable = false;
      leds_off();
    break;
    case 3:
      leds_enable = false;
      leds_off();
    break;
    default:
      leds_enable = false;
      leds_on();
    break;
  }
  
  //if (button1_state == LOW)
  //{
  //}

  
  /*
  write_byte(1);
  delay(tempo);
  write_byte(2);
  delay(tempo);
  write_byte(4);
  delay(tempo);
  write_byte(8);
  delay(tempo);

  
  leds_blink();
  delay(tempo);
  */


/*
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

