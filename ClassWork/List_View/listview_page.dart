import 'package:flutter/material.dart';

class ListviewPage extends StatelessWidget {
  const ListviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    var myItems = [
      {
        "img":
            "https://th.bing.com/th/id/R.f90d7459a0f301600c4a2b739e749a6e?rik=Y0GHs6GdfeUiYQ&riu=http%3a%2f%2fwallpapercave.com%2fwp%2fxl8hSG3.jpg&ehk=sMyZ8P%2bMQCPk4VCtZzqZ5TcUxpGpWYlTkYMqnpZpp%2f4%3d&risl=&pid=ImgRaw&r=0",
        "title": "Nature",
      },
      {
        "img":
            "https://wallpapers.com/images/featured/dark-abstract-bsid6neh0qavpfd1.jpg",
        "title": "Dark",
      },
      {
        "img":
            "https://tse2.mm.bing.net/th/id/OIP.TBgputtbs37sPvdbItflHgHaFj?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3",
        "title": "Sky",
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("List View Page"),
        backgroundColor: const Color.fromARGB(255, 68, 87, 118),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: myItems.length,
        itemBuilder: (context, index) {
          return Card(
            child: Row(
              children: [
                Image.network(myItems[index]['img']!, height: 100, width: 100),
                SizedBox(width: 40),
                Text(myItems[index]['title']!),
              ],
            ),
          );
        },
      ),
    );
  }
}
