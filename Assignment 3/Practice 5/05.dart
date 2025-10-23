import 'dart:io';

void main() {
  for (int i = 1; i <= 100; i++) {
    File file = File('file$i.txt');
    file.createSync();
    print('Created ${file.path}');
  }

  print('All 100 files created successfully!');
}
