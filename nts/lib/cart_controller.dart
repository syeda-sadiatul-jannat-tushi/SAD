import 'cart_model.dart';

class Cart {
  List<CartItem> items = [];

  // CREATE: Add product to cart
  void addToCart(CartItem item) {
    // Check if product already in cart
    final index = items.indexWhere((i) => i.name == item.name);
    if (index != -1) {
      items[index].quantity += item.quantity;
    } else {
      items.add(item);
    }
  }

  // READ: Get all items
  List<CartItem> getItems() => items;

  // UPDATE: Change quantity
  void updateQuantity(String name, int quantity) {
    final index = items.indexWhere((i) => i.name == name);
    if (index != -1) {
      items[index].quantity = quantity;
    }
  }

  // DELETE: Remove item
  void removeItem(String name) {
    items.removeWhere((i) => i.name == name);
  }

  // Total price
  int totalPrice() {
    int total = 0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // Clear cart
  void clear() {
    items.clear();
  }
}
