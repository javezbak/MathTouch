#include <memdebug.h>

class BrailleCell
{
  public:
    //constructors
    BrailleCell(int _pinAndOutput[12]);
    BrailleCell();

    //display on the hardware device
    void displayToSolenoids();

    //declares the output mode of the solenoids
    void setOutput(int _output[6]);
    void clearOutput();
    
  private:
    //pin number and corresponding HIGH/LOW setting
    int pinAndOutput[12];
};

//constructor
BrailleCell::BrailleCell(int _pinAndOutput[12])
{
  for(int i = 0; i < 12; ++i)
  {
    pinAndOutput[i] = _pinAndOutput[i];
    if(i % 2 == 0)
    {
      pinMode(pinAndOutput[i], OUTPUT);
      digitalWrite(pinAndOutput[i], LOW);
    }
  }
}

void BrailleCell::setOutput(int _output[6])
{
  //for loop starts at 1 and increments by 2 because output
  //is every other array element, pin numbers take the others  
  int outputCounter = 0;
  for(int i = 1; i < 12; i+=2)
  { 
    pinAndOutput[i] = _output[outputCounter++];
    //Serial.print(F("Pin #"));
    //Serial.print(pinAndOutput[i]);
    //Serial.print(F(", Set to: "));
    //Serial.println(_output[outputCounter-1]);
  }
}

BrailleCell::BrailleCell(){}

void BrailleCell::displayToSolenoids()
{
  for(int i = 0; i < 12; i+=2)
  {
    digitalWrite(pinAndOutput[i], pinAndOutput[i+1]);
    //Serial.print(F("Pin #"));
    //Serial.print(pinAndOutput[i]);
    //Serial.print(F(", Set to: "));
    //Serial.println(pinAndOutput[i+1]);
  }
}

void BrailleCell::clearOutput()
{
  int _output[6] = {1, 1, 1, 1, 1, 1};
  setOutput(_output);
}

#include <SPI.h>
#include "Adafruit_BLE_UART.h"

// Connect CLK/MISO/MOSI to hardware SPI
#define ADAFRUITBLE_REQ 45
#define ADAFRUITBLE_RDY 21    
#define ADAFRUITBLE_RST 49

#define NUM_CELLS 5 //number of braille cells on system
#define DISPLAY_TIME 5000 //milliseconds that solenoids are up

Adafruit_BLE_UART BTLEserial = Adafruit_BLE_UART(ADAFRUITBLE_REQ, ADAFRUITBLE_RDY, ADAFRUITBLE_RST);

//entire braille display
BrailleCell cells[NUM_CELLS];

//boolean setUpHit = false;

void setup()
{
  
  Serial.begin(9600);
  BTLEserial.begin();

  //if(setUpHit == false)
  //{
    //setUpHit = true;
    //Serial.println("First time hitting setup");
  //}
  //else
    //Serial.println("Have hit setup before. ");

  //Serial.println(F("STARTING SETUP"));

                     //pin number, and then 1 for LOW or 0 for HIGH
  int cellOneData[] = {A15, 1, 
                       A10, 1, 
                       A8, 1, 
                       A14, 1, 
                       A9, 1, 
                       A12, 1};
  BrailleCell cellOne = BrailleCell(cellOneData);
  cells[0] = cellOne;
  cells[0].displayToSolenoids();
  
  int cellTwoData[] = {A13, 1, 
                       34, 1, 
                       30, 1, 
                       A11, 1, 
                       36, 1, 
                       28, 1};
  BrailleCell cellTwo = BrailleCell(cellTwoData);
  cells[1] = cellTwo;
  cells[1].displayToSolenoids();
  
  int cellThreeData[] = {32, 1, 
                       22, 1, 
                       9, 1, 
                       26, 1, 
                       24, 1, 
                       7, 1};
  BrailleCell cellThree = BrailleCell(cellThreeData);
  cells[2] = cellThree;
  cells[2].displayToSolenoids();
  
  int cellFourData[] = {4, 1, 
                       8, 1, 
                       5, 1, 
                       2, 1, 
                       3, 1, 
                       6, 1};
  BrailleCell cellFour = BrailleCell(cellFourData);
  cells[3] = cellFour;
  cells[3].displayToSolenoids();
  
  int cellFiveData[] = {A0, 1, 
                       A6, 1, 
                       A5, 1, 
                       A4, 1, 
                       A7, 1, 
                       A5, 1};
  BrailleCell cellFive = BrailleCell(cellFiveData);
  cells[4] = cellFive;
  cells[4].displayToSolenoids();

  //Serial.print(F("The amount of free memory is: "));
  //Serial.println(getFreeMemory());
  Serial.println("2SETUP");
  Serial.println();
}

