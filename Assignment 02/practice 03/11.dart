void createUser(String name, int age, {bool isActive= true}){
    print("Create User's name : $name, Her age: $age, that's $isActive");
}
void main(){
    createUser("Tushi", 22);
    createUser("Tasnia", 25, isActive: false);
}
