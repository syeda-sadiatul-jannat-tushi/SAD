import 'dart:io';

void main(){

    stdout.write("Enter 1st number: ");
    double a = double.parse(stdin.readLineSync()!);

    stdout.write("Enter operator : ");
    String c= (stdin.readLineSync()!);

    stdout.write("Enter 2nd number: ");
    double b = double.parse(stdin.readLineSync()!);

    double ans;

    switch(c){
        case '+': 
          ans = a+b;
          break;

        case '-': 
          ans = a-b;
          break;
        
        case '*': 
          ans = a*b;
          break;
        
        case '/': 
          if(b ==0){
            print("Invalide");
            return;
          }
          else{
            ans = a/b;
          }
          break;

        default:
           print("Invalide operator");
           return;

    }
    print("Answer after operation: $ans");

}
