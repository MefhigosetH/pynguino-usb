/*----------------------------------------------------- 
Author: Victor Villarreal <mefhigoseth@gmail.com>
Date: Fri Jan 31 02:02:04 2014
Description: Pynguino-USB
Controlling Pinguino 2550 board through PyUSB.
Tested and compiled over PinguinoIDE X.4 rev.962
Based on the great work of Yeison Cardona --<yeison.eng@gmail.com>
-----------------------------------------------------*/

u8 receivedByte;
char buffer[10];
char response[10]="$";
int lecture;

void setup() {
    pinMode(USERLED,OUTPUT);
    digitalWrite(USERLED,HIGH);
}

void loop() {
    receivedByte = 0;
    
    // Vigilo USB...
    if(BULK.available()){
        receivedByte = BULK.read(buffer);
        buffer[receivedByte] = 0;

        // Toggle()
        if(buffer[0]=='T'){
            toggle(buffer[1]-48);
            BULK.write(buffer,receivedByte);
        }
        // Digital...
        else if(buffer[0]=='D') {
            // Write()
            if(buffer[1]=='W') {
                digitalWrite(buffer[2]-48,buffer[3]-48);
                BULK.write(buffer,receivedByte);
            }
        }
        // Analog...
        else if(buffer[0]=='A') {
            // Read()
            if(buffer[1]=='R') {
                lecture = analogRead(buffer[2]-48);
                // FIXME:
                // Reducing the read range with map () lose accuracy!
                response[0] = map(lecture, 0, 1023, 0, 255);
                BULK.write(response,1);
            }
        }
        // PinMode()
        else if(buffer[0]=='P') {
            pinMode(buffer[1]-48,buffer[2]-48);
            BULK.write(buffer,receivedByte);
        }
        // Echo response...
        else {
            BULK.write(buffer,receivedByte);
        }
    }
}