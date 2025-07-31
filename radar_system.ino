/*
  Radar-Based Object Detection System
  -----------------------------------
  Developed using Arduino UNO, Ultrasonic Sensor (HC-SR04), Servo Motor,
  Buzzer, and LED. The system scans from 15° to 165°, detects objects,
  and gives audio-visual alerts based on distance.
*/

#include <Servo.h>

// Pin Definitions
const int trigPin = 10;     // Ultrasonic Trigger
const int echoPin = 11;     // Ultrasonic Echo
const int buzzerPin = 9;    // Buzzer
const int ledPin = 8;       // LED
const int servoPin = 12;    // Servo Motor

long duration;
int distance;

Servo myServo;

void setup() {
  // Pin modes
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(buzzerPin, OUTPUT);
  pinMode(ledPin, OUTPUT);

  // Serial Communication
  Serial.begin(9600);

  // Attach servo
  myServo.attach(servoPin);
}

void loop() {
  // Servo sweep: 15° to 165°
  for (int angle = 15; angle <= 165; angle++) {
    myServo.write(angle);
    delay(15);
    distance = calculateDistance();
    handleAlert(distance);
    sendData(angle, distance);
  }

  // Servo sweep: 165° to 15°
  for (int angle = 165; angle >= 15; angle--) {
    myServo.write(angle);
    delay(15);
    distance = calculateDistance();
    handleAlert(distance);
    sendData(angle, distance);
  }
}

// Function to measure distance using ultrasonic sensor
int calculateDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;
  return distance;
}

// Function to trigger buzzer and LED alerts based on distance
void handleAlert(int dist) {
  if (dist < 5) {
    // Rapid beep and blink
    digitalWrite(buzzerPin, HIGH);
    digitalWrite(ledPin, HIGH);
    delay(50);
    digitalWrite(buzzerPin, LOW);
    digitalWrite(ledPin, LOW);
    delay(50);
  } else if (dist < 15) {
    // Slow beep and blink
    digitalWrite(buzzerPin, HIGH);
    digitalWrite(ledPin, HIGH);
    delay(150);
    digitalWrite(buzzerPin, LOW);
    digitalWrite(ledPin, LOW);
    delay(150);
  } else {
    // No alert
    digitalWrite(buzzerPin, LOW);
    digitalWrite(ledPin, LOW);
  }
}

// Function to send angle and distance data via Serial
void sendData(int angle, int dist) {
  Serial.print(angle);
  Serial.print(",");
  Serial.print(dist);
  Serial.print(".");
}
