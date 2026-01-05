import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_model.dart';
import 'order_success_page.dart';

class CartPage extends StatefulWidget {
  final Cart cart;

  const CartPage({super.key, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final supabase = Supabase.instance.client;
  bool _isPlacingOrder = false;

  Future<void> _placeOrder() async {
    final items = widget.cart.getItems();
    if (items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Your cart is empty")));
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    // Prepare order items - ensure all values are correct types
    final orderItems = items
        .map(
          (item) => {
            "name": item.name.toString(),
            "price": item.price is int ? item.price : item.price.toInt(),
            "quantity": item.quantity,
            "image": item.image.toString(),
          },
        )
        .toList();

    // Get total as int
    final int total = widget.cart.totalPrice();

    // Get user ID
    final user = supabase.auth.currentUser;
    final String? userId = user?.id;

    print("=== DEBUG ORDER DATA ===");
    print("Items count: ${items.length}");
    print("Total: $total (type: ${total.runtimeType})");
    print("User ID: ${userId ?? 'null'}");
    print("Order items: $orderItems");
    print("========================");

    try {
      // First, let's test with a simple insert to see what works
      print("Testing simple insert...");

      // Test with minimal data
      final testData = {
        "items": [
          {
            "name": "Test Item",
            "price": 100,
            "quantity": 1,
            "image": "https://example.com/test.jpg",
          },
        ],
        "total_price": 100,
        "status": "pending",
      };

      print("Test data: $testData");

      // Try test insert first
      try {
        final testResponse = await supabase
            .from('orders')
            .insert(testData)
            .select();
        print("✓ Test insert successful: $testResponse");
      } catch (testError) {
        print("✗ Test insert failed: $testError");
      }

      // Now try the actual order
      print("\nTrying actual order insert...");

      final orderData = {
        "items": orderItems,
        "total_price": total,
        "status": "pending",
        // Don't include created_at - it has default value
      };

      // Only add user_id if it exists and is not empty
      if (userId != null && userId.isNotEmpty && userId != "guest") {
        orderData["user_id"] = userId;
        print("Including user_id: $userId");
      } else {
        print("Skipping user_id (null/empty/guest)");
      }

      print("Order data to insert: $orderData");

      // Insert the order
      final response = await supabase
          .from('orders')
          .insert(orderData)
          .select(); // Add .select() to get response

      print("✅ Order inserted successfully!");
      print("Response: $response");

      // Clear the cart
      widget.cart.clearCart();

      // Navigate to success page
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderSuccessPage(items: orderItems, total: total.toDouble()),
          ),
        );
      }
    } catch (error) {
      print("\n❌ ERROR DETAILS:");
      print("Error type: ${error.runtimeType}");
      print("Full error: $error");

      // Check for specific PostgreSQL errors
      if (error.toString().contains('PostgrestException')) {
        print("This is a PostgrestException - database error");
      }

      if (error.toString().contains('null value')) {
        print("Null value violation - check required columns");
      }

      if (error.toString().contains('column') &&
          error.toString().contains('does not exist')) {
        print("Column name error - check column names in table");
      }

      if (error.toString().contains('invalid input syntax')) {
        print("Data type mismatch - check data types");
      }

      // Show user-friendly error
      if (mounted) {
        _showErrorDialog(context, error.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Order Failed"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Could not place order. Possible issues:"),
            const SizedBox(height: 10),
            _buildErrorBullet("Database connection issue"),
            _buildErrorBullet("Missing required fields"),
            _buildErrorBullet("Incorrect data types"),
            const SizedBox(height: 15),
            SelectableText(
              "Technical: ${error.length > 200 ? error.substring(0, 200) + '...' : error}",
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _placeOrder(); // Retry
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• "),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  // Alternative simplified version
  Future<void> _placeOrderSimple() async {
    final items = widget.cart.getItems();
    if (items.isEmpty) return;

    setState(() => _isPlacingOrder = true);

    final orderItems = items
        .map(
          (item) => {
            "name": item.name,
            "price": item.price,
            "quantity": item.quantity,
            "image": item.image,
          },
        )
        .toList();

    final int total = widget.cart.totalPrice();

    try {
      // SIMPLEST POSSIBLE INSERT
      await supabase.from('orders').insert({
        "items": orderItems,
        "total_price": total,
        "status": "pending",
      });

      widget.cart.clearCart();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderSuccessPage(items: orderItems, total: total.toDouble()),
          ),
        );
      }
    } catch (e) {
      print("Simple insert error: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.cart.getItems();
    final int total = widget.cart.totalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.pink[400],
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                setState(() {
                  widget.cart.clearCart();
                });
              },
              tooltip: "Clear Cart",
            ),
        ],
      ),
      body: items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text("Your cart is empty", style: TextStyle(fontSize: 20)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(item.image),
                            radius: 25,
                            onBackgroundImageError: (_, __) {},
                          ),
                          title: Text(item.name),
                          subtitle: Text("৳${item.price} × ${item.quantity}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 20),
                                onPressed: () {
                                  setState(() {
                                    widget.cart.decreaseQuantity(item.name);
                                  });
                                },
                              ),
                              Text(item.quantity.toString()),
                              IconButton(
                                icon: const Icon(Icons.add, size: 20),
                                onPressed: () {
                                  setState(() {
                                    widget.cart.addToCart(item);
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.cart.removeItem(item.name);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Checkout section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "৳$total",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isPlacingOrder
                              ? null
                              : _placeOrderSimple, // Use simple version
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isPlacingOrder
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Place Order",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Continue Shopping"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
