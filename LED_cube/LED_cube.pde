#include <TimerOne.h>

#define DATA_SIZE 3
#define ENABLE_SIZE 2
#define LAYER_SIZE 4


/*
 * Contadores para o controle de tarefas
 * [0] = 4  -- 4x250us = 1ms
 * [1] = 10 -- 10x1ms = 10ms
 * [2] = 10 -- 10x10ms = 100ms
 * [3] = 5 --  5x100ms = 500ms
 * [4] = 2 -- 2x500ms = 1s
 */
int task_control[5];

boolean _1ms = false;
boolean _10ms = false;
boolean _100ms = false;
boolean _500ms = false;
boolean _1s = false;

// Data pins
int data[]	= {2, 3, 4};

// Enable pins
int enable[]	= {5, 6};

// Layer pins
int layer[]	= {14, 15, 16, 17};







byte cube_value[] = { B00000000, B00000000, B0000 };
//byte cube_value[] = { B01100110, B00000000, B00001000};



// Efeitos
int effects[] = {
  //8leds,   8leds,     layer, tempo (unidades de 10ms)

  // Cubo - cubo
  B00000110, B01100000, B0110, 30,
  B11111001, B10011111, B1111, 30,
  B00000110, B01100000, B0110, 30,
  B11111001, B10011111, B1111, 30,
  B00000110, B01100000, B0110, 30,
  B11111001, B10011111, B1111, 30,
  B00000110, B01100000, B0110, 30,
  B11111001, B10011111, B1111, 30,
  B00000110, B01100000, B0110, 30,
  B11111001, B10011111, B1111, 30,
  B00000110, B01100000, B0110, 30,
  B11111001, B10011111, B1111, 30,
  B00000110, B01100000, B0110, 30,
  B11111001, B10011111, B1111, 30,
  B00000110, B01100000, B0110, 30,
  B11111001, B10011111, B1111, 30,
  B00000110, B01100000, B0110, 30,
  B11111001, B10011111, B1111, 30,
  B00000110, B01100000, B0110, 30,
  B11111001, B10011111, B1111, 30,

  B00000000, B00000000, B0000, 50,

  // Efeito rotacao
  B10000100, B00100001, B0001, 20,
  B00001111, B11110000, B0001, 20,
  B00010010, B01001000, B0001, 20,

  B10000100, B00100001, B0010, 20,
  B00001111, B11110000, B0010, 20,
  B00010010, B01001000, B0010, 20,

  B10000100, B00100001, B0100, 20,
  B00001111, B11110000, B0100, 20,
  B00010010, B01001000, B0100, 20,

  B10000100, B00100001, B1000, 20,
  B00001111, B11110000, B1000, 20,
  B00010010, B01001000, B1000, 20,

  B00000000, B00000000, B0000, 100,

  // Efeito subida 1, acende o ultimo layer e sobe-desce 2 das pontas
  B00001000, B00000000, B0001, 10,
  B00001000, B00000000, B0010, 10,
  B00001000, B00000000, B0100, 10,
  B00001000, B00000000, B1000, 10,
  B11111111, B11111111, B1000, 50,
  B10000000, B00000001, B1000, 5,
  B10000000, B00000001, B0100, 5,
  B10000000, B00000001, B0010, 5,
  B10000000, B00000001, B0001, 5,
  B10000000, B00000001, B0010, 5,
  B10000000, B00000001, B0100, 5,
  B10000000, B00000001, B1000, 5,
  B10000000, B00000001, B0100, 5,
  B10000000, B00000001, B0010, 5,
  B10000000, B00000001, B0001, 5,
  B00010000, B00001000, B0001, 5,
  B00010000, B00001000, B0010, 5,
  B00010000, B00001000, B0100, 5,
  B00010000, B00001000, B1000, 5,
  B00010000, B00001000, B0100, 5,
  B00010000, B00001000, B0010, 5,
  B00010000, B00001000, B0001, 5,
  B00010000, B00001000, B0100, 5,
  B00010000, B00001000, B1000, 5,
  B00010000, B00001000, B0100, 5,
  B00010000, B00001000, B0010, 5,
  B00010000, B00001000, B0001, 5,

  B00000000, B00000000, B0000, 50,


  // Efeito Redor tempo progressivo
  B11111001, B10011111, B0001, 50,
  B11111001, B10011111, B0010, 50,
  B11111001, B10011111, B0100, 50,
  B11111001, B10011111, B1000, 50,

  B11111001, B10011111, B1000, 50,
  B11111001, B10011111, B0100, 50,
  B11111001, B10011111, B0010, 50,
  B11111001, B10011111, B0001, 50,

  B11111001, B10011111, B0001, 40,
  B11111001, B10011111, B0010, 40,
  B11111001, B10011111, B0100, 40,
  B11111001, B10011111, B1000, 40,

  B11111001, B10011111, B1000, 40,
  B11111001, B10011111, B0100, 40,
  B11111001, B10011111, B0010, 40,
  B11111001, B10011111, B0001, 40,

  B11111001, B10011111, B0001, 30,
  B11111001, B10011111, B0010, 30,
  B11111001, B10011111, B0100, 30,
  B11111001, B10011111, B1000, 30,

  B11111001, B10011111, B1000, 30,
  B11111001, B10011111, B0100, 30,
  B11111001, B10011111, B0010, 30,
  B11111001, B10011111, B0001, 30,

  B11111001, B10011111, B0001, 20,
  B11111001, B10011111, B0010, 20,
  B11111001, B10011111, B0100, 20,
  B11111001, B10011111, B1000, 20,

  B11111001, B10011111, B1000, 20,
  B11111001, B10011111, B0100, 20,
  B11111001, B10011111, B0010, 20,
  B11111001, B10011111, B0001, 20,

  B11111001, B10011111, B0001, 10,
  B11111001, B10011111, B0010, 10,
  B11111001, B10011111, B0100, 10,
  B11111001, B10011111, B1000, 10,

  B11111001, B10011111, B1000, 10,
  B11111001, B10011111, B0100, 10,
  B11111001, B10011111, B0010, 10,
  B11111001, B10011111, B0001, 10,

  B11111001, B10011111, B0001, 8,
  B11111001, B10011111, B0010, 8,
  B11111001, B10011111, B0100, 8,
  B11111001, B10011111, B1000, 8,

  B11111001, B10011111, B1000, 8,
  B11111001, B10011111, B0100, 8,
  B11111001, B10011111, B0010, 8,
  B11111001, B10011111, B0001, 8,

  B11111001, B10011111, B0001, 7,
  B11111001, B10011111, B0010, 7,
  B11111001, B10011111, B0100, 7,
  B11111001, B10011111, B1000, 7,

  B11111001, B10011111, B1000, 7,
  B11111001, B10011111, B0100, 7,
  B11111001, B10011111, B0010, 7,
  B11111001, B10011111, B0001, 7,

  B11111001, B10011111, B0001, 6,
  B11111001, B10011111, B0010, 6,
  B11111001, B10011111, B0100, 6,
  B11111001, B10011111, B1000, 6,

  B11111001, B10011111, B1000, 6,
  B11111001, B10011111, B0100, 6,
  B11111001, B10011111, B0010, 6,
  B11111001, B10011111, B0001, 6,

  B11111001, B10011111, B0001, 5,
  B11111001, B10011111, B0010, 5,
  B11111001, B10011111, B0100, 5,
  B11111001, B10011111, B1000, 5,

  B11111001, B10011111, B1000, 5,
  B11111001, B10011111, B0100, 5,
  B11111001, B10011111, B0010, 5,
  B11111001, B10011111, B0001, 5,

  B11111001, B10011111, B0001, 4,
  B11111001, B10011111, B0010, 4,
  B11111001, B10011111, B0100, 4,
  B11111001, B10011111, B1000, 4,

  B11111001, B10011111, B1000, 4,
  B11111001, B10011111, B0100, 4,
  B11111001, B10011111, B0010, 4,
  B11111001, B10011111, B0001, 4,

  B11111001, B10011111, B0001, 4,
  B11111001, B10011111, B0010, 4,
  B11111001, B10011111, B0100, 4,
  B11111001, B10011111, B1000, 4,

  B11111001, B10011111, B1000, 3,
  B11111001, B10011111, B0100, 3,
  B11111001, B10011111, B0010, 3,
  B11111001, B10011111, B0001, 3,

  B11111001, B10011111, B0001, 2,
  B11111001, B10011111, B0010, 2,
  B11111001, B10011111, B0100, 2,
  B11111001, B10011111, B1000, 2,

  B11111001, B10011111, B1000, 2,
  B11111001, B10011111, B0100, 2,
  B11111001, B10011111, B0010, 2,
  B11111001, B10011111, B0001, 2,

  B11111001, B10011111, B0001, 1,
  B11111001, B10011111, B0010, 1,
  B11111001, B10011111, B0100, 1,
  B11111001, B10011111, B1000, 1,

  B11111001, B10011111, B1000, 1,
  B11111001, B10011111, B0100, 1,
  B11111001, B10011111, B0010, 1,
  B11111001, B10011111, B0001, 1,

  B11111001, B10011111, B1111, 500,


  //Efeito pisca tudo
  B00000000, B00000000, B0000, 50,
  B11111111, B11111111, B1111, 50,
  B00000000, B00000000, B0000, 50,
  B11111111, B11111111, B1111, 50,
  B00000000, B00000000, B0000, 50,
  B11111111, B11111111, B1111, 50,
  B00000000, B00000000, B0000, 50,
  B11111111, B11111111, B1111, 50,
  B00000000, B00000000, B0000, 50,
  B11111111, B11111111, B1111, 50,
  B00000000, B00000000, B0000, 50,

  B00000000, B00000000, B0000, 100,
  // Efeito dummy para indicar o fim dos esfeitos. - nao apagar
  B11111111, B11111111, B11111111, 0
};



