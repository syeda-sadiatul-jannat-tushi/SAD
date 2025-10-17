import 'dart:math';

int maxNumber(int a, int b, int c){
    if(a >= b && a >= c) return a;
    else if(b >= a && b >=c) return b;
    else return c;
}

void main(){
    print("The largest number. = ${maxNumber(7, 13 , 11)}");
}
