import 'dart:io';

void main() {
  File file = File('students.csv');
  file.writeAsStringSync('Name,Age,Address\n'); 

  List<Map<String, String>> students = [
    {'Name': 'Tushi', 'Age': '21', 'Address': 'Sylhet'},
    {'Name': 'Lima', 'Age': '21', 'Address': 'Sreemongle'},
    {'Name': 'Tisha', 'Age': '22', 'Address': 'Maulovibajar'},
  ];


  String info = students
      .map((e) => '${e['Name']},${e['Age']},${e['Address']}')
      .join('\n');

  file.writeAsStringSync(info, mode: FileMode.append);
  
  print('Student data written to students.csv successfully!\n');

  
  String contents = file.readAsStringSync();
  print('File Contents:\n$contents');
}