int teste_array[64][3];


int effect_counter = 0;
int effect_time = 0;


void setup() {
  
  //Serial.begin(9600);
  
  
  task_control[0] = 4;
  task_control[1] = 10;
  task_control[2] = 10;
  task_control[3] = 5;
  task_control[4] = 2;  
  
  
  
  
  for(int i = 0; i < DATA_SIZE; i++){
    pinMode(data[i], OUTPUT);
    digitalWrite(data[i], LOW);
	}

	for(int i = 0; i < ENABLE_SIZE; i++){
		pinMode(enable[i], OUTPUT);
		digitalWrite(enable[i], LOW);
	}

	for(int i = 0; i < LAYER_SIZE; i++){
		pinMode(layer[i], OUTPUT);
		digitalWrite(layer[i], LOW);
	}

        Timer1.initialize(250); // Inicializa o timer, configurando interrupcao a cada 250us 
        Timer1.attachInterrupt( timerInterrupt ); // Indica funcao de callback para cada interrupcao do timer
        
        pinMode(13, OUTPUT);
        digitalWrite(13, LOW);
}



void write_data_byte(int number)
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




void mux_select(int enable_value)
{
  if (enable_value & B00000001) {
    digitalWrite(enable[0], HIGH);
  } else {
    digitalWrite(enable[0], LOW);
  }
  
  if (enable_value & B00000010) {
    digitalWrite(enable[1], HIGH);
  } else {
    digitalWrite(enable[1], LOW);
  }
}


