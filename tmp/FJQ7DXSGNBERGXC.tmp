/*Blue LED Cube 4x4x4
** 
** Written: Paden Hogeland
**
*/

// Initalize our LED columns (positive)
int LEDPin[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
// Initalize the LED layers (ground)
int LayerPin[] = {16,17,18,19};
  int count = 0;
  int timer = 0,
      leadA,f1,f2,f3 = 0,
      leadB,f1B,f2B,f3B;
  int laps=0;
  int pause = 0;
int OuterEdge[] = {0,1,2,3,7,11,15,14,13,12,8,4};
// Setup
void setup(){
  // Set up LED columns as output
  for(int pin = 0; pin < 16 ; pin++ ){
    pinMode(LEDPin[pin],OUTPUT);
    digitalWrite(LEDPin[pin],LOW);
  }
  // Set up LED Layers as output
  for(int layer = 0; layer < 4; layer++){
    pinMode(LayerPin[layer], OUTPUT);
    digitalWrite(LayerPin[layer], HIGH);
  }

}

// The Loop
void loop(){
  
  /////////////////////////////////////////////////////////////////////////////////
  //  This increments the layers from top to bottom
  /////////////////////////////////////////////////////////////////////////////////
  digitalWrite(LEDPin[0],HIGH);
  digitalWrite(LEDPin[1],HIGH);
  digitalWrite(LEDPin[2],HIGH);
  digitalWrite(LEDPin[3],HIGH);
  digitalWrite(LEDPin[4],HIGH);
  digitalWrite(LEDPin[5],HIGH);
  digitalWrite(LEDPin[6],HIGH);
  digitalWrite(LEDPin[7],HIGH);
  digitalWrite(LEDPin[8],HIGH);
  digitalWrite(LEDPin[9],HIGH);
  digitalWrite(LEDPin[10],HIGH);
  digitalWrite(LEDPin[11],HIGH);
  digitalWrite(LEDPin[12],HIGH);
  digitalWrite(LEDPin[13],HIGH);
  digitalWrite(LEDPin[14],HIGH);
  digitalWrite(LEDPin[15],HIGH);
  digitalWrite(LayerPin[0],HIGH); 
  digitalWrite(LayerPin[1],HIGH); 
  digitalWrite(LayerPin[2],HIGH); 
  digitalWrite(LayerPin[3],HIGH); 
  count = 1;
  pause = 1;
   while(count < 500){
     digitalWrite(LayerPin[0],LOW);    
     delay(pause);
     digitalWrite(LayerPin[0],HIGH);
     digitalWrite(LayerPin[1],LOW);    
     delay(pause);
     digitalWrite(LayerPin[1],HIGH);
     digitalWrite(LayerPin[2],LOW);    
     delay(pause);
     digitalWrite(LayerPin[2],HIGH);
     digitalWrite(LayerPin[3],LOW);    
     delay(pause);
     digitalWrite(LayerPin[3],HIGH); 
   count++;  
   }
   

   
  // Set up LED columns as output
  for(int pin = 0; pin < 16 ; pin++ ){
    digitalWrite(LEDPin[pin],LOW);
  }
  // Set up LED Layers as output
  for(int layer = 0; layer < 4; layer++){
    digitalWrite(LayerPin[layer], HIGH);
  }  
  
    /////////////////////////////////////////////////////////////////////////////////
  //  This increments the layers from top to bottom
  /////////////////////////////////////////////////////////////////////////////////
  // Set up LED columns as output
  for(int pin = 0; pin < 16 ; pin++ ){
    digitalWrite(LEDPin[pin],HIGH);
  }

  count = 1;
  pause = 1;
   while(count < 80){
     digitalWrite(LayerPin[0],LOW);    
     delay(count);
     digitalWrite(LayerPin[0],HIGH);
     digitalWrite(LayerPin[1],LOW);    
     delay(count);
     digitalWrite(LayerPin[1],HIGH);
     digitalWrite(LayerPin[2],LOW);    
     delay(count);
     digitalWrite(LayerPin[2],HIGH);
     digitalWrite(LayerPin[3],LOW);    
     delay(count);
     digitalWrite(LayerPin[3],HIGH); 
   count++;  
   }
   

   
  // Set up LED columns as output
  for(int pin = 0; pin < 16 ; pin++ ){
    digitalWrite(LEDPin[pin],LOW);
  }
  // Set up LED Layers as output
  for(int layer = 0; layer < 4; layer++){
    digitalWrite(LayerPin[layer], HIGH);
  }  
   /////////////////////////////////////////////////////////////////////////
   // Following Design
   //  The top Led leads the other LEDs around the outside of the Cube
   ////////////////////////////////////////////////////////////////////////
   // Initalize the columns for the LED's
   
   leadA=0;
   f1=11;
   f2=10;
   f3=9;
   leadB=6;
   f1B=5;
   f2B=4;
   f3B=3;
   count = 0; 
   while(count < 500){
     // Sets the time they all display or "blink together" to our eyes
     while(timer<10){
       digitalWrite(LayerPin[3],LOW);
       digitalWrite(LEDPin[OuterEdge[leadA]],HIGH);
       if(laps=1){
         digitalWrite(LEDPin[OuterEdge[leadB]],HIGH);
       }
       delay(3);
       digitalWrite(LEDPin[OuterEdge[leadA]],LOW);
       digitalWrite(LEDPin[OuterEdge[leadB]],LOW);
       digitalWrite(LayerPin[3],HIGH);
       digitalWrite(LayerPin[2],LOW);
       digitalWrite(LEDPin[OuterEdge[f1]],HIGH);
       if(laps=1){
         digitalWrite(LEDPin[OuterEdge[f1B]],HIGH);
       }
       delay(3);
       digitalWrite(LEDPin[OuterEdge[f1]],LOW);  
       digitalWrite(LEDPin[OuterEdge[f1B]],LOW);       
       digitalWrite(LayerPin[2],HIGH);
       digitalWrite(LayerPin[1],LOW);
       digitalWrite(LEDPin[OuterEdge[f2]],HIGH);
       if(laps=1){
         digitalWrite(LEDPin[OuterEdge[f2B]],HIGH);
       }
       delay(3);
       digitalWrite(LEDPin[OuterEdge[f2]],LOW);  
       digitalWrite(LEDPin[OuterEdge[f2B]],LOW);
       digitalWrite(LayerPin[1],HIGH);
       digitalWrite(LayerPin[0],LOW);
       digitalWrite(LEDPin[OuterEdge[f3]],HIGH);
       if(laps=1){
         digitalWrite(LEDPin[OuterEdge[f3B]],HIGH);
       }
       delay(3);
       digitalWrite(LEDPin[OuterEdge[f3]],LOW);    
       digitalWrite(LEDPin[OuterEdge[f3B]],LOW);      
       digitalWrite(LayerPin[0],HIGH);       
       timer++;
       count++;
     }
     timer=0;
     leadA++;
     f1++;
     f2++;
     f3++;
     leadB++;
     f1B++;
     f2B++;
     f3B++;
     if(leadA>11){
       leadA = 0;
       laps = 1;
     }
     if(f1>11){
       f1 = 0;
     }
     if(f2>11){
       f2 = 0;
     }
     if(f3>11){
       f3 = 0;
     }
     if(leadB>11){
       leadB = 0;
     }
     if(f1B>11){
       f1B = 0;
     }
     if(f2B>11){
       f2B = 0;
     }
     if(f3B>11){
       f3B = 0;
     }
     
   }
   
   count = 500;
   
     // Set up LED columns as output
  for(int pin = 0; pin < 16 ; pin++ ){
    digitalWrite(LEDPin[pin],LOW);
  }
  // Set up LED Layers as output
  for(int layer = 0; layer < 4; layer++){
    digitalWrite(LayerPin[layer], HIGH);
  }  
  pause = 130;
  while(count < 500){
    digitalWrite(LayerPin[0],HIGH);
    digitalWrite(LayerPin[3],LOW);
    digitalWrite(LEDPin[7],HIGH);
    delay(pause);
    digitalWrite(LayerPin[3],HIGH);
    digitalWrite(LayerPin[2],LOW);
    digitalWrite(LEDPin[7],HIGH);
    delay(pause);
    digitalWrite(LayerPin[2],HIGH);
    digitalWrite(LayerPin[1],LOW);
    digitalWrite(LEDPin[7],HIGH);
    delay(pause);
    digitalWrite(LayerPin[1],HIGH);
    digitalWrite(LayerPin[0],LOW);
    digitalWrite(LEDPin[7],HIGH);
    delay(pause);
    count++;
  }
  count = 0;    
}