aci_evt_opcode_t laststatus = ACI_EVT_DISCONNECTED;
String currCellData = "";
int currCellNum = 0;
void loop()
{
  // Tell the nRF8001 to do whatever it should be working on.
  BTLEserial.pollACI();

  // Ask what is our current status
  aci_evt_opcode_t status = BTLEserial.getState();
  
  // If the status changed
  if (status != laststatus)
  {
    switch(status)
    {
      case ACI_EVT_DEVICE_STARTED:
        Serial.println(F("Advertising started"));
        break;
      case ACI_EVT_CONNECTED:
        Serial.println(F("Connected!"));
        break;
      case ACI_EVT_DISCONNECTED:
        Serial.println(F("Disconnected or advertising timed out"));
        break;
      default:
        break;
    }
    // OK set the last status change to this one
    laststatus = status;
  }

  if (status == ACI_EVT_CONNECTED)
  {
    // Lets see if there's any data for us!
    if (BTLEserial.available())
    {
      Serial.print(F("* "));
      Serial.print(BTLEserial.available());
      Serial.println(F(" bytes available from BTLE"));
    }
    
    //While data is available, read in characters
    
    while (BTLEserial.available())
    {
      BTLEserial.pollACI();
      char c = BTLEserial.read();
      currCellData += c;
      
      //end of equation/sequence
      if(c == '~')
      {
        Serial.println(currCellData);
           BTLEserial.pollACI();
          //display entire braille sequence on solenoids
          for(int i = 0; i < NUM_CELLS; ++i)
            cells[i].displayToSolenoids();

          delay(DISPLAY_TIME);
          BTLEserial.pollACI();
          //clear the cells
          for(int i = 0; i < NUM_CELLS; ++i)
          {
            cells[i].clearOutput();
            cells[i].displayToSolenoids();
          }
          
          //reset the cell counter
          currCellNum = 0;
          currCellData ="";

          //Tell the iOS application that we are done
          String s = "*";
          uint8_t sendbuffer[20];
          s.getBytes(sendbuffer, 20);
          char sendbuffersize = min(20, s.length());
          BTLEserial.write(sendbuffer, sendbuffersize);
      }

      //end of character/symbol/number
      else if(c == '^')
      {
        BTLEserial.pollACI();
        for(unsigned int i = 0; i < currCellData.length(); i+=7) //7, not 6, to skip the '^'
        {
          //set output based on the binary string
          //-48 is fastest way to convert from char to int
          int cellData[] = {currCellData[i] - 48,
                             currCellData[i+1] - 48,
                             currCellData[i+2] - 48,
                             currCellData[i+3] - 48,
                             currCellData[i+4] - 48,
                             currCellData[i+5] - 48};
          cells[currCellNum].setOutput(cellData);
          //Serial.print("currCellNum is ");
          //Serial.println(currCellNum);
           Serial.println(currCellData);
          ++currCellNum;
          currCellData ="";
          BTLEserial.pollACI();

          //Serial.print(F("The amount of free memory is: "));
          //Serial.println(getFreeMemory());
        }

       
      }
    }
  }

  delay(100);
}













