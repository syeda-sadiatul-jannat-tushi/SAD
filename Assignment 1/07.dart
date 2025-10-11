//Write a program to find quotient and remainder of two integers.

import 'dart:io';

void main(){
  stdout.write("Enter interger 01: ");
  int x= int.parse(stdin.readLineSync()!);

  stdout.write("Enter interger 02: ");
  int y= int.parse(stdin.readLineSync()!);

  print("Quotient = ${x ~/ y}");
  print("Remainder = ${x % y}");

}
