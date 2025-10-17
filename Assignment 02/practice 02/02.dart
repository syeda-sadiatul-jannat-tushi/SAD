import 'dart:io';

void main(){
    stdout.write("Enter the Number: ");
    String c = (stdin.readLineSync()!);

    c = c.toLowerCase();

    if(c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u'){
        print("The character is a vowel");
    }
    else{
        print("The character is a consonant");
    }
}
