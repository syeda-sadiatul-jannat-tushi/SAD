import 'dart:io';
void main(){
    List<String>friends =[];
    friends.addAll(['Taehyung', 'Jungkook', 'Jimin', 'Namjoon', 'AgustD', 'Hobi', 'Jin','Army']);
    var name= friends.where((i) => i.startsWith('A'));
    print(name.join(', '));
}
