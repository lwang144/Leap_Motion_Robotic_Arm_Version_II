#include<Servo.h>
#include <Wire.h> 
//#include <LiquidCrystal_I2C.h>
//LiquidCrystal_I2C lcd(0x3f,16,2); 

Servo myservo1;      //defien servo 1 
Servo myservo2;      //
Servo myservo3;      //
Servo myservo4;      //
Servo myservo5;      //
Servo myservo6;      //

int a=90,b=0,c=70,d=0,e=100,f=20;   //define servo initial position

void setup() {
  Serial.begin(9600);
  //lcd.init();
  //lcd.backlight(); 
  myservo1.attach(7);         //1    Base Rotation   a
  myservo2.attach(8);         //2    Paw open and close   b
  myservo3.attach(9);         //3    Big Arm       c
  myservo4.attach(10);        //4    Big Arm Joint   d
  myservo5.attach(11);        //5    Small Arm Joint   e
  myservo6.attach(12);        //6    Hand Rotation     f

}


void loop() 
{
  while(Serial.available())
  { 
    char data=Serial.read();
    if(data=='%')
    {
      a=Serial.read();
      b=Serial.read();
      c=Serial.read(); 
      d=Serial.read();
      e=Serial.read();
      f=Serial.read();
      if(Serial.read() == '\n'){  
        break;
      }
    } 
  }
  //show_data();
  myservo1.write(a);     //Base Rotation
  myservo2.write(b);     //Paw open and close
  myservo3.write(c);     //Big Arm
  myservo4.write(d);     //Big Arm Joint
  myservo5.write(e);     //Small Arm Joint
  myservo6.write(f);     //Hand Rotation
  delay(60);    

 }

/* void show_data()   //LCD1602
 {
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("x=");
    lcd.print(a);
    lcd.setCursor(6,0);
    lcd.print("y=");
    lcd.print(b);
    lcd.setCursor(0,1);
    lcd.print("z=");
    lcd.print(c);  
    lcd.setCursor(6,1);
    lcd.print("distance=");
    lcd.print(d); 
 }
 */
