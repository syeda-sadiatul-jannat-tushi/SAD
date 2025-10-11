// Write a program to print a square of a number using user input.

import 'dart:io';

void main(){
  stdout.write("Enter a number : ");
  double p = double.parse(stdin.readLineSync()!);
  print("Square of a number= ${p*p}");
}

