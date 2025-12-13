import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HomePage"), backgroundColor: Colors.blueGrey),

      endDrawer: NavigationDrawer(
        children: [
          DrawerHeader(
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              accountName: Text("Name"),
              accountEmail: Text("Email"),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.home),
            title: Text("Homepage"),
          ),
          Divider(),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.person),
            title: Text("Profile"),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ⭐ Centered Image
            Image.asset(
              "assets/images/HP1.webp", // change if your name is different
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),

            SizedBox(height: 20),

            // ⭐ Text under Image
            Text(
              "Homepage",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Colors.blueGrey,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
