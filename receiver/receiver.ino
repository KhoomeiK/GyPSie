#include <VirtualWire.h>
int j = 0;

void setup() {
    pinMode(9, OUTPUT);
    pinMode(10, OUTPUT);
    digitalWrite(10, HIGH);
    //  Serial.begin(115200);
    Serial.begin(9600);

    vw_setup(2000);
    vw_set_rx_pin(11);
    vw_set_tx_pin(8);
    vw_rx_start();
}

void loop() { //REMEMBER SEND MESSAGE TWICE
    uint8_t buflen = VW_MAX_MESSAGE_LEN;
    uint8_t buf[buflen];

    int l = 0;

    if (vw_get_message(buf, & buflen))
        for (int i = 0; i < buflen; i++) {
            Serial.println(buf[i]);
            switch(buf[i]) {
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
                    analogWrite(9, 0);
                break;
              case 54:
                while (!vw_have_message())
                    analogWrite(9, 200);
                break;
            }
        }
}

void vib(int t) {
  analogWrite(9, 200);
  delay(200);
  analogWrite(9, 0);
  delay(t);
}
