import 'dart:io';

void main() {
  File s = File('hello.txt');
  File d = File('hello_copy.txt');
  s.copySync(d.path);
  
  print('hello.txt has been copied to hello_copy.txt successfully!');
}

