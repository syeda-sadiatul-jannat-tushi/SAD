//Write a Dart program to convert String to int.

import 'dart:io';

void main(){
  stdout.write("Enter string number = ");
  String s= (stdin.readLineSync()!);
  int p= int.parse(s);

  print("Int = $p");
  print("Type of p is ${p.runtimeType}");

}
