#include <LiquidCrystal.h>
#include <LCDKeypad.h>

#define minimum 1
#define maximum 1000

LCDKeypad lcd;

void setup()
{
  lcd.begin(16, 2);
  lcd.clear();
}

void loop()
{
  int bottom=minimum, top=maximum;
  int tries=0;
  int guess, buttonPressed;

  lcd.clear();
  lcd.print("Think of a #");
  lcd.setCursor(0,1);
  lcd.print("from ");
  lcd.print(minimum,DEC);
  lcd.print(" to ");
  lcd.print(maximum,DEC);
  lcd.print(" ");
  waitButton();
  delay(200);
  waitReleaseButton();
  do
  {
    lcd.clear();
    guess = bottom + (top - bottom) / 2;
    tries++;

    lcd.print("Is the # ");
    lcd.print(guess, DEC);
    lcd.print("?");
    lcd.setCursor(0,1);
    lcd.write('$');
    lcd.write(' ');
    lcd.write('<');
    lcd.write(' ');
    lcd.write('>');
    lcd.write(' ');
    do
    {
      buttonPressed=waitButton();
    }
    while(!(buttonPressed==KEYPAD_SELECT || buttonPressed==KEYPAD_RIGHT || buttonPressed==KEYPAD_LEFT));
    waitReleaseButton();
    if (buttonPressed==KEYPAD_RIGHT)
    {
      bottom=constrain(guess+1,minimum,top);
    }
    else if (buttonPressed==KEYPAD_LEFT)
    {
      top=constrain(guess-1,bottom,maximum);
    }
  }
  while (buttonPressed!=KEYPAD_SELECT && top!=bottom);
  lcd.clear();
  if (top==bottom)
  {
    lcd.print("It must be ");
    guess=top;
  }
  else
  {
    lcd.print("Your # is ");
  }
  lcd.print(guess,DEC);
  lcd.print("!");
  lcd.setCursor(0,1);
  lcd.print(tries,DEC);
  lcd.print(" tries");
  waitButton();  
  waitReleaseButton();  
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

void waitReleaseButton()
{
  delay(50);
  while(lcd.button()!=KEYPAD_NONE)
  {
  }
  delay(50);
}
