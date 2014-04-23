#include "Tlc5940.h"
#include "tlc_fades.h"

#define LED_BASE 20
#define LED_ON 4095
#define MOTOR_PIN2 5
#define MOTOR_PIN3 6
#define MOTOR_PIN4 7
#define CW -1 // CLOCKWISE
#define CCW 1 // COUNTER CLOCKWISE
#define STOP 0 // STOPED
#define LED_TIMEOUT 2000 //Miliseconds

int old_val0 = LOW;
int old_val1 = LOW;
int old_val2 = LOW;

int last_edge0 = LOW;
int last_edge1 = LOW;
int last_edge2 = LOW;

int direction = STOP;
int old_direction = STOP;

unsigned long last_ms = 0;
bool timeout = true;

TLC_CHANNEL_TYPE channel;

int get_move(void)
{
  /*
  Based in HDDJ code from:
  http://www.instructables.com/id/HDDJ-Turning-an-old-hard-disk-drive-into-a-rotary/?ALLSTEPS
  Some modifications by: Sergio Cioban Filho <cioban@gmail.com>
  */
  bool val0 = digitalRead(MOTOR_PIN2);
  bool val1 = digitalRead(MOTOR_PIN3);
  bool val2 = digitalRead(MOTOR_PIN4);
  int move_direction = STOP;

  if(val0 && !old_val0)
  {
    if(last_edge0 == 5 && last_edge1 == 4 && last_edge2 == 3)
    {
      move_direction = CCW;
    }
    else if(last_edge0 == 1 && last_edge1 == 2 && last_edge2 == 3)
    {
      move_direction = CW;
    }
    old_val0 = val0;
    last_edge2 = last_edge1;
    last_edge1 = last_edge0;
    last_edge0 = 0;
  }
  else if(!val2 && old_val2)
  {
    if(last_edge0 == 0 && last_edge1 == 5 && last_edge2 == 4)
    {
      move_direction = CCW;
    }
    else if(last_edge0 == 2 && last_edge1 == 3 && last_edge2 == 4)
    {
      move_direction = CW;
		}
    old_val2 = val2;
    last_edge2 = last_edge1;
    last_edge1 = last_edge0;
    last_edge0 = 1;
  }
  else if(val1 && !old_val1)
  {
    if(last_edge0 == 1 && last_edge1 == 0 && last_edge2 == 5)
    {
      move_direction = CCW;
    }
    else if(last_edge0 == 3 && last_edge1 == 4 && last_edge2 == 5)
    {
      move_direction = CW;
    }
    old_val1 = val1;
    last_edge2 = last_edge1;
    last_edge1 = last_edge0;
    last_edge0 = 2;
  }
  else if(!val0 && old_val0)
  {
    if(last_edge0 == 2 && last_edge1 == 1 && last_edge2 == 0)
    {
      move_direction = CCW;
    }
    else if(last_edge0 == 4 && last_edge1 == 5 && last_edge2 == 0)
    {
      move_direction = CW;
    }
    old_val0 = val0;
    last_edge2 = last_edge1;
    last_edge1 = last_edge0;
    last_edge0 = 3;
  }
  else if(val2 && !old_val2)
  {
    if(last_edge0 == 3 && last_edge1 == 2 && last_edge2 == 1)
    {
      move_direction = CCW;
		}
    else if(last_edge0 == 5 && last_edge1 == 0 && last_edge2 == 1)
    {
      move_direction = CW;
    }
    old_val2 = val2;
    last_edge2 = last_edge1;
    last_edge1 = last_edge0;
    last_edge0 = 4;
  }
  else if(!val1 && old_val1)
  {
    if(last_edge0 == 4 && last_edge1 == 3 && last_edge2 == 2)
    {
      move_direction = CCW;
    }
    else if(last_edge0 == 0 && last_edge1 == 1 && last_edge1 == 2)
    {
      move_direction = CW;
    }
    old_val1 = val1;
    last_edge2 = last_edge1;
    last_edge1 = last_edge0;
    last_edge0 = 5;
	}
  return move_direction;
}


void base_on()
{
  TLC_CHANNEL_TYPE base_channel;
  for (base_channel=0; base_channel<16; base_channel++)
  {
    Tlc.set(base_channel, LED_BASE);
  }
  Tlc.update();
}

void led_rotate(int direction)
{
  int tmp_channel = channel + direction;

  Tlc.set(channel, LED_BASE);

  if (tmp_channel < 0)
  {
    channel = 15;
  }
  else if (tmp_channel > 15)
  {
    channel = 0;
  }
  else
  {
    channel = (TLC_CHANNEL_TYPE)tmp_channel;
  }

  Tlc.set(channel, LED_ON);
  Tlc.update();
}

void setup() {
  Serial.begin(9600);
  Serial.println("|==============================");
  Serial.println("| HDD motor reader");
  Serial.println("|==============================");

  pinMode(MOTOR_PIN2, INPUT);
  pinMode(MOTOR_PIN3, INPUT);
  pinMode(MOTOR_PIN4, INPUT);

  Tlc.init();
  delay(10);
  channel = 3;
  Tlc.clear();
  base_on();
}

void loop() {
  unsigned long ms = millis();

  direction = get_move();

  if(ms - last_ms > LED_TIMEOUT)
  {
    base_on();
    last_ms = ms;
    timeout = true;
  }

  if (direction == STOP)
    return;

  if (timeout)
  {
    led_rotate(0);
    timeout = false;
  }
  else
  {
    led_rotate(direction);
  }

  if (direction == CW || direction == CCW)
  {
    last_ms = ms; // Reset LED timeout
  }
  old_direction = direction;



  if (direction == CW)
  {
    Serial.println("<");
  }
  else if (direction == CCW)
  {
    Serial.println(">");
  }

  return;
}
