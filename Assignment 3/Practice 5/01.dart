import 'dart:io';

void main() {
  File file = File('hello.txt');
  String name = 'Syeda Sadiatul Jannat Tushi';

  file.writeAsStringSync('My name is: $name\n', mode: FileMode.append);
  print('Name written to hello.txt successfully!');
}
