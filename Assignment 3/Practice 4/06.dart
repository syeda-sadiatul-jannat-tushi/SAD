import 'dart:io';
void main() {
  Map<String, dynamic> Me = {
    'Name': 'Tushi',
    'Address': 'Sylhet Sadar',
    'Age': 22,
    'Country': 'Bangladesh'
  };

  Me['country'] = 'Korea';
  
  Me.forEach((key, value) {
    print('$key: $value');
  });
}
