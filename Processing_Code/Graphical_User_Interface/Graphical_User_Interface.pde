// Imports following libraries
import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;

// Creates an instance of the serial object
Serial myPort;

// Global variables
String data = "X: 0.00 Y: 0.00 Z: 0.00 G: 0.00 Angle: 0 Motor Speed: 0.00%";
String xData, yData, zData, gData, angle, motorSpeed;
float x = 0.00, y = 0.00, z = 0.00, g = 0.00;
String unit;
Boolean metric = false;
float convert;

void setup()
{
  // Creates the GUI background
  size(1920, 1080);
  smooth();
  background(0);
 
  // Creates the Serial object
  myPort = new Serial(this, "COM7", 9600);
  myPort.bufferUntil('\n');
}

void draw()
{
  // Resets background color to black
  background(0);
  
  while(myPort.available() > 0)
  {
    // Reads data from serial monitor
    data = (myPort.readStringUntil('\n'));
  }
  
  // Assigns data to corresponding variables
  xData = data.substring(0, data.indexOf('Y'));
  yData = data.substring(data.indexOf('Y'), data.indexOf('Z'));
  zData = data.substring(data.indexOf('Z'), data.indexOf('G'));
  gData = data.substring(data.indexOf('G'), data.indexOf('A'));
  angle = data.substring(data.indexOf('A'), data.indexOf('M'));
  motorSpeed = data.substring(data.indexOf('M'), data.indexOf('%')+1);
  println(data);
  
  // Converts values to metric units if m is pressed and g units if g is pressed
  if(keyPressed)
  {
    if (key == 'g')
      metric = false;
      
    else if (key == 'm')
      metric = true;
  }
  
  if (metric == true)
  {
    unit = "m/s^2";
    convert = 9.8;
  }
  
  else if (metric == false)
  {
    unit = "g";
    convert = 1;
  }
  
  // Converts the values to the appropriate unit of acceleration
  x = Float.parseFloat(xData.substring(3)) * convert;
  y = Float.parseFloat(yData.substring(3)) * convert;
  z = Float.parseFloat(zData.substring(3)) * convert;
  g = Float.parseFloat(gData.substring(3)) * convert;
  
  // Displays the values and text to the screen
  textSize(70);
  text("Acceleration (" + unit + ")", width / 20, height / 5);
  text(xData.substring(0, 3) + x, width / 20, height * 2 / 5);
  text(yData.substring(0, 3) + y, width / 20, height * 3 / 5);
  text(zData.substring(0, 3) + z, width / 20, height * 4 / 5);
  text("Net Acceleration: ", width * 9 / 20, height * 2 / 5);
  text(g + " " + unit, width * 15.5 / 20, height * 2 / 5);
  text("Angle of Elevation: ", width * 9 / 20, height * 3 / 5);
  text(angle.substring(7).concat("deg"), width * 16 / 20, height * 3 / 5);
  text("Motor Speed: ", width * 9 / 20, height * 4 / 5);
  text(motorSpeed.substring(13), width * 14 / 20, height * 4 / 5);
  
}
