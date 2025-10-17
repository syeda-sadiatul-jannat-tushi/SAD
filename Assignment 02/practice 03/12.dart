double calculateArea({double length = 1 , double width = 1}){
    return length * width;
}

void main(){
    print("The area of a rectangle ${calculateArea()}");
    print("The area of a rectangle ${calculateArea(length: 7, width: 13)}");

}
