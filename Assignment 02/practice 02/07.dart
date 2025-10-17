import 'dart:io';

void main(){

    for(int i=1; i<=9 ; i++){
        print("\nMultiplication table $i : ");

        for(int j=1; j<=10; j++){
            print("$i x $j == ${i * j}");
        }
    }

}
