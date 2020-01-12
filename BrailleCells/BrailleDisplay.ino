#include <Wire.h>
#include <String.h>
#include <Braille.h>

#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);
String arr[]={"001111", "001010", "000101001100","001111", "001010", "001010", "001010"};



void setup() {
  // put your setup code here, to run once:
  lcd.begin();
  lcd.setBacklight((uint8_t)1);
  lcd.setCursor(0,1);
  lcd.clear();
  delay(1000);

  //cell one
  pinMode(52, OUTPUT);
  pinMode(50,OUTPUT);
  pinMode(48,OUTPUT);
  pinMode(46, OUTPUT);
  pinMode(44, OUTPUT);
  pinMode(42, OUTPUT);

  //cell two
  pinMode(40, OUTPUT);
  pinMode(38, OUTPUT);
  pinMode(36, OUTPUT);
  pinMode(34, OUTPUT);
  pinMode(32, OUTPUT);
  pinMode(30, OUTPUT);
}



void loop() {
  // put your main code here, to run repeatedly:
  
  for(int i = 0; i < sizeof(arr)/sizeof(arr[0]); i++){
    lcd.print(arr[i]);

    if(arr[i] == divide){
        printDivide();
        delay(2000);
      }
    if(arr[i] == ind){
        printNumIndicator();
        delay(2000);
      }
    if(arr[i] == zero){
        printZero();
        delay(2000);
      }
    if(arr[i] == one){
      printOne();
      delay(2000);
      }
    if(arr[i] == two){
      printTwo();
      delay(2000);
      }
     if(arr[i] == three){
      printThree();
      delay(2000);
      }
    if(arr[i] == four){
      printFour();
      delay(2000);
      }

    if(arr[i] == five){
      printFive();
      delay(2000);
      }

    if(arr[i] == six){
      printSix();
      delay(2000);
      }

    if(arr[i] == seven){
      printSeven();
      delay(2000);
      }
    if(arr[i] == eight){
      printEight();
      delay(2000);
      }
    if(arr[i] == nine){
      printNine();
      delay(2000);
      }
      lcd.clear();
      
    }
  
}

//IMPORTANT! CELL TWO is using TIP120 Transistors THAT FLIP THE SIGNAL 
// I.E. HIGH = LOW AND LOW = HIGH

void printNumIndicator(){
    digitalWrite(52, HIGH);
    digitalWrite(50, LOW);
    digitalWrite(48, LOW);
    digitalWrite(46, HIGH);
    digitalWrite(44, HIGH);
    digitalWrite(42, HIGH);

    //cell two
    digitalWrite(40, LOW);
    digitalWrite(38, HIGH);
    digitalWrite(36, HIGH);
    digitalWrite(34, LOW);
    digitalWrite(32, LOW);
    digitalWrite(30, LOW);
  }

void printZero(){
    digitalWrite(52, HIGH);
    digitalWrite(50, LOW);
    digitalWrite(48, LOW);
    digitalWrite(46, HIGH);
    digitalWrite(44, HIGH);
    digitalWrite(42, LOW);

    //cell two
    digitalWrite(40, LOW);
    digitalWrite(38, HIGH);
    digitalWrite(36, HIGH);
    digitalWrite(34, LOW);
    digitalWrite(32, LOW);
    digitalWrite(30, HIGH);
  }

void printOne(){
      digitalWrite(52, LOW);
      digitalWrite(50, HIGH);
      digitalWrite(48, LOW);
      digitalWrite(46, LOW);
      digitalWrite(44, LOW);
      digitalWrite(42, LOW);

      //cell two
      digitalWrite(40, HIGH);
      digitalWrite(38, LOW);
      digitalWrite(36, HIGH);
      digitalWrite(34, HIGH);
      digitalWrite(32, HIGH);
      digitalWrite(30, HIGH);
  }

