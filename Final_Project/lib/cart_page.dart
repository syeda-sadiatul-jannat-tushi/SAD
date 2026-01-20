import 'dart:convert';
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

    try {
      // 1. Prepare order items
      final orderItems = items.map((item) {
        return {
          "name": item.name,
          "price": item.price,
          "quantity": item.quantity,
          "image": item.image,
        };
      }).toList();

      // 2. Get total
      final int total = widget.cart.totalPrice();

      // 3. Get user ID
      final user = supabase.auth.currentUser;
      final String? userId = user?.id;

      print("=== DEBUG ORDER INFO ===");
      print("Items: ${items.length}");
      print("Total: $total");
      print("User ID: ${userId ?? 'guest'}");
      print("Order items JSON: ${jsonEncode(orderItems)}");

      // 4. Prepare the simplest possible data for Supabase
      Map<String, dynamic> orderData = {
        "items": jsonDecode(
          jsonEncode(orderItems),
        ), // Ensure proper JSON format
        "total_price": total,
        // "status": "pending", // REMOVE THIS - your table might not have it
        // "created_at" has default value in DB
      };

      // Add user_id only if user exists
      if (userId != null && userId.isNotEmpty) {
        orderData["user_id"] = userId;
      }

      print("Sending to Supabase: ${jsonEncode(orderData)}");

      // 5. Try to insert WITHOUT status first
      try {
        final response = await supabase
            .from('orders')
            .insert(orderData)
            .select()
            .single()
            .timeout(const Duration(seconds: 10));

        print("✅ Order placed successfully!");
        print("Response: $response");

        // Clear cart
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
      } catch (firstError) {
        print("First attempt failed: $firstError");

        // If failed, try without user_id
        if (firstError.toString().contains('user_id') ||
            firstError.toString().contains('uuid')) {
          print("Retrying without user_id...");

          final retryData = {
            "items": jsonDecode(jsonEncode(orderItems)),
            "total_price": total,
          };

          final response = await supabase
              .from('orders')
              .insert(retryData)
              .select()
              .single();

          print("✅ Retry successful!");

          widget.cart.clearCart();

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OrderSuccessPage(
                  items: orderItems,
                  total: total.toDouble(),
                ),
              ),
            );
          }
        } else {
          rethrow;
        }
      }
    } catch (error) {
      print("\n❌ ORDER ERROR:");
      print("Type: ${error.runtimeType}");
      print("Message: $error");

      // Parse the error for better message
      String errorMessage = "Failed to place order";

      if (error.toString().contains('column "status" does not exist')) {
        errorMessage = "Database table missing 'status' column";
      } else if (error.toString().contains('column "user_id" does not exist')) {
        errorMessage = "Database table missing 'user_id' column";
      } else if (error.toString().contains('null value')) {
        errorMessage = "Missing required field in database";
      } else if (error.toString().contains('network')) {
        errorMessage = "Network error. Check your connection";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  errorMessage,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Error: ${error.toString().split('\n').first}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Fix DB',
              onPressed: () {
                _showDatabaseHelp(context);
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  void _showDatabaseHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Database Setup Help"),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Your orders table needs these columns:"),
              SizedBox(height: 10),
              Text("1. id (bigint, primary key, auto-increment)"),
              Text("2. created_at (timestamp, default: now())"),
              Text("3. user_id (text, nullable)"),
              Text("4. items (jsonb)"),
              Text("5. total_price (integer)"),
              Text("6. status (text, default: 'pending')"),
              SizedBox(height: 15),
              Text("Run this SQL in Supabase SQL Editor:"),
              SizedBox(height: 10),
              SelectableText(
                "ALTER TABLE orders\n"
                "ADD COLUMN id BIGSERIAL PRIMARY KEY,\n"
                "ADD COLUMN status TEXT DEFAULT 'pending';",
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.cart.getItems();
    final int total = widget.cart.totalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.pink[400],
      ),
      body: items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text("Your cart is empty", style: TextStyle(fontSize: 20)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Image.network(
                            item.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                          title: Text(item.name),
                          subtitle: Text("৳ ${item.price} x ${item.quantity}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    widget.cart.decreaseQuantity(item.name);
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    widget.cart.addToCart(item);
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
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

                // Total & Place Order Button
                if (items.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "৳ ${total.toString()}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[300],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: _isPlacingOrder ? null : _placeOrder,
                          child: _isPlacingOrder
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Place Order",
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
