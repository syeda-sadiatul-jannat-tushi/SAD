import 'dart:io';

void main() {
  File file = File('hello_copy.txt');
  if (file.existsSync()) {
    file.deleteSync();
    print('hello_copy.txt has been deleted successfully!');
  } else {
    print('File hello_copy.txt does not exist!');
  }
}
