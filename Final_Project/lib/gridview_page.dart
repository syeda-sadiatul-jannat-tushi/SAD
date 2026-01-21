
import 'package:flutter/material.dart';
import 'single_item_page.dart';
import 'cart_model.dart';

class GridviewPage extends StatelessWidget {
  final Cart cart; 

  GridviewPage({super.key, required this.cart}); 


  final List<Map<String, dynamic>> products = [
    {
      "name": "Baby Teddy",
      "price": 550,
      "image":
          "https://cdn.shopify.com/s/files/1/1467/4554/products/Teddy_25110__4251219622118.3000.000_1_1024x1024.jpg?v=1600022409",
    },
    {
      "name": "Baby Dress",
      "price": 800,
      "image":
          "https://tse4.mm.bing.net/th/id/OIP.AqilMZc7MkNPb1GHqdtAlAHaHa?w=1500&h=1500&rs=1&pid=ImgDetMain&o=7&rm=3",
    },
    {
      "name": "Baby Shoes",
      "price": 950,
      "image":
          "https://tse1.mm.bing.net/th/id/OIP.FQCergK4wbJk0PlR9WDP1AHaEO?rs=1&pid=ImgDetMain&o=7&rm=3",
    },
    {
      "name": "Baby Cap",
      "price": 300,
      "image":
          "https://tse1.mm.bing.net/th/id/OIP.dlJ9mErrtYIR2aiJgwtjtwHaHa?rs=1&pid=ImgDetMain&o=7&rm=3",
    },
    {
      "name": "Baby Toy Car",
      "price": 450,
      "image": "https://m.media-amazon.com/images/I/71ZyAzhJk-L.jpg",
    },
    {
      "name": "Baby Blanket",
      "price": 1200,
      "image":
          "https://th.bing.com/th/id/R.63e05c1647ce149862e46118a5c25582?rik=0JVyXQiP2QL7GQ&pid=ImgRaw&r=0",
    },
    {
      "name": "Baby Bottle",
      "price": 350,
      "image":
          "https://media.istockphoto.com/id/176067064/photo/bottle.jpg?s=612x612&w=0&k=20&c=pxbNLCDiDweLLvmn8yGXNFkHZso3hmEvB8hnkC_XcaI=",
    },
    {
      "name": "Baby Feeding Set",
      "price": 600,
      "image":
          "https://m.media-amazon.com/images/I/71AO4fseiKL._AC_SL1500_.jpg",
    },
    {
      "name": "Baby Socks",
      "price": 200,
      "image":
          "https://tse3.mm.bing.net/th/id/OIP.wwn27_NRcYEkcD7EBXpTHAHaHa?rs=1&pid=ImgDetMain&o=7&rm=3",
    },
    {
      "name": "Baby Stroller Toy",
      "price": 700,
      "image":
          "https://i5.walmartimages.com/seo/Kid-Connection-Baby-Doll-Stroller-Set-10-Pieces_f673c5d0-8222-471d-a275-3b09654f6323.ee522b32fb1f888cfb616cdfd22b9776.jpeg",
    },
    {
      "name": "Baby Pillow",
      "price": 500,
      "image":
          "https://m.media-amazon.com/images/I/61UN3pcseGL._AC_SL1500_.jpg",
    },
    {
      "name": "Baby Rattle",
      "price": 250,
      "image":
          "https://tse3.mm.bing.net/th/id/OIP.tmvcmUYtygIage0ICy8PDgHaE9?rs=1&pid=ImgDetMain&o=7&rm=3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text("Baby Products"),
        backgroundColor: Colors.pink[300],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final product = products[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleItemPage(
                    img: product["image"],
                    title: product["name"],
                    price: product["price"],
                    cart: cart, 
                  ),
                ),
              );
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        product["image"],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image, size: 40);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      product["name"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "৳ ${product["price"]}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.pink[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
