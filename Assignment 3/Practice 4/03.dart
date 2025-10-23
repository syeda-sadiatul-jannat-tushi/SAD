import 'dart:io';
void main(){
    int n= int.parse(stdin.readLineSync()!);
    List<int>expenses=[];
    int total=0;

    for(int i=0; i<n; i++){
        int a= int.parse(stdin.readLineSync()!);
        expenses.add(a);

        total += a;
    }
    print("Total : $total");
}
