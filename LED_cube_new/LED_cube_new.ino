#include <TimerOne.h>

extern "C" {
//#include <vector.h>
#include <string.h>
#include <stdlib.h>

}

#define LAYER_SIZE 4
#define DATA_SIZE 16

#define LAYER_OFF 0x00
#define LAYER_ON_1 0x01
#define LAYER_ON_2 0x02
#define LAYER_ON_3 0x04
#define LAYER_ON_4 0x08

#define MAX_EFFECT 50


/*
 * Contadores para o controle de tarefas
 * [0] = 4	-- 4x250us = 1ms
 * [1] = 10 -- 10x1ms = 10ms
 * [2] = 10 -- 10x10ms = 100ms
 * [3] = 5 --	5x100ms = 500ms
 * [4] = 2 -- 2x500ms = 1s
 */
int task_control[5];

boolean _1ms = false;
boolean _10ms = false;
boolean _100ms = false;
boolean _500ms = false;
boolean _1s = false;

// Data pins
int data[]	= {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};

// Layer pins
int layer[]	= {16, 17, 18, 19};


int effect_counter = 0;
int effect_time = 0;
int effect_loop = 0;
word cube_driver_comp = 0x8000;




//word cube_value[] = {
//	0xF99F, // Layer 1
//	0x9009, // Layer 2
//	0x9009, // Layer 3
//	0xF99F, // Layer 4
//};

word cube_value[] = {
	0xFFFF, // Layer 1
	0xFFFF, // Layer 2
	0xFFFF, // Layer 3
	0xFFFF, // Layer 4
};


/*
Formato de cada passo dos efeitos
0x0000, // Layer 1 - 16 bits
0x0000, // Layer 2 - 16 bits
0x0000, // Layer 3 - 16 bits
0x0000, // Layer 4 - 16 bits
0,		// Time - 10 ms units
*/


struct effect_t
{
	word * data;
	unsigned char count;
	unsigned char size;
};


// Efeitos
struct effect_t * effects[MAX_EFFECT];






void add_effect(word * effect, byte loop_counter) {
    struct effect_t *new_fx;
    byte counter = 0;

    new_fx = (effect_t *)malloc(sizeof(effect_t));
    new_fx->data = effect;
    new_fx->size = (sizeof(effect)/sizeof(word));
    new_fx->count = loop_counter;

    for(counter=0; counter<MAX_EFFECT; counter++) {
        if(effects[counter] != 0) {
            effects[counter] = new_fx;
            break;
        }
    }

}


void setup() {

	// Setup das variaveis
	memset(effects, 0x00, MAX_EFFECT);

    word effect_pause_data[] = {
	    // Layer 1	Layer 2		Layer 3		Layer 4		Time
	    0x0000,		0x0000,		0x0000,		0x0000,		50,
    };

    word effect_cube_data[] = {
	    //Layer 1	Layer 2		Layer 3		Layer 4		Time
	    0x0000,		0x06C0,		0x06C0,		0x0000,		30,
	    // Layer 1	Layer 2		Layer 3		Layer 4		Time
	    0xF99F,		0xF99F,		0xF99F,		0xF99F,		30,

    	//10, // Numero de vezes que o efeito deve ser repetido
    };
    add_effect(effect_cube_data, 10);
    add_effect(effect_pause_data, 10);



	//Serial.begin(9600);
	task_control[0] = 2;
	task_control[1] = 10;
	task_control[2] = 10;
	task_control[3] = 5;
	task_control[4] = 2;


	for(int i = 0; i < DATA_SIZE; i++){
		pinMode(data[i], OUTPUT);
		digitalWrite(data[i], LOW);
	}

	for(int i = 0; i < LAYER_SIZE; i++){
		pinMode(layer[i], OUTPUT);
		digitalWrite(layer[i], HIGH);
	}

	Timer1.initialize(500); // Inicializa o timer, configurando interrupcao a cada 500us
	Timer1.attachInterrupt( timerInterrupt ); // Indica funcao de callback para cada interrupcao do timer

}



void write_data_byte(word number)
{
	word mask = 0;
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


void layer_select(int layer_value)
{
	int comp = B00000001;

	// Desliga todos os layers
	for(int i = 0; i < LAYER_SIZE; i++){
		digitalWrite(layer[i], HIGH);
	}

	for(int i = 0; i < LAYER_SIZE; i++){
		if (layer_value & comp) {
			digitalWrite(layer[i], LOW);
		} else {
			digitalWrite(layer[i], HIGH);
		}
		comp <<= 0x01;
	}
}


void cube_driver(void) {
	byte counter = 0;
	word comp = 0x01;
	word layer_data = 0;
	byte layer_value = 0x01;

	layer_select(LAYER_OFF);
	for(byte i = 0; i < LAYER_SIZE; i++){
		//write_data_byte(0x0);
		layer_data = cube_value[i];
		layer_select(layer_value);
		comp = 0x0001;
		for(counter = 0; counter < 16; counter++) {
			if(layer_data & comp) {
				write_data_byte(comp);
				delayMicroseconds(10);
			//} else {
			//	write_data_byte(0x0);
			}
			comp <<= 0x01;
		}
		layer_value <<= 0x01;
	}
	layer_select(LAYER_OFF);

#if 0
	for(byte i = 0; i < LAYER_SIZE; i++){

		layer_select(layer_value);

		layer_data = cube_value[i];

		// Tem agum LED pra acender no layer?
		if(layer_data){
			write_data_byte(layer_data);
			delayMicroseconds(100);
			//delay(500);
		}
		else {
			layer_select(LAYER_OFF);
		}
		layer_value <<= 0x01;
	}
#endif
}



void effect_driver(void) {

	int effect_addr = 0;
    struct effect_t *curr_effect;

	word effect_data_layer_1 = 0;
	word effect_data_layer_2 = 0;
	word effect_data_layer_3 = 0;
	word effect_data_layer_4 = 0;
	int effect_data_time = 0;


	//Consome o tempo
	if(effect_time) {
		effect_time--;
		return;
	}

	//Carrega o efeito
	curr_effect = effects[effect_counter];

#if 0
	effect_data_layer_1 = effects[effect_addr];
	effect_data_layer_2 = effects[effect_addr + 1];
	effect_data_layer_3 = effects[effect_addr + 2];
	effect_data_layer_4 = effects[effect_addr + 3];
	effect_data_time	= effects[effect_addr + 4];

	// Verifica se eh o fim dos efeitos
	if((effect_data_layer_1 == 0xFFFF) && (effect_data_layer_2 == 0xFFFF) &&
		(effect_data_layer_3 == 0xFFFF) && (effect_data_layer_4 == 0xFFFF) &&
		(effect_data_time == 0xFFFF))
	{
		effect_counter = 0;
		effect_time = 0;
		return;
	}

	if(effect_data_time > 0) {
		effect_time = effect_data_time;
		cube_value[0] = effect_data_layer_1;
		cube_value[1] = effect_data_layer_2;
		cube_value[2] = effect_data_layer_3;
		cube_value[3] = effect_data_layer_4;
	}
#endif
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
		//digitalWrite(13, digitalRead(13) ^ 1 );
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
	task_control[0] = 2;


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
