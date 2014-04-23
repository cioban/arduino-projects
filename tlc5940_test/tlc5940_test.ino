
#include "Tlc5940.h"
#include "tlc_fades.h"

TLC_CHANNEL_TYPE channel;


void base_on()
{
  for (channel=0; channel<16; channel++)
  {
    Tlc.set(channel, 100);    
  }
  Tlc.update();
  delay(500);
}


void setup()
{
  Tlc.init();
  delay(100);
  channel = 0;
  Tlc.clear();
  base_on();
}


void loop()
{
   
  for (channel=0; channel<16; channel++)
  {
    Tlc.set(channel, 4095);
    
    if (channel > 0)
    {
      Tlc.set(channel - 1, 500);
    }
      
    Tlc.update();
    delay(50);
  }
  Tlc.set(15, 500);
  Tlc.update();
  delay(50);
  
/*  
  //if (tlc_fadeBufferSize < TLC_FADE_BUFFER_LENGTH - 2) {
  //for (channel=0; channel<16; channel++){
    if (!tlc_isFading(channel))
    {
      uint32_t start_time = millis();
      uint32_t end_time = start_time + 2000;
      //delay(500);
      tlc_addFade(channel, 200, 4095, start_time, end_time);
      tlc_addFade(channel, 4095, 200, end_time+20, end_time + 2000);
    }
   //}
  //}
  channel++;
  if (channel > 15)
  {
    channel = 0;
  }
  tlc_updateFades();
  */
  
  /*
  Tlc.set(0, 500);
  Tlc.update();
  delay(1000);
  
  Tlc.set(0, 1500);
  Tlc.update();
  delay(500);
  
  Tlc.set(0, 3000);
  Tlc.update();
  delay(500);
  
  Tlc.set(0, 4095);
  Tlc.update();
  delay(5000);
  */ 
}
