#include <VirtualWire.h>

void setup() {
  Serial.begin(115200);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  digitalWrite(4, HIGH);

  vw_setup(2000);
  vw_set_tx_pin(5);
  vw_set_ptt_pin(2);
}

void loop() {
  if (Serial.available()) {
    int i = Serial.read();
    char c[4] = {
      '9',
      '8',
      '7',
      '5'
    };
    switch (i) {
    case 0:
      while (Serial.available() <= 0)
        vib(100);
      break;
    case 1:
      while (Serial.available() <= 0)
        vib(400);
      break;
    case 2:
      while (Serial.available() <= 0)
        vib(700);
      break;
    case 3:
      while (Serial.available() <= 0)
        vib(1000);
      break;
    case 4:
      while (Serial.available() <= 0)
        vib(1300);
      break;
    case 15:
      while (Serial.available() <= 0)
        analogWrite(3, 0);
      break;
    case 17:
      while (Serial.available() <= 0)
        analogWrite(3, 200);
      break;
    case 100:
      c[3] = '0';
      vw_send((uint8_t * ) c, 4);
      vw_wait_tx();
      break;
    case 101:
      c[3] = '1';
      vw_send((uint8_t * ) c, 4);
      vw_wait_tx();
      break;
    case 102:
      c[3] = '2';
      vw_send((uint8_t * ) c, 4);
      vw_wait_tx();
      break;
    case 103:
      c[3] = '3';
      vw_send((uint8_t * ) c, 4);
      vw_wait_tx();
      break;
    case 104:
      c[3] = '4';
      vw_send((uint8_t * ) c, 4);
      vw_wait_tx();
      break;
    case 51:
      c[3] = '5';
      vw_send((uint8_t * ) c, 4);
      vw_wait_tx();
      break;
    case 18:
      c[3] = '6';
      vw_send((uint8_t * ) c, 4);
      vw_wait_tx();
      break;
    }
  }
}

void vib(int t) {
  analogWrite(3, 200);
  delay(200);
  analogWrite(3, 0);
  delay(t);
}
