import 'package:flutter/material.dart';

class OrderSuccessPage extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final double total;

  const OrderSuccessPage({super.key, required this.items, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Successful"),
        backgroundColor: Colors.pink[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Your order has been placed successfully!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "Total: ৳ $total",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              "Order Items:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: Image.network(
                      item['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item['name']),
                    subtitle: Text("৳ ${item['price']} x ${item['quantity']}"),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[300],
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                ); // back to home
              },
              child: const Text("Back to Home", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
