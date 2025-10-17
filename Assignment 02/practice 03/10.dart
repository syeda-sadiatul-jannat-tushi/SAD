import 'dart:math';

bool isEven(int n){
    if(n % 2 ==0) return true;
    return false;
}

void main(){
    print("The number is even = ${isEven(13)}");
    print("The number is even = ${isEven(20)}");
}
