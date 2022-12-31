#define BLYNK_TEMPLATE_ID "TMPLqAzqKchH"
#define BLYNK_DEVICE_NAME "sports biomechanics"
#define BLYNK_AUTH_TOKEN "xpVI-jcdX7fhhOGVrcSjqjd-QMP1Kbdv"
#include "MAX30100_PulseOximeter.h"
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <Blynk.h>
#include <WiFi.h>
#include <WiFiClient.h>
#include <BlynkSimpleEsp32.h>

Adafruit_MPU6050 mpu;
#define REPORTING_PERIOD_MS     1000
#define BLYNK_PRINT Serial

char auth[] = "xpVI-jcdX7fhhOGVrcSjqjd-QMP1Kbdv";
char ssid[] = "Redmi Note 9";
char pass[] = "987654321";

uint32_t tsLastReport = 0;
float BPM, SpO2;
PulseOximeter pox;
const int FORCE_SENSOR_PIN = 34;
const int FLEX_PIN = 35;  //flex
const float VCC = 4.98;   //flex
const float R_DIV = 10000.0;//flex
int UVOUT = 25 ;  //uv
int REF_3V3 = 26 ; //uv
const float STRAIGHT = 5000.0; //flex
const float BEND = 20000.0;  //flex

void onBeatDetected()
{
  Serial.println("Beat Detected!");
}

void setup() {

  Serial.begin(115200);
  pinMode(FLEX_PIN, INPUT);
  pinMode(FORCE_SENSOR_PIN, INPUT);
  pinMode(UVOUT, INPUT);
  pinMode(REF_3V3, INPUT);
  pinMode(27, INPUT); // Setup for leads off detection LO +
  pinMode(33, INPUT); // Setup for leads off detection LO -
  pinMode(19, OUTPUT);
  delay(100);
  Serial.print("Initializing pulse oximeter..");
  if (!pox.begin()) {
    Serial.println("FAILED");
    for (;;);
  } else {
    Serial.println("SUCCESS");

    pox.setOnBeatDetectedCallback(onBeatDetected);
  }
  while (!Serial)
    delay(10); // will pause Zero, Leonardo, etc until serial console opens

  Serial.println("Adafruit MPU6050 test!");

  // Try to initialize!
  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }
  Serial.println("MPU6050 Found!");

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  Serial.print("Accelerometer range set to: ");
  switch (mpu.getAccelerometerRange()) {
  case MPU6050_RANGE_2_G:
    Serial.println("+-2G");
    break;
  case MPU6050_RANGE_4_G:
    Serial.println("+-4G");
    break;
  case MPU6050_RANGE_8_G:
    Serial.println("+-8G");
    break;
  case MPU6050_RANGE_16_G:
    Serial.println("+-16G");
    break;
  }
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  Serial.print("Gyro range set to: ");
  switch (mpu.getGyroRange()) {
  case MPU6050_RANGE_250_DEG:
    Serial.println("+- 250 deg/s");
    break;
  case MPU6050_RANGE_500_DEG:
    Serial.println("+- 500 deg/s");
    break;
  case MPU6050_RANGE_1000_DEG:
    Serial.println("+- 1000 deg/s");
    break;
  case MPU6050_RANGE_2000_DEG:
    Serial.println("+- 2000 deg/s");
    break;
  }
  delay(100);
  
  mpu.setFilterBandwidth(MPU6050_BAND_5_HZ);
  Serial.print("Filter bandwidth set to: ");
  switch (mpu.getFilterBandwidth()) {
  case MPU6050_BAND_260_HZ:
    Serial.println("260 Hz");
    break;
  case MPU6050_BAND_184_HZ:
    Serial.println("184 Hz");
    break;
  case MPU6050_BAND_94_HZ:
    Serial.println("94 Hz");
    break;
  case MPU6050_BAND_44_HZ:
    Serial.println("44 Hz");
    break;
  case MPU6050_BAND_21_HZ:
    Serial.println("21 Hz");
    break;
  case MPU6050_BAND_10_HZ:
    Serial.println("10 Hz");
    break;
  case MPU6050_BAND_5_HZ:
    Serial.println("5 Hz");
    break;
  }

  Serial.println("");
  delay(100);
 Blynk.begin(auth, ssid, pass);
}

