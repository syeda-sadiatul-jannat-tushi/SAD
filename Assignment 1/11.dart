//Suppose, you often go to restaurant with friends and you have to split amount of bill. 
//Write a program to calculate split amount of bill. 
//Formula= (total bill amount) / number of people

import 'dart:io';

void main(){
  stdout.write("Enter the total bill amount = ");
  double t= double.parse(stdin.readLineSync()!);

  stdout.write("Enter the number of people = ");
  int p= int.parse(stdin.readLineSync()!);

  print("Per person bill = ${(t) / p}");

}
