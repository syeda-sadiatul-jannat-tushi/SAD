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
        backgroundColor: Color.fromARGB(255, 104, 60, 60),
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
                child: Icon(Icons.person, size: 40, color: Color.fromARGB(255, 104, 60, 60)),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home, color: Color.fromARGB(255, 104, 60, 60)),
              title: const Text("Home"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.person, color: Color.fromARGB(255, 104, 60, 60)),
              title: const Text("Profile"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.settings, color: Color.fromARGB(255, 104, 60, 60)),
              title: const Text("Settings"),
              onTap: () {},
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Color.fromARGB(255, 104, 60, 60)),
              title: const Text("Logout"),
              onTap: () {},
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color.fromARGB(255, 104, 60, 60),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Welcome to Tushi's page!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 104, 60, 60),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Explore your dashboard below.",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(179, 143, 108, 108),
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
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
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
