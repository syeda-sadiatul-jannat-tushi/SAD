import 'dart:io';

void main(){
    stdout.write("Enter the Number: ");
    int a = int.parse(stdin.readLineSync()!);

    if(a > 0){
        print("The number is positive");
    }
    else if(a < 0){
        print("The number is negative");
    }
    else{
        print("The number is Zero");
    }
}
