//Write a dart program to create a class Camera with private properties [id, brand, color, price]. 
//Create a getter and setter to get and set values. Also, create 3 objects of it and print all details.

class Camera{
  int _id;
  String _brand;
  String  _color;
  double _price;

  Camera(this._id, this._brand, this._color, this._price);

  //Getter Method
  int get id => _id;
  String get brand => _brand;
  String get color => _color;
  double get price => _price;

  //Setter Method
  set id(int value) => _id = value;
  set brand(String value) => _brand = value;
  set color(String value) => _color = value;
  set price(double value){
    if(value > 0){
      _price = value;
    }
    else{
      print("Price cannot be negative!");
    }
  }

  void display(){
    print("Camera ID: $_id");
    print("Brand: $_brand");
    print("Color: $_color");
    print("Price: \$${_price.toStringAsFixed(2)}");
  }
}

void main(){
  Camera a= Camera(1, 'canon' , 'Black', 55000.00);
  Camera b= Camera(2, 'Nikon', 'Silver', 62000.50);
  Camera c= Camera(3, 'Sony','Red' , 75000.80);

  List<Camera> cams= [a,b,c];

  for(var i in cams){
    i.display();
  }
}
