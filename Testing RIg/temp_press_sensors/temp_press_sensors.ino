#include <SPI.h>
#include <SdFat.h>

const int chipSelect = 10;
SdFat32 sd;
File32 myFile;

void setup() {
    Serial.begin(9600);
    while(!Serial);

    pinMode(chipSelect, OUTPUT);
    digitalWrite(chipSelect, HIGH);

    if (!sd.begin(chipSelect, SD_SCK_MHZ(1))) {
        Serial.println("SD initialization failed");
        sd.initErrorPrint(&Serial);
        return;
    }
    Serial.println("SD initialization passed");

    //Change file name in sd.open every test
    myFile = sd.open("wettest1.csv", FILE_WRITE);
    if (myFile) {
        myFile.println("Timestamp,TempValue1,PressureValue1,TempValue2,PressureValue2");
        myFile.close();
        Serial.println("Header written successfully");
    } else {
        Serial.println("Error opening data.csv");
    }
}

void loop() {
    float tempData1 = (analogRead(A0) / 1024.0) * 3300.0;
    float tempData2 = (analogRead(A1) / 1024.0) * 3300.0;
    float pressureData1 = (analogRead(A2) / 1024.0) * 3300.0;
    float pressureData2 = (analogRead(A3) / 1024.0) * 3300.0;


    //change file name at sd.open after every test




    myFile = sd.open("wettest1.csv", FILE_WRITE);
    if (myFile) {
        myFile.print(millis());
         myFile.print(",");
        myFile.print(tempData1);
        Serial.println(tempData1);
        myFile.print(",");

        myFile.print(pressureData1);
        Serial.println(pressureData1);
        myFile.print(",");
        myFile.print(tempData2);
        Serial.println(tempData2);
        myFile.print(",");
        myFile.println(pressureData2);
        Serial.println(pressureData2);
        myFile.close();
        Serial.println("Data written");
    } else {
        Serial.println("Error opening data.csv");
    }

    delay(500);
}
