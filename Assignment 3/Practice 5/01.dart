import 'dart:io';

void main() {
  File file = File('hello.txt');
  String name = 'Syeda Sadiatul Jannat Tushi';

  file.writeAsStringSync('My name is $name');
  print('Name written to hello.txt successfully!');
}
