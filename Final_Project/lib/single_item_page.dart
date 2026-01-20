import 'package:flutter/material.dart';
import 'cart_model.dart'; // Your Cart setup

class SingleItemPage extends StatelessWidget {
  final img, title;
  final int? price; 

  final Cart? cart;

  const SingleItemPage({
    super.key,
    required this.img,
    required this.title,
    this.price,
    this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Single item page"),
        backgroundColor: Colors.pink[400],
      ),
      body: Center(
        child: SizedBox(
          height: 500,
          width: 500,
          child: Card(
            child: Column(
              children: [
                Image.network(
                  img,
                  height: 400,
                  width: 400,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image, size: 100);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // ---------------- Add Cart Button ----------------
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[300],
                  ),
                  onPressed: () {
                    if (cart != null) {
                      // Add the item to the cart
                      cart!.addToCart(
                        CartItem(name: title, image: img, price: price ?? 0),
                      );

                      // Show confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added to cart!")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Cart not initialized")),
                      );
                    }
                  },
                  child: const Text("Add to Cart"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
