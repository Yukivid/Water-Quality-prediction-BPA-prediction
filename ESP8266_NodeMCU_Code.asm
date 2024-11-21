
#include <Arduino.h>
#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif

#include <WiFiClient.h>  //Client wifi connection library

#include <ThingSpeak.h>  //ThingSpeak Cloud library

#define WIFI_SSID "TP-Link_8E98"
#define WIFI_PASSWORD "86427920"

WiFiClient client;  //client configuration

unsigned long myChannelNumber = 2689233;  //Thingspeak channel number
const char * myWriteAPIKey = "6UZ2AB2K7KW752TW";  //Thingspeak Write API key

String readstring = "";

String hum;
String temp;
String wattemp;
String tds;
String turb;
String phval;

int ind1; // , locations
int ind2;
int ind3;
int ind4;
int ind5;
int ind6;

void setup()
{
  Serial.begin(9600);
  Serial.println();

  Serial.print("Connecting to AP");

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(200);
  }

  Serial.println("");
  Serial.println("WiFi connected.");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  ThingSpeak.begin(client);
}

void loop()
{
  readstring = "";  //Reset the variable
 
  while (Serial.available())
  {  //Check if there is an available byte to read
  delay(10); //Delay added to make thing stable
  char c = Serial.read(); //Conduct a serial read
  if (c == '#') {break;} //Exit the loop when the # is detected after the word
  readstring += c; //build the string
  }

  if (readstring.length() > 0)
  {
    Serial.println(readstring);

    ind1  = readstring.indexOf(',');
    hum  = readstring.substring(0, ind1);
    ind2  = readstring.indexOf(',', ind1+1);
    temp  = readstring.substring(ind1+1, ind2);
    ind3  = readstring.indexOf(',', ind2+1);//finds location of second ,
    wattemp = readstring.substring(ind2+1, ind3);
    ind4  = readstring.indexOf(',', ind3+1);//finds location of second ,
    tds  = readstring.substring(ind3+1, ind4);
    ind5  = readstring.indexOf(',', ind4+1);//finds location of second ,
    turb  = readstring.substring(ind4+1, ind5);
    ind6  = readstring.indexOf(',', ind5+1);//finds location of second ,
    phval  = readstring.substring(ind5+1);//captures remain part of data after last ,

    Serial.print("Humidity: ");
    Serial.println(hum);
    Serial.print("Temperature: ");
    Serial.println(temp);
    Serial.print("Water Temperature: ");
    Serial.println(wattemp);
    Serial.print("TDS: ");
    Serial.println(tds);
    Serial.print("Turbidity: ");
    Serial.println(turb);  
    Serial.print("PH: ");
    Serial.println(phval);      
     
    ThingSpeak.setField(1, hum);
    ThingSpeak.setField(2, temp);
    ThingSpeak.setField(3, wattemp);
    ThingSpeak.setField(4, tds);
    ThingSpeak.setField(5, turb);
    ThingSpeak.setField(6, phval);
   
    ThingSpeak.writeFields(myChannelNumber, myWriteAPIKey);  
    delay(1000);
  }
}