void layer_select(int layer_value)
{
  int comp = B00000001;
  
  for(int i = 0; i < LAYER_SIZE; i++){
    if (layer_value & comp) {
      digitalWrite(layer[i], HIGH);
    } else {
      digitalWrite(layer[i], LOW);
    }
    comp <<= 0x01;
  }
}


void cube_driver() {
  byte comp = B10000000;
  byte counter = 0;


  layer_select(0x00);


  //TODO: Mudar o driver
  /*
  for (int idx = 0; idx < 64; idx++) {
    if(cube_value[idx] == true) {
      write_data_byte(counter);
    } else {
      mux_select(0x00);
      layer_select(0x00);
    }
  }
  */

  if(cube_value[0]) {
    while(true) {
      if(cube_value[0] & comp) {
        layer_select(cube_value[2]);
        mux_select(0x02);
        write_data_byte(counter);

        delayMicroseconds(500);
        //mux_select(0x00);
        //layer_select(0x00);
        //delayMicroseconds(500);

      } else {
        mux_select(0x00);
        layer_select(0x00);
      }
      counter++;
      if(counter > 7) {
        break;
      }
      comp >>= 0x01;
    }
  } else {
    mux_select(0x00);
    layer_select(0x00);
  }


  comp = B10000000;
  counter = 0;
  if(cube_value[1]) {
    while(true) {
      if(cube_value[1] & comp) {
        layer_select(cube_value[2]);
        mux_select(0x01);
        write_data_byte(counter);

        delayMicroseconds(500);
        //mux_select(0x00);
        //layer_select(0x00);
        //delayMicroseconds(500);
        
      } else {
        mux_select(0x00);
        layer_select(0x00);
      }
      counter++;
      if(counter > 7) {
        break;
      }
      comp >>= 0x01;
    }
  } else {
    mux_select(0x00);
    layer_select(0x00);
  }

  mux_select(0x00);
  layer_select(0x00);
}




