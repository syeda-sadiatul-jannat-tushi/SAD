//Write a program in Dart to remove all whitespaces from String.

import 'dart:io';

void main(){
  stdout.write("Enter string = ");
  String s= (stdin.readLineSync()!);
  String p= s.replaceAll(" ", "");

  print("String without whitespaces= $p");

}
