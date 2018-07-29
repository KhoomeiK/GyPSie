#include <VirtualWire.h>

void setup()
{
  Serial.begin(115200);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  digitalWrite(4, HIGH);

  
  vw_setup(2000);
  vw_set_tx_pin(5);
  vw_set_ptt_pin(2);
}

void loop()
{
  if (Serial.available())
  {
    int i = Serial.read();
    if (i==0)
      {
        while(Serial.available()<=0)
        {
          analogWrite(3,200);
          delay(100);
          analogWrite(3,0);
          delay(100);
        }
      }
      else if (i==1)
      {
        while(Serial.available()<=0)
        {
          analogWrite(3,200);
          delay(200);
          analogWrite(3,0);
          delay(400);
        }
      }
      else if (i==2)
      {
        while(Serial.available()<=0)
        {
          analogWrite(3,200);
          delay(200);
          analogWrite(3,0);
          delay(700);
        }
      }
      else if (i==3)
      {
        while(Serial.available()<=0)
        {
          analogWrite(3,200);
          delay(200);
          analogWrite(3,0);
          delay(1000);
        }
      }
      else if (i==4)
      {
        while(Serial.available()<=0)
        {
          analogWrite(3,200);
          delay(200);
          analogWrite(3,0);
          delay(1300);
        }
      }
      else if (i==15) //STOP function
      {
        while(Serial.available()<=0)
        {f
          analogWrite(3,0);
        }
      }
      else if (i==17) //CONT function
      {
        while(Serial.available()<=0)
        {
          analogWrite(3,200);
        }
      }
      else if (i==18) //CONT function
      {
      char c[4] = {'9','8','7','6'};
      vw_send((uint8_t *)c, 4);
      vw_wait_tx();
      }
    else if (i == 100)
    {
      char c[4] = {'9','8','7','0'};
      vw_send((uint8_t *)c, 4);
      vw_wait_tx();
    }
    else if (i == 101)
    {
      char c[4] = {'9','8','7','1'};
      vw_send((uint8_t *)c, 4);
      vw_wait_tx();
    }
    else if (i == 102)
    {
      char c[4] = {'9','8','7','2'};
      vw_send((uint8_t *)c, 4);
      vw_wait_tx();
    }
    else if (i == 103)
    {
      char c[4] = {'9','8','7','3'};
      vw_send((uint8_t *)c, 4);
      vw_wait_tx();
    }
    else if (i == 104)
    {
      char c[4] = {'9','8','7','4'};
      vw_send((uint8_t *)c, 4);
      vw_wait_tx();
    }
    else if (i == 51)
    {
      char c[4] = {'9','8','7','5'};
      vw_send((uint8_t *)c, 4);
      vw_wait_tx();
    }
  }
}

