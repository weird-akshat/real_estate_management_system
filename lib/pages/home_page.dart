import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_management_system/pages/add_property_page.dart';
import 'package:real_estate_management_system/pages/favorites_page.dart';
import 'package:real_estate_management_system/pages/negotiation_page.dart';
import 'package:real_estate_management_system/pages/owned_property_page.dart';
import 'package:real_estate_management_system/pages/profile_page.dart';
import 'package:real_estate_management_system/pages/property_listing_page.dart';
import 'package:real_estate_management_system/pages/propertyid_provider.dart';
import 'package:real_estate_management_system/pages/visit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class SidebarButton extends StatelessWidget {
  final IconData icondata;
  final String text;
  final Widget page;
  final VoidCallback onTap;

  const SidebarButton(
    this.icondata,
    this.text,
    this.page, {
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icondata, color: Colors.black87),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black54),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }
}

class _HomePageState extends State<HomePage> {
  late Widget currentBody;
  late String appBarHeading;
  late int x;
  @override
  void initState() {
    super.initState();
    currentBody = PropertyListingPage();
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
                currentBody = PropertyListingPage();
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
            ),
          ]),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    SidebarButton(Icons.person, 'Profile Page', ProfilePage(),
                        onTap: () {
                      Navigator.pop(context);
                      if (currentBody.runtimeType != ProfilePage) {
                        setState(() {
                          currentBody = ProfilePage();
                          appBarHeading = "Profile";
                          x = 3;
                        });
                      }
                    }),
                    SidebarButton(
                        Icons.home, 'See Properties', PropertyListingPage(),
                        onTap: () {
                      Navigator.pop(context);
                      if (currentBody.runtimeType != PropertyListingPage) {
                        setState(() {
                          currentBody = PropertyListingPage();
                          appBarHeading = "Properties";
                          x = 0;
                        });
                      }
                    }),
                    SidebarButton(
                      Icons.business,
                      'Sell Property',
                      ChangeNotifierProvider(
                        create: (context) => PropertyidProvider(),
                        child: AddPropertyPage(),
                      ),
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
                        Icons.key, 'Owned Properties', OwnedPropertyPage(),
                        onTap: () {
                      Navigator.pop(context);
                      if (currentBody.runtimeType != OwnedPropertyPage) {
                        setState(() {
                          currentBody = OwnedPropertyPage();
                          appBarHeading = "Owned Properties";
                          x = 3;
                        });
                      }
                    }),
                    SidebarButton(
                        Icons.currency_rupee, 'Negotiation', NegotiationPage(),
                        onTap: () {
                      Navigator.pop(context);
                      if (currentBody.runtimeType != NegotiationPage) {
                        setState(() {
                          currentBody = NegotiationPage();
                          appBarHeading = "Negotiation Page";
                          x = 3;
                        });
                      }
                    }),
                    SidebarButton(Icons.house_siding_sharp, 'Schedule Visits',
                        VisitPage(), onTap: () {
                      Navigator.pop(context);
                      if (currentBody.runtimeType != VisitPage) {
                        setState(() {
                          currentBody = VisitPage();
                          appBarHeading = "Schedule Visits";
                          x = 3;
                        });
                      }
                    }),
                  ],
                ),
              ),
            ),
            SidebarButton(Icons.logout, 'LogOut', widget, onTap: () async {
              Navigator.of(context).pop();
              await FirebaseAuth.instance.signOut();
            }),
            SizedBox(height: 20),
          ],
        ),
      ),
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg2.jpg',
            fit: BoxFit.cover,
          ),
        ),
        currentBody
      ]),
    );
  }
}