void effect_driver(void) {
  
  int effect_addr = 0;
  
  byte effect_data_low8 = 0;
  byte effect_data_high8 = 0;
  byte effect_data_layer = 0;
  int effect_data_time = 0;
  
  
  //Consome o tempo
  if(effect_time) {
    effect_time--;
    return;
  }
  
  //Carrega o efeito
  effect_addr = effect_counter * 4;
  
  effect_data_low8 = effects[effect_addr];
  effect_data_high8 = effects[effect_addr + 1];
  effect_data_layer = effects[effect_addr + 2];
  effect_data_time = effects[effect_addr + 3];
  
  
  // Verifica se eh o fim dos efeitos
  if((effect_data_low8 == B11111111) && (effect_data_high8 == B11111111) &&
    (effect_data_layer == B11111111) && (effect_data_time == 0)) {
    effect_counter = 0;
    effect_time = 0;
    return;
  }
  
  if(effect_data_time > 0) {
    effect_time = effect_data_time;
    cube_value[0] = effect_data_low8;
    cube_value[1] = effect_data_high8;
    cube_value[2] = effect_data_layer;
  }
  
  effect_counter++;
  return;
}




void loop() {
  cube_driver();

  if(_1ms) {
    _1ms = false;
    
  }
  
  if(_10ms) {
    _10ms = false;
    effect_driver();
    
  }
  
  if(_100ms) {
    _100ms = false;
    
  }
  
  
  if(_500ms) {
    _500ms = false;
    digitalWrite(13, digitalRead(13) ^ 1 );
  }
  
  if(_1s) {
    _1s = false;
      
  }

  
}




void timerInterrupt()
{
  
  task_control[0]--;
  if(task_control[0]){
    return;
  }
  _1ms = true;
  task_control[0] = 4;


  task_control[1]--;
  if(task_control[1]){
    return;
  }
  _10ms = true;
  task_control[1] = 10;

  task_control[2]--;
  if(task_control[2]){
    return;
  }
  _100ms = true;
  task_control[2] = 10;


  task_control[3]--;
  if(task_control[3]){
    return;
  }
  _500ms = true;
  task_control[3] = 5;


  task_control[4]--;
  if(task_control[4]){
    return;
  }
  _1s = true;
  task_control[4] = 2;    
}