void printTwo(){
      digitalWrite(52, HIGH);
      digitalWrite(50, HIGH);
      digitalWrite(48, LOW);
      digitalWrite(46, LOW);
      digitalWrite(44, LOW);
      digitalWrite(42, LOW);

      //cell two
      digitalWrite(40, LOW);
      digitalWrite(38, LOW);
      digitalWrite(36, HIGH);
      digitalWrite(34, HIGH);
      digitalWrite(32, HIGH);
      digitalWrite(30, HIGH);
  }

 void printThree(){
      digitalWrite(52, LOW);
      digitalWrite(50, HIGH);
      digitalWrite(48, LOW);
      digitalWrite(46, LOW);
      digitalWrite(44, HIGH);
      digitalWrite(42, LOW);

      //cell two
      digitalWrite(40, HIGH);
      digitalWrite(38, LOW);
      digitalWrite(36, HIGH);
      digitalWrite(34, HIGH);
      digitalWrite(32, LOW);
      digitalWrite(30, HIGH);
  
  }

 void printFour(){
      digitalWrite(52, LOW);
      digitalWrite(50, HIGH);
      digitalWrite(48, LOW);
      digitalWrite(46, HIGH);
      digitalWrite(44, HIGH);
      digitalWrite(42, LOW);

      //cell two
      digitalWrite(40, HIGH);
      digitalWrite(38, LOW);
      digitalWrite(36, HIGH);
      digitalWrite(34, LOW);
      digitalWrite(32, LOW);
      digitalWrite(30, HIGH);
  }

void printFive(){
      digitalWrite(52, LOW);
      digitalWrite(50, HIGH);
      digitalWrite(48, LOW);
      digitalWrite(46, HIGH);
      digitalWrite(44, LOW);
      digitalWrite(42, LOW);

      //cell two
      digitalWrite(40, HIGH);
      digitalWrite(38, LOW);
      digitalWrite(36, HIGH);
      digitalWrite(34, LOW);
      digitalWrite(32, HIGH);
      digitalWrite(30, HIGH);
  }

 void printSix(){
      digitalWrite(52, HIGH);
      digitalWrite(50, HIGH);
      digitalWrite(48, LOW);
      digitalWrite(46, LOW);
      digitalWrite(44, HIGH);
      digitalWrite(42, LOW);

      //cell two
      digitalWrite(40, LOW);
      digitalWrite(38, LOW);
      digitalWrite(36, HIGH);
      digitalWrite(34, HIGH);
      digitalWrite(32, LOW);
      digitalWrite(30, HIGH);
  }

 void printSeven(){
      digitalWrite(52, HIGH);
      digitalWrite(50, HIGH);
      digitalWrite(48, LOW);
      digitalWrite(46, HIGH);
      digitalWrite(44, HIGH);
      digitalWrite(42, LOW);

      //cell two
      digitalWrite(40, LOW);
      digitalWrite(38, LOW);
      digitalWrite(36, HIGH);
      digitalWrite(34, LOW);
      digitalWrite(32, LOW);
      digitalWrite(30, HIGH);
  }

 void printEight(){
      digitalWrite(52, HIGH);
      digitalWrite(50, HIGH);
      digitalWrite(48, LOW);
      digitalWrite(46, HIGH);
      digitalWrite(44, LOW);
      digitalWrite(42, LOW);

      //cell two
      digitalWrite(40, LOW);
      digitalWrite(38, LOW);
      digitalWrite(36, HIGH);
      digitalWrite(34, LOW);
      digitalWrite(32, HIGH);
      digitalWrite(30, HIGH);
  }

 void printNine(){
      digitalWrite(52, HIGH);
      digitalWrite(50, LOW);
      digitalWrite(48, LOW);
      digitalWrite(46, LOW);
      digitalWrite(44, HIGH);
      digitalWrite(42, LOW);

      //cell two
      digitalWrite(40, LOW);
      digitalWrite(38, HIGH);
      digitalWrite(36, HIGH);
      digitalWrite(34, HIGH);
      digitalWrite(32, LOW);
      digitalWrite(30, HIGH);
  }
 void printDivide(){
      digitalWrite(52, LOW);
      digitalWrite(50, LOW);
      digitalWrite(48, LOW);
      digitalWrite(46, HIGH);
      digitalWrite(44, LOW);
      digitalWrite(42, HIGH);

      //cell two
      digitalWrite(40, LOW);
      digitalWrite(38, HIGH);
      digitalWrite(36, HIGH);
      digitalWrite(34, HIGH);
      digitalWrite(32, HIGH);
      digitalWrite(30, LOW);
    
  }
