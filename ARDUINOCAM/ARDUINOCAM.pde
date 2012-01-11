/* Arduino servo camera listener by Nelson Zhang, 2011
   Takes commands from servo.py
   For use in XinCheJian Kino
   Requires: servo library */

#include <Servo.h> 

// Define servos
Servo servoY;
Servo servoX;

int userInput[3];    // 3byte serial buffer packet (connected to servo.py)
int startbyte;       // start byte var for checking (255 = valid packet)
int servo = 1;       // servo selection (Y=1, X=2)
int pos = 0;         // servo angle in [0, 180] degrees
int i;
 
 
// Attach servos to pins (pin 2 = bottom/Y, pin 3 = top/X)
// Begin 9600 baud serial connection
void setup() 
{ 
  servoY.attach(2);
  servoX.attach(3);
  Serial.begin(9600);
  servoY.write(90);
  servoX.write(145);
} 
 
 
void loop() 
{ 
  // Wait for a 3byte buffer in serial input
  if (Serial.available() > 2) {
    startbyte = Serial.read();
    // If startbyte is 255 (sent from servo.py)
    if (startbyte == 255) {
      // Read next 2 bytes
      for (i=0; i<2; i++) {
        userInput[i] = Serial.read();
      }
      servo = int(userInput[0]);  // 1st byte specifies servo #
      pos = int(userInput[1]);    // 2nd byte specifies angle
      // Check for packet corruption! Don't let position = 255 (startbyte)
      if (pos == 255) { 
        servo = 255;
      }
      // Move servos as specified
      switch (servo) {
        case 2:
          servoY.write(pos);
          break;
        case 3:
          servoX.write(pos);
          break;
      }
    }
  }
    
} 