void loop() {

  Blynk.run();
  char inByte = Serial.read(); 
  int flexADC = analogRead(FLEX_PIN);
  float flexV = flexADC * VCC / 1023.0;
  float flexR = R_DIV *(VCC / flexV - 1.0);
  int analogReading = analogRead(FORCE_SENSOR_PIN);

  pox.update();
 BPM = pox.getHeartRate();
 SpO2 = pox.getSpO2();
  if (millis() - tsLastReport > REPORTING_PERIOD_MS)
  {

    Serial.print("BPM: ");
    Serial.println(BPM);
    Blynk.virtualWrite(V2,BPM);

    Serial.print("SpO2: ");
    Serial.print(SpO2);
    Serial.println("%");
    Blynk.virtualWrite(V3,SpO2);

    tsLastReport = millis();
  }

  //Serial.println("Resistance: "+ String(flexR) + " ohms")
  float angle = map(flexR, STRAIGHT, BEND, 0, 90.0);
  Serial.println("Bend : " + String(angle + 34) + " degrees");
  Blynk.virtualWrite(V5,angle + 34);
  Blynk.virtualWrite(V9,angle + 34);
  
  delay (200);


   // FSR sensor  
   Serial.print("The force sensor value = ");
   Serial.println(analogReading); // print the raw analog reading
   Blynk.virtualWrite(V6, analogReading);
   delay (200);

   //UV Sensor
   int uvLevel = averageAnalogRead(UVOUT);
  int refLevel = averageAnalogRead(REF_3V3);
  
  //Use the 3.3V power pin as a reference to get a very accurate output value from sensor
  float outputVoltage = 3.3 / refLevel * uvLevel;
  
  float uvIntensity = mapfloat(outputVoltage, 0.99, 2.8, 0.0, 15.0); //Convert the voltage to a UV intensity level
 
 
  Serial.print("UV Intensity (mW/cm^2): ");
  Serial.println(uvIntensity);
  Blynk.virtualWrite(V7,uvIntensity);
  
 
 if (uvIntensity <= 3)
  {
    Serial.println("UV Rays under limit.");
    }
    else{
      Serial.println("High UV Radiation.");
  }
  
  Serial.println();
  
  delay(200);


  //ECG sensor
  if((digitalRead(12) == 1)||(digitalRead(13) == 1)){
  Serial.println('!');
  }
  else{
  // send the value of analog input 0:
  Serial.println(analogRead(32));
  }
  //Wait for a bit to keep serial data from saturating
  Blynk.virtualWrite(V4,analogRead(32));
  delay(200);

  //gyro
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  /* Print out the values */
  Serial.print("Acceleration X: ");
  Serial.print(a.acceleration.x);
  Serial.print(", Y: ");
  Serial.print(a.acceleration.y);
  Serial.print(", Z: ");
  Serial.print(a.acceleration.z);
  Serial.println(" m/s^2");

  Serial.print("Rotation X: ");
  Serial.print(g.gyro.x);
  Serial.print(", Y: ");
  Serial.print(g.gyro.y);
  Serial.print(", Z: ");
  Serial.print(g.gyro.z);
  Serial.println(" rad/s");

  /*Serial.print("Temperature: ");
  Serial.print(temp.temperature);
  Serial.println(" degC");*/
  
  Serial.println("");
 
    float cal;
    cal = calories(a.acceleration.x, a.acceleration.y, a.acceleration.z);
    Serial.print("Calories Burnt: ");
    Serial.println(cal);
    Blynk.virtualWrite(V0,g.gyro.x);
    Blynk.virtualWrite(V10,g.gyro.y);
    Blynk.virtualWrite(V11,g.gyro.z);
    Blynk.virtualWrite(V1,cal);
    
  delay(200);



  Serial.println("###############################################CYCLE COMPLETED############################################");
}

float cal2 = 0.0;
int calories(float a,float b,float c)
{
  
   if (a != 0 || b != 0 || c != 0)
   {
    cal2=cal2+0.05;
    }
  else
  {
    Serial.print(cal2);
    Serial.println("You Are Stationary.");
    }
   return cal2;
  }
int averageAnalogRead(int pinToRead)
{
  byte numberOfReadings = 8;
  unsigned int runningValue = 0; 
 
  for(int x = 0 ; x < numberOfReadings ; x++)
    runningValue += analogRead(pinToRead);
  runningValue /= numberOfReadings;
 
  return(runningValue);
}
 
float mapfloat(float x, float in_min, float in_max, float out_min, float out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}
