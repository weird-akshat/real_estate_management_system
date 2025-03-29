import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_management_system/pages/favorite_provider.dart';
import 'package:real_estate_management_system/pages/negotiation_chat.dart';
import 'package:real_estate_management_system/pages/owned_properties_provider.dart';
import 'package:real_estate_management_system/pages/owner_negotiation_chat.dart';
import 'package:real_estate_management_system/pages/owner_visit_chat.dart';
import 'package:real_estate_management_system/property_details_provider.dart';
import 'package:http/http.dart' as http;

class OwnedPropertyDetailsPage extends StatefulWidget {
  final int index;
  const OwnedPropertyDetailsPage(this.index, {super.key});

  @override
  State<OwnedPropertyDetailsPage> createState() =>
      _OwnedPropertyDetailsPageState();
}

class _OwnedPropertyDetailsPageState extends State<OwnedPropertyDetailsPage> {
  bool isFavorite = true;

  List<Map<String, dynamic>> kist = [];
  List<Map<String, dynamic>> cist = [];
  // @override
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      List<Map<String, dynamic>> fetchedList = await fetchBuyers();
      List<Map<String, dynamic>> fetchedList1 = await fetchVisitors();
      print(fetchedList);
      setState(() {
        kist = fetchedList;
        cist = fetchedList1;

        // print(list);
        // print(list);
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchBuyers() async {
    int propertyId =
        Provider.of<OwnedPropertiesProvider>(context, listen: false)
            .properties[widget.index]['property_id'];
    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/property_buyers/$propertyId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print(data);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    return []; // Return an empty list instead of null
  }

  Future<List<Map<String, dynamic>>> fetchVisitors() async {
    int propertyId =
        Provider.of<OwnedPropertiesProvider>(context, listen: false)
            .properties[widget.index]['property_id'];
    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/property/$propertyId/visitors');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print(data);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    return []; // Return an empty list instead of null
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive text scaling
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final provider =
        Provider.of<OwnedPropertiesProvider>(context, listen: false);
    final propertyId = (provider.properties.isNotEmpty &&
            widget.index < provider.properties.length)
        ? provider.properties[widget.index]['property_id'] as int?
        : null;

    final imageUrl = (propertyId != null &&
            provider.images[propertyId] != null &&
            provider.images[propertyId]!.isNotEmpty)
        ? provider.images[propertyId]![0]
        : 'https://via.placeholder.com/150';

    final list = provider.properties[widget.index];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/loginbackground.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              // Safe Area with Scrollable Content
              SafeArea(
                child: CustomScrollView(
                  slivers: [
                    // Flexible App Bar with Image and Back Button
                    SliverAppBar(
                      expandedHeight: screenHeight * 0.4,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24 * textScaleFactor,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),

                    // Main Content
                    SliverPadding(
                      padding: EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Property Name and Price
                          Text(
                            list['name'],
                            style: TextStyle(
                                fontSize: 30 * textScaleFactor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            list['price'],
                            style: TextStyle(
                                fontSize: 25 * textScaleFactor,
                                fontWeight: FontWeight.bold),
                          ),

                          // Description Section
                          _buildSectionTitle(
                              context, 'Description', textScaleFactor),
                          Card(
                            elevation: 5,
                            color: Color.fromARGB(176, 247, 245, 159),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                list['description'],
                                style:
                                    TextStyle(fontSize: 17 * textScaleFactor),
                              ),
                            ),
                          ),

                          // Overview Section
                          _buildSectionTitle(
                              context, 'Overview', textScaleFactor),
                          Card(
                            color: Color.fromRGBO(187, 208, 255, 1),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child:
                                  _buildOverviewContent(list, textScaleFactor),
                            ),
                          ),

                          // Contact Details
                          _buildSectionTitle(
                              context, 'Contact Details', textScaleFactor),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Phone Number',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18 * textScaleFactor)),
                                  Text(list['contact_number'],
                                      style: TextStyle(
                                          fontSize: 16 * textScaleFactor)),
                                  SizedBox(height: 8),
                                  Text('Email',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18 * textScaleFactor)),
                                  Text(list['email'],
                                      style: TextStyle(
                                          fontSize: 16 * textScaleFactor)),
                                ],
                              ),
                            ),
                          ),
                          _buildSectionTitle(
                              context, 'Prospective Buyers', textScaleFactor),
                          Column(
                            children: List.generate(
                              kist.length,
                              (index) => BuyerProfileCard(
                                name: kist[index]['name'],
                                phone: kist[index]['phone'],
                                propertyId: propertyId!,
                                buyerId: kist[index]['user_id'],
                                email: kist[index]['email'],
                              ),
                            ),
                          ),
                          _buildSectionTitle(
                              context, 'Visitors', textScaleFactor),

