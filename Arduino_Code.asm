
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 32 // OLED display height, in pixels

// Declaration for an SSD1306 display connected to I2C (SDA, SCL pins)
#define OLED_RESET -1
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

#include "DHT.h"
#define DHTPIN 12
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

#include <Wire.h>

#include <OneWire.h>
#include <DallasTemperature.h>
// Data wire is plugged into port 2 on the Arduino
#define ONE_WIRE_BUS 10
// Setup a oneWire instance to communicate with any OneWire devices (not just Maxim/Dallas temperature ICs)
OneWire oneWire(ONE_WIRE_BUS);
// Pass our oneWire reference to Dallas Temperature.
DallasTemperature sensors(&oneWire);

#define turbsensor A2
int sensor = 0; // variable for averaging
int n = 25; // number of samples to average
int sensorValue = 0;
float voltage = 0.00;
float turbidity = 0.00;
float Vclear = 2.85; // Output voltage to calibrate (with clear water).

#include <EEPROM.h>
#include "GravityTDS.h"
 
#define TdsSensorPin A3
GravityTDS gravityTds;

float temperature = 25,tdsValue = 0;

int pHSense = A1;
int samples = 10;
float adc_resolution = 1024.0;
float phval;

String readstringdata = "";

float ph(float voltage)
{
  return 11 + ((2.5 - voltage) / 0.18);
}


void setup()
{
  Serial.begin(9600);
 
  sensors.begin();

  dht.begin();

  gravityTds.setPin(TdsSensorPin);
  gravityTds.setAref(5.0);  //reference voltage on ADC, default 5.0V on Arduino UNO
  gravityTds.setAdcRange(1024);  //1024 for 10bit ADC;4096 for 12bit ADC
  gravityTds.begin();  //initialization
   
  if(!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    #ifdef serial
    Serial.println(F("SSD1306 allocation failed"));
    #endif
    for(;;); // Don't proceed, loop forever
  }

  display.clearDisplay();
  display.setTextColor(WHITE);
  display.setTextSize(1);
  display.setCursor(0,0);
  display.print("IoT Water Quality");
  display.display();
  delay(2000); // Pause for 2 seconds
}

void loop()
{
  readstringdata = "";

  display.clearDisplay();
 
  delay(1000);

  /*****DHT11 Environment Temperature and Humidity Sensor*****/
    // Reading temperature or humidity takes about 250 milliseconds!
  // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
  float h = dht.readHumidity();
  // Read temperature as Celsius (the default)
  float t = dht.readTemperature();
  // Read temperature as Fahrenheit (isFahrenheit = true)
  float f = dht.readTemperature(true);

  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t) || isnan(f)) {
    //Serial.println("Failed to read from DHT sensor!");
    return;
  }

  // Compute heat index in Fahrenheit (the default)
  float hif = dht.computeHeatIndex(f, h);
  // Compute heat index in Celsius (isFahreheit = false)
  float hic = dht.computeHeatIndex(t, h, false);

  /*Serial.print("Humidity: ");
  Serial.print(h);
  Serial.print(" %\t");
  Serial.print("Temperature: ");
  Serial.print(t);
  Serial.print(" *C ");
  Serial.print(f);
  Serial.print(" *F\t");
  Serial.print("Heat index: ");
  Serial.print(hic);
  Serial.print(" *C ");
  Serial.print(hif);
  Serial.println(" *F");*/
  delay(500);

  /*****DS18B20 Water Temperature Sensor*****/
  // call sensors.requestTemperatures() to issue a global temperature
  // request to all devices on the bus
  //Serial.print("Requesting temperatures...");
  sensors.requestTemperatures(); // Send the command to get temperatures
  //Serial.println("DONE");
  // After we got the temperatures, we can print them here.
  // We use the function ByIndex, and as an example get the temperature from the first sensor only.
  //Serial.print("Water Temperature: ");
  float wattemp = sensors.getTempCByIndex(0);
  //Serial.print(temp);
  //Serial.println(" deg C");
  delay(500);

  display.setCursor(0, 0);
  display.print("Temp: ");
  display.print(wattemp);
  display.print(" degC  ");
  display.display();
  delay(200);
 
  /*****TDS Sensor*****/
  gravityTds.setTemperature(temperature);  // set the temperature and execute temperature compensation
  gravityTds.update();  //sample and calculate
  tdsValue = gravityTds.getTdsValue();  // then get the value
  //Serial.print(tdsValue,0);
  //Serial.println("ppm");
  delay(200);
 
  /*****PH Sensor*****/
  int measurings=0;
 
  for (int i = 0; i < samples; i++)
  {
    measurings += analogRead(pHSense);
    delay(10);
  }

  float voltage = 5 / adc_resolution * measurings/samples;
  phval = ph(voltage);
  //Serial.print("pH: ");
  //Serial.println(ph(voltage));
 
  delay(3000);
  display.setCursor(0, 10);
  display.print("TDS: ");
  display.print(tdsValue);
  display.print(" PH: ");
  display.print(phval);
  display.display();
 
  delay(500);

  /*****Turbidity Sensor*****/
  for (int i=0; i < n; i++){
  sensor += analogRead(turbsensor); // read the input on analog pin 0 (turbidity sensor analog output)
  delay(10);
  }
  sensorValue = sensor / n; // average the n values
  voltage = sensorValue * (5.000 / 1023.000); // Convert analog (0-1023) to voltage (0 - 5V)
 
  turbidity = 100.00 - (voltage / Vclear) * 100.00; // as relative percentage; 0% = clear water;
  //turbidity = turbidity + random(300);
  //Serial.print("Turbidity Value: ");
  //Serial.println(turbidity);

  display.setCursor(0, 20);
  display.print("Turb: ");
  display.print(turbidity);
  display.display();
 
  delay(500);

  readstringdata += String(h);
  readstringdata += String(",");
  readstringdata += String(t);
  readstringdata += String(",");
  readstringdata += String(wattemp);
  readstringdata += String(",");
  readstringdata += String(tdsValue);
  readstringdata += String(",");
  readstringdata += String(turbidity);
  readstringdata += String(",");
  readstringdata += String(phval);      
  readstringdata += String('#');  
  Serial.println(readstringdata);
  delay(500);
   
  #ifdef serial
  Serial.println("******************************************************");
  Serial.println("         ");
  #endif
 
  readstringdata = "";  

  delay(5000);
}
