//Suppose, your distance to office from home is 25 km and you travel 40 km per hour. 
//Write a program to calculate time taken to reach office in minutes. 
//Formula= (distance) / (speed)

import 'dart:io';

void main(){
  int distance = 25;
  int speed = 40;

  double Formula= (distance) / (speed);

  print("Time in minutes = ${Formula * 60}");
}
