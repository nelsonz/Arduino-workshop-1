#include <LiquidCrystal.h>
#include <LCDKeypad.h>

LCDKeypad lcd;

void setup()
{
  lcd.begin(16, 2);
  lcd.clear();
  lcd.print("I am .man");
  lcd.setCursor(0, 1);
  lcd.print("help me escape!");
  delay(5000);
}

void loop()
{
  int buttonPressed;
  int pos[] = {0,0};
  lcd.clear();
  while (true)
  {
    lcd.clear();
    if (pos[0] < 0) pos[0] += 16;
    lcd.setCursor(pos[0], pos[1]);
    lcd.print(".");
    delay(200);
    do
    {
      buttonPressed=waitButton();
    }
    while(!(buttonPressed==KEYPAD_LEFT || buttonPressed==KEYPAD_RIGHT || buttonPressed==KEYPAD_UP || buttonPressed==KEYPAD_DOWN));
    if (buttonPressed==KEYPAD_UP) {
      pos[1] = (pos[1]+1) % 2;
    }
    else if (buttonPressed==KEYPAD_DOWN) {
      pos[1] = (pos[1]-1) % 2;
    }
    else if (buttonPressed==KEYPAD_LEFT) {
      pos[0] = (pos[0]-1) % 16;
    }
    else if (buttonPressed==KEYPAD_RIGHT) {
      pos[0] = (pos[0]+1) % 16;
    }
  }
}
       


void waitReleaseButton()
{
  delay(50);
  while(lcd.button()!=KEYPAD_NONE)
  {
  }
  delay(50);
}



int waitButton()
{
  int buttonPressed; 
  waitReleaseButton;
  lcd.blink();
  while((buttonPressed=lcd.button())==KEYPAD_NONE)
  {
  }
  delay(50);  
  lcd.noBlink();
  return buttonPressed;
}
