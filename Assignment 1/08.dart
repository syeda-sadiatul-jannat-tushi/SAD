//Write a program to swap two numbers.

import 'dart:io';

void main(){
  stdout.write("Enter a = ");
  int x= int.parse(stdin.readLineSync()!);

  stdout.write("Enter b = ");
  int y= int.parse(stdin.readLineSync()!);

  int temp = x;
  x = y;
  y = temp;

  print("Numbers after swap: a= $x b= $y");

}
