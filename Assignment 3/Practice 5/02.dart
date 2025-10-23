import 'dart:io';

void main() {
  String Friend = 'Tisha';
  File file = File('hello.txt');

  file.writeAsStringSync('My friend : $Friend\n', mode: FileMode.append);
  print('Friend name appended to hello.txt successfully!');
}
