import 'dart:math';

String generatePassword(int len){
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#\$%&*!?';
    final rnd = Random();

    String pass="";

    for(int i=0; i<len ; i++){
        pass += chars[rnd.nextInt(chars.length)];
    }
    return pass;
}

void main(){
    print("Generated Password: ${generatePassword(6)}");
}
