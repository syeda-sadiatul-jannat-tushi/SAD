class CartItem {
  String name;
  String image;
  int price;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

class Cart {
  final List<CartItem> _items = [];

  
  void addToCart(CartItem item) {
    final index = _items.indexWhere((i) => i.name == item.name);
    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(item);
    }
  }

  
  void decreaseQuantity(String name) {
    final index = _items.indexWhere((i) => i.name == name);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
      }
    }
  }

  
  void removeItem(String name) {
    _items.removeWhere((i) => i.name == name);
  }

  
  void clearCart() {
    _items.clear();
  }

  
  List<CartItem> getItems() => _items;

  
  int totalPrice() {
    int total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }
}
