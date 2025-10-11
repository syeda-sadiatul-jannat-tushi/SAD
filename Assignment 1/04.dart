//Write a program in Dart that finds simple interest. Formula= (p * t * r) / 100

import 'dart:io';

void main(){
  stdout.write("Enter p : ");
  int p = int.parse(stdin.readLineSync()!);
  stdout.write("Enter t: ");
  int t = int.parse(stdin.readLineSync()!);
  stdout.write("Enter r: ");
  int r = int.parse(stdin.readLineSync()!);

  print("Simple interest= ${(p * t * r) / 100}");
}
