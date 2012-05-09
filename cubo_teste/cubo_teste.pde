#include <avr/interrupt.h>
#include <avr/io.h>

#define DATA_SIZE 3
#define ENABLE_SIZE 2
#define LAYERS_SIZE 4

// Data pins
int data[]	= {2, 3, 4};

// Enable pins
int enable[]	= {5, 6};

// Layer pins
int layers[]	= {14, 15, 16, 17};


int led_counter	= 0;

byte table[] = { B00000000, B00000000, B0000 };



void write_byte(int number)
{
  int mask = 0;
  int power = 0;

  for(int i = 0; i < DATA_SIZE; i++){
    mask = B1 << i;
    if(true && (mask & number)){
      power = HIGH;
    } else {
      power = LOW;
    }
    digitalWrite(data[i], power);
  }
}



void setup() {
	for(int i = 0; i < DATA_SIZE; i++){
		pinMode(data[i], OUTPUT);
		digitalWrite(data[i], LOW);
	}

	for(int i = 0; i < ENABLE_SIZE; i++){
		pinMode(enable[i], OUTPUT);
		digitalWrite(enable[i], LOW);
	}

	for(int i = 0; i < LAYERS_SIZE; i++){
		pinMode(layers[i], OUTPUT);
		digitalWrite(layers[i], LOW);
	}
}


void pisca8(void) {
  for(led_counter=0; led_counter<8; led_counter++ ) {
    write_byte(led_counter);
    delay(100);
  }
}


void pisca16(void) {  
  digitalWrite(enable[0], LOW);
  digitalWrite(enable[1], HIGH);
  pisca8();
  digitalWrite(enable[0], HIGH);
  digitalWrite(enable[1], LOW);
  pisca8();
}


void pisca_rapido(void) {
  
  
  
    digitalWrite(enable[0], LOW);
    digitalWrite(enable[1], HIGH);
    for(led_counter=0; led_counter<8; led_counter++ ) {
      write_byte(led_counter);
      delayMicroseconds(100);
    }
    
    digitalWrite(enable[0], HIGH);
    digitalWrite(enable[1], LOW);
    for(led_counter=0; led_counter<8; led_counter++ ) {
      write_byte(led_counter);
      delayMicroseconds(100);
    }
}

void pisca_rapido_tudo(void) {

  for(int test_counter=0; test_counter<100; test_counter++ ) {
    digitalWrite(layers[0], HIGH);
    pisca_rapido();
  
    digitalWrite(layers[0], LOW);
    digitalWrite(layers[1], HIGH);
    pisca_rapido();
    
    digitalWrite(layers[1], LOW);
    digitalWrite(layers[2], HIGH);
    pisca_rapido();
  
    digitalWrite(layers[2], LOW);
    digitalWrite(layers[3], HIGH);
    pisca_rapido();
  
    digitalWrite(layers[3], LOW);
  }
    
}


void pisca_tudo(void) {
  pisca_rapido_tudo();
  delay(1000);
  pisca_rapido_tudo();
  delay(1000);
  pisca_rapido_tudo();
  delay(1000);
  pisca_rapido_tudo();
  delay(1000);
  pisca_rapido_tudo();
  delay(1000);
  pisca_rapido_tudo();
  delay(1000);
  pisca_rapido_tudo();
  delay(1000);
  pisca_rapido_tudo();
  delay(1000);
  pisca_rapido_tudo();
  delay(1000);
  pisca_rapido_tudo();
  delay(1000);
}


void pisca_todos(void) {
  digitalWrite(layers[0], HIGH);
  pisca16();

  digitalWrite(layers[0], LOW);
  digitalWrite(layers[1], HIGH);
  pisca16();
  
  digitalWrite(layers[1], LOW);
  digitalWrite(layers[2], HIGH);
  pisca16();

  digitalWrite(layers[2], LOW);
  digitalWrite(layers[3], HIGH);
  pisca16();

  digitalWrite(layers[3], LOW);
}


void loop() {
  
  pisca_tudo();
  
  pisca_todos();
  pisca_todos();
  pisca_todos();
  pisca_todos();

/*  
  digitalWrite(15, LOW);
  digitalWrite(16, LOW);
  delay(5000);
*/
  
}
