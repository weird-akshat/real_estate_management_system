import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/add_property_page.dart';
import 'package:real_estate_management_system/pages/favorites_page.dart';
import 'package:real_estate_management_system/pages/owned_property_page.dart';
import 'package:real_estate_management_system/pages/property_listing_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Widget currentBody;
  late String appBarHeading;
  late int x;
  @override
  void initState() {
    super.initState();
    currentBody = BodyPropertyList();
    appBarHeading = "Properties";
    x = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            x = index;
            if (index == 0) {
              setState(() {
                currentBody = BodyPropertyList();
                appBarHeading = "Properties";
              });
            } else {
              setState(() {
                currentBody = FavoritesPage();
                appBarHeading = "Favorites";
              });
            }
          },
          backgroundColor: Colors.black,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: x == 0 ? Colors.white : Colors.blueGrey,
                ),
                label: ""),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  setState(() {
                    currentBody = FavoritesPage();
                    appBarHeading = "Favorites";
                    x = 1;
                  });
                },
                child: Icon(
                  Icons.favorite,
                  color: x == 1 ? Colors.white : Colors.blueGrey,
                ),
              ),
              label: "",
            )
          ]),
      appBar: AppBar(
        title: Text(
          appBarHeading,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 40, 0, 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 29,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Profile',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 20,
          ),
          SidebarButton(
            Icons.home,
            'See Properties',
            PropertyListingPage(),
            onTap: () {
              Navigator.pop(context); // Close drawer first

              if (currentBody.runtimeType != PropertyListingPage) {
                setState(() {
                  currentBody = PropertyListingPage();
                  appBarHeading = "Properties";
                  x = 0;
                });
              }
            },
          ),
          SidebarButton(
            Icons.business,
            'Sell Property',
            AddPropertyPage(),
            onTap: () {
              Navigator.pop(context);

              if (currentBody.runtimeType != AddPropertyPage) {
                setState(() {
                  currentBody = AddPropertyPage();
                  appBarHeading = "Sell Property";
                  x = 3;
                });
              }
            },
          ),
          SidebarButton(
            Icons.key,
            'Owned Properties',
            OwnedPropertyPage(),
            onTap: () {
              Navigator.pop(context);

              if (currentBody.runtimeType != OwnedPropertyPage) {
                setState(() {
                  currentBody = OwnedPropertyPage();
                  appBarHeading = "Owned Properties";
                  x = 3;
                });
              }
            },
          ),
        ],
      )),
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/loginbackground.jpg',
            fit: BoxFit.cover,
          ),
        ),
        currentBody
      ]),
    );
  }
}
