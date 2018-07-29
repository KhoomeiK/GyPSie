#include <VirtualWire.h>

void setup() {
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  digitalWrite(4, HIGH);
  //  Serial.begin(115200);
  Serial.begin(9600);

  vw_setup(2000);
  vw_set_rx_pin(5);
  vw_set_tx_pin(8);
  vw_rx_start();
}

void loop() { //REMEMBER SEND MESSAGE TWICE
  uint8_t buflen = VW_MAX_MESSAGE_LEN;
  uint8_t buf[buflen];

  if (vw_get_message(buf, & buflen))
    for (int i = 0; i < buflen; i++) {
      Serial.println(buf[i]);
      switch (buf[i]) {
      case 48:
        while (!vw_have_message())
          vib(100);
        break;
      case 49:
        while (!vw_have_message())
          vib(400);
        break;
      case 50:
        while (!vw_have_message())
          vib(700);
        break;
      case 51:
        while (!vw_have_message())
          vib(1000);
        break;
      case 52:
        while (!vw_have_message())
          vib(1300);
        break;
      case 53:
        while (!vw_have_message())
          analogWrite(3, 0);
        break;
      case 54:
        while (!vw_have_message())
          analogWrite(3, 200);
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