                          Column(
                            children: List.generate(
                                cist.length,
                                (index) => VisitorProfileCard(
                                    name: cist[index]['name'],
                                    phone: cist[index]['phone'],
                                    email: cist[index]['email'],
                                    buyerId: cist[index]['user_id'],
                                    propertyId: propertyId!)),
                          ),

                          // Action Buttons
                          SizedBox(height: 16),
                          // _buildActionButtons(context),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper method to create section titles
  Widget _buildSectionTitle(
      BuildContext context, String title, double textScaleFactor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 25 * textScaleFactor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> removeFavorite(
      OwnedPropertiesProvider provider, int index) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final propertyId = provider.properties[index]['property_id'];

    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/remove_favorite?user_id=$userId&property_id=$propertyId');

    final response = await http.delete(
      url,
      headers: {
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      debugPrint("Success: ${response.body}");
    } else {
      debugPrint("Error: ${response.statusCode} - ${response.body}");
    }
  }

  Future<void> addFavorite(PropertyDetailsProvider provider) async {
    final url =
        Uri.parse('https://real-estate-flask-api.onrender.com/add_favorite');

    Map<String, dynamic> data = {
      "user_id": FirebaseAuth.instance.currentUser?.uid,
      "property_id": provider.list[widget.index]['property_id']
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("Success: ${response.body}");
    } else {
      debugPrint("Error: ${response.statusCode} - ${response.body}");
    }
  }

  // Overview content with three columns
  Widget _buildOverviewContent(
      Map<String, dynamic> list, double textScaleFactor) {
    final textSize = 17 * textScaleFactor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconText(Icons.house, list['property_type'], textSize),
            _buildIconText(Icons.price_change, list['price'], textSize),
            _buildIconText(Icons.location_city, list['city'], textSize),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconText(Icons.square_foot, list['area'], textSize),
            _buildIconText(Icons.bed, list['bedrooms'], textSize),
            _buildIconText(Icons.balcony, list['balcony'], textSize),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconText(Icons.local_parking, list['parking'], textSize),
            _buildIconText(Icons.location_on, list['state'], textSize),
            _buildIconText(Icons.flag, list['country'], textSize),
          ],
        ),
      ],
    );
  }

// Helper method to create icon and text row
  Widget _buildIconText(IconData icon, String text, double textSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: textSize + 4),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: textSize)),
        ],
      ),
    );
  }

// Action buttons at the bottom
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: !isFavorite
                    ? ElevatedButton(
                        onPressed: () async {
                          await addFavorite(
                              Provider.of<PropertyDetailsProvider>(context,
                                  listen: false));

                          isFavorite = true;
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffff8fa3),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Add to Favourites',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          await removeFavorite(
                              Provider.of<OwnedPropertiesProvider>(context,
                                  listen: false),
                              widget.index);
                          isFavorite = false;
                          Provider.of<FavoriteProvider>(context, listen: false)
                              .removePropertyFromApi(
                                  Provider.of<FavoriteProvider>(context,
                                          listen: false)
                                      .list[widget.index]['property_id']);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff4a90e2),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Remove from Favourites',
                          style: TextStyle(color: Colors.white),
                        ),
                      ))),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Show Interest',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BuyerProfileCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String buyerId;
  final int propertyId;

  const BuyerProfileCard(
      {super.key,
      required this.name,
      required this.phone,
      required this.email,
      required this.buyerId,
      required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OwnerNegotiationChat(
                buyerId: buyerId, propertyId: propertyId)));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.lightBlue.shade100,
                child: Icon(LucideIcons.user, size: 30, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(LucideIcons.phone,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(phone, style: TextStyle(color: Colors.grey[700])),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(LucideIcons.mail, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(email, style: TextStyle(color: Colors.grey[700])),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VisitorProfileCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String buyerId;
  final int propertyId;

  const VisitorProfileCard(
      {super.key,
      required this.name,
      required this.phone,
      required this.email,
      required this.buyerId,
      required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                OwnerVisitChat(buyerId: buyerId, propertyId: propertyId)));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.lightBlue.shade100,
                child: Icon(LucideIcons.user, size: 30, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(LucideIcons.phone,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(phone, style: TextStyle(color: Colors.grey[700])),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(LucideIcons.mail, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(email, style: TextStyle(color: Colors.grey[700])),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
