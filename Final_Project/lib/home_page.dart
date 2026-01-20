import 'package:flutter/material.dart';
import 'package:sad/gridview_page.dart';
import 'package:sad/profile_page.dart';
import 'package:sad/note_page.dart';
import 'package:sad/cart_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sad/widgets/toy_animation.dart';
import 'cart_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _supabase = Supabase.instance.client;

  // Central cart instance for the app
  final Cart cart = Cart();

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    final res = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text("Mini Marvels"),
        backgroundColor: Colors.pink[300],
        actions: [
          IconButton(
            onPressed: () {
              _supabase.auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
          //  Cart icon
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),

      //  BACKGROUND ANIMATION EVERYWHERE
      body: Stack(
        children: [
          //  LEFT SIDE TOYS
          FloatingToy(icon: Icons.toys, left: width * 0.10, top: 100),
          FloatingToy(icon: Icons.child_friendly, left: width * 0.20, top: 220),
          FloatingToy(icon: Icons.star, left: width * 0.10, top: 340),
          FloatingToy(icon: Icons.favorite, left: width * 0.20, top: 460),

          //  RIGHT SIDE TOYS
          FloatingToy(icon: Icons.toys, left: width * 0.75, top: 100),
          FloatingToy(icon: Icons.child_friendly, left: width * 0.85, top: 220),
          FloatingToy(icon: Icons.star, left: width * 0.75, top: 340),
          FloatingToy(icon: Icons.favorite, left: width * 0.85, top: 460),

          //  ORIGINAL CONTENT (UNCHANGED)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- PROFILE INFO CARD ---
                  FutureBuilder(
                    future: getCurrentUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return const Text("No User Found!!");
                      }

                      final profile = snapshot.data as Map<String, dynamic>;

                      return Card(
                        color: Colors.pink[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              if (profile['avatar_url'] != null)
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    profile['avatar_url'],
                                  ),
                                )
                              else
                                const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.person, size: 50),
                                ),
                              const SizedBox(height: 10),
                              Text(
                                profile['name'] ?? "Name",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                profile['email'] ?? "Email",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // --- PROFILE BUTTON ---
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person),
                    label: const Text("Profile"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- PRODUCTS BUTTON ---
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GridviewPage(cart: cart), // pass cart
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text("Products"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- FEEDBACK / CRUD BUTTON ---
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.note),
                    label: const Text("FeedBack"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
