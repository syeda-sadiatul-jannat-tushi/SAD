import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    const darkRed = Color.fromARGB(255, 104, 60, 60);
    const lightRed = Color.fromARGB(31, 55, 16, 16);

    return Scaffold(
      backgroundColor: lightRed,

      appBar: AppBar(
        backgroundColor: darkRed,
        elevation: 4,
        title: const Text(
          "Homepage",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: const Icon(Icons.home, color: Colors.white),
        actions: const [
          Icon(Icons.settings, color: Colors.white),
          SizedBox(width: 10),
          Icon(Icons.person, color: Colors.white),
          SizedBox(width: 10),
        ],
      ),

      endDrawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: darkRed),
              accountName: const Text("Your Name"),
              accountEmail: const Text("your@email.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: darkRed),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home, color: darkRed),
              title: const Text("Home"),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: darkRed),
              title: const Text("Profile"),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: darkRed),
              title: const Text("Settings"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: darkRed),
              title: const Text("Logout"),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: darkRed,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 25),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Welcome to your page!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: darkRed,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Explore your dashboard below.",
              style: TextStyle(
                fontSize: 16,
                color: darkRed.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: GridView.count(
                crossAxisCount: 4,      
                crossAxisSpacing: 20,  
                childAspectRatio: 1,    
                children: [
                  dashboardCard(Icons.person, "Profile", darkRed),
                  dashboardCard(Icons.settings, "Settings", darkRed),
                  dashboardCard(Icons.notifications, "Notifications", darkRed),
                  dashboardCard(Icons.info, "About", darkRed),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(IconData icon, String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),    
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
