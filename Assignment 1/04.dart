//Write a program in Dart that finds simple interest. Formula= (p * t * r) / 100

import 'dart:io';

void main(){
  stdout.write("Enter p : ");
  double p = double.parse(stdin.readLineSync()!);
  stdout.write("Enter t: ");
  double t = double.parse(stdin.readLineSync()!);
  stdout.write("Enter r: ");
  double r = double.parse(stdin.readLineSync()!);

  print("Formula= ${(p * t * r) / 100}");
}
