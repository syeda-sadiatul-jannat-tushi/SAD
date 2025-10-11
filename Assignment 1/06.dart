//Write a program to print full name of a from first name and last name using user input.

import 'dart:io';

void main(){
  stdout.write("Enter the first name : ");
  String firstName= stdin.readLineSync()!;

  stdout.write("Enter the last name: ");
  String lastName= stdin.readLineSync()!;

  print("Full name = $firstName $lastName");
}

