/*
  Radar Visualization Interface
  -----------------------------
  This Processing sketch visualizes data received from an Arduino-based radar system
  that uses a Servo and Ultrasonic sensor for scanning.

  Developed by: Priyansh Singh
  Data Format from Arduino: "angle,distance."
  Serial Port: Change "COM4" if needed.
*/

import processing.serial.*;
Serial myPort;

String angle = "";
String distance = "";
String data = "";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;

void setup() {
  size(1200, 700);
  smooth();
  myPort = new Serial(this, "COM4", 9600);  // Update COM port as required
  myPort.bufferUntil('.');
}

void draw() {
  fill(0, 4); // Creates trailing effect
  noStroke();
  rect(0, 0, width, height - height * 0.065);

  fill(98, 245, 31);
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}

// Serial Data Handler
void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.');
  if (data != null && data.indexOf(",") > 0) {
    data = data.substring(0, data.length() - 1);
    index1 = data.indexOf(",");
    angle = data.substring(0, index1);
    distance = data.substring(index1 + 1);
    iAngle = int(angle);
    iDistance = int(distance);
  }
}

// Draw radar arcs and radial lines
void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);

  arc(0, 0, width - width * 0.0625, width - width * 0.0625, PI, TWO_PI);
  arc(0, 0, width - width * 0.27, width - width * 0.27, PI, TWO_PI);
  arc(0, 0, width - width * 0.479, width - width * 0.479, PI, TWO_PI);
  arc(0, 0, width - width * 0.687, width - width * 0.687, PI, TWO_PI);

  line(-width / 2, 0, width / 2, 0);
  for (int angle = 30; angle <= 150; angle += 30) {
    line(0, 0, (-width / 2) * cos(radians(angle)), (-width / 2) * sin(radians(angle)));
  }

  popMatrix();
}

// Draw object if within range
void drawObject() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  strokeWeight(9);
  stroke(255, 10, 10);

  pixsDistance = iDistance * ((height - height * 0.1666) * 0.025);
  if (iDistance < 40) {
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)), 
         (width - width * 0.505) * cos(radians(iAngle)), 
         -(width - width * 0.505) * sin(radians(iAngle)));
  }
  popMatrix();
}

// Draw rotating radar sweep line
void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60);
  translate(width / 2, height - height * 0.074);
  line(0, 0, (height - height * 0.12) * cos(radians(iAngle)), 
       -(height - height * 0.12) * sin(radians(iAngle)));
  popMatrix();
}

// Draw UI text and angle labels
void drawText() {
  pushMatrix();
  noStroke();
  fill(0);
  rect(0, height - height * 0.0648, width, height);
  fill(98, 245, 31);
  textSize(25);

  text("10cm", width - width * 0.3854, height - height * 0.0833);
  text("20cm", width - width * 0.281, height - height * 0.0833);
  text("30cm", width - width * 0.177, height - height * 0.0833);
  text("40cm", width - width * 0.0729, height - height * 0.0833);

  textSize(40);
  text("Priyansh", width - width * 0.875, height - height * 0.0277);
  text("Angle: " + iAngle + "°", width - width * 0.48, height - height * 0.0277);

  if (iDistance < 40) {
    text("Distance: " + iDistance + " cm", width - width * 0.26, height - height * 0.0277);
    noObject = "In Range";
  } else {
    text("Distance: Out of Range", width - width * 0.26, height - height * 0.0277);
    noObject = "Out of Range";
  }

  textSize(25);
  fill(98, 245, 60);
  labelAngle(30, -60);
  labelAngle(60, -30);
  labelAngle(90, 0);
  labelAngle(120, 30);
  labelAngle(150, 60);

  popMatrix();
}

// Helper to draw angle labels on arcs
void labelAngle(int angle, int rot) {
  pushMatrix();
  float x = (width - width * 0.5) + width / 2 * cos(radians(angle));
  float y = (height - height * 0.09) - width / 2 * sin(radians(angle));
  translate(x, y);
  rotate(radians(rot));
  text(angle + "°", 0, 0);
  popMatrix();
}
