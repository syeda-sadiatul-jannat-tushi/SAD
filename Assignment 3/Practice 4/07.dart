void main() {
  Map<String, String> info = {
    'name': 'Tushi',
    'phone': '017xxxxxxxx',
    'city': 'Sylhet',
    'area': 'Zindabazar',
    'code': '880'
  };

  var key4= info.keys.where((key) => key.length == 4);

  print("All keys: ${info.keys}");
  print("Keys with length 4: $key4");
}
