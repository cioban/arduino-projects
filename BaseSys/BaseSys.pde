#include <TimerOne.h>

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
 
void setup() 
{
  task_control[0] = 4;
  task_control[1] = 10;
  task_control[2] = 10;
  task_control[3] = 5;
  task_control[4] = 2;
  
  pinMode(13, OUTPUT);    
  
  Timer1.initialize(250); // Inicializa o timer, configurando interrupcao a cada 250us 
  Timer1.attachInterrupt( timerInterrupt ); // Indica funcao de callback para cada interrupcao do timer 
}
 
void loop()
{
  if(_1ms) {
    _1ms = false;
  }
  
  if(_10ms) {
    _10ms = false;
  }
  
  if(_100ms) {
    _100ms = false;
  }
  
  
  if(_500ms) {
    _500ms = false;
    // Toggle LED
    digitalWrite( 13, digitalRead( 13 ) ^ 1 );
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
