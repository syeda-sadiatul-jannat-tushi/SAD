import 'dart:io';

void main(){
    stdout.write("Enter the Number: ");
    int a = int.parse(stdin.readLineSync()!);

    if( a%2 ==0){
        print("NUmber is Even");
    }
    else{
        print("NUmber is Ood");
    }
}
