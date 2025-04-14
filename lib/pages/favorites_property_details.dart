import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_management_system/pages/favorite_provider.dart';
import 'package:real_estate_management_system/pages/image_view_screen.dart';
import 'package:real_estate_management_system/pages/make_offer.dart';
import 'package:real_estate_management_system/pages/make_visit.dart.dart';
import 'package:real_estate_management_system/pages/negotiation_chat.dart';
import 'package:real_estate_management_system/property_details_provider.dart';
import 'package:http/http.dart' as http;

class FavoritesPropertyDetails extends StatefulWidget {
  final int index;
  const FavoritesPropertyDetails(this.index, {super.key});

  @override
  State<FavoritesPropertyDetails> createState() =>
      _FavoritesPropertyDetailsPageState();
}

class _FavoritesPropertyDetailsPageState
    extends State<FavoritesPropertyDetails> {
  bool isFavorite = true;
  // @override
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive text scaling
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    final propertyId =
        (provider.list.isNotEmpty && widget.index < provider.list.length)
            ? provider.list[widget.index]['property_id'] as int?
            : null;

    final imagePath = (propertyId != null &&
            provider.images[propertyId] != null &&
            provider.images[propertyId]!.isNotEmpty)
        ? provider.images[propertyId]![0]
        : null;

    final imageUrl = imagePath != null
        ? 'https://real-estate-flask-api.onrender.com$imagePath'
        : 'https://via.placeholder.com/150';

    final list = provider.list[widget.index];

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
                        background: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ImageViewScreen(propertyId!)));
                          },
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
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
                            '₹${list['price']}',
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

                          // Action Buttons
                          SizedBox(height: 16),
                          _buildActionButtons(context),
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

  Future<void> removeFavorite(FavoriteProvider provider, int index) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final propertyId = provider.list[index]['property_id'];

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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconText(Icons.place, list['area'], textSize),
              _buildIconText(Icons.house, list['property_type'], textSize),
              _buildIconText(
                  // ignore: prefer_interpolation_to_compose_strings
                  Icons.bed,
                  'Bedrooms: ' + list['bedrooms'],
                  textSize),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIconText(Icons.location_city, list['city'], textSize),
                _buildIconText(
                    Icons.price_change, list['price'].toString(), textSize),
                _buildIconText(
                    // ignore: prefer_interpolation_to_compose_strings
                    Icons.balcony,
                    'Balconies: ' + list['balcony'],
                    textSize),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconText(Icons.map, list['state'], textSize),
              _buildIconText(Icons.flag, list['country'], textSize),
              _buildIconText(
                  // ignore: prefer_interpolation_to_compose_strings
                  Icons.local_parking,
                  // ignore: prefer_interpolation_to_compose_strings
                  'Parking: ' + list['parking'],
                  textSize),
            ],
          ),
        ],
      ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showMakeOfferDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Make Offer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showDateTimePicker(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Request Visit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
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
                                  Provider.of<FavoriteProvider>(context,
                                      listen: false),
                                  widget.index);
                              isFavorite = false;
                              Provider.of<FavoriteProvider>(context,
                                      listen: false)
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
          ],
        ),
      ],
    );
  }

  void _showMakeOfferDialog() {
    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MakeOfferDialog(
          propertyId: provider.list[widget.index]['property_id'],
          buyerId: FirebaseAuth.instance.currentUser!.uid,
          list: provider.list,
          refresh: () {
            setState(() {});
          },
          onOfferSubmitted: (double amount) async {
            // Create a new offer
            final newOffer = {
              "property_id": provider.list[widget.index]['property_id'],
              "buyer_id": FirebaseAuth.instance.currentUser!.uid,
              "amount": amount,
              "offer_status": "pending",
              "offer_date": DateTime.now().toString(),
              "made_by": "buyer",
            };
            await makeOffer(newOffer);
            // Add the new offer to the list
            setState(() {
              // list.add(newOffer);
            });

            // Close the dialog
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showDateTimePicker(BuildContext context) async {
    final provider =
        Provider.of<PropertyDetailsProvider>(context, listen: false);
    DateTime now = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    DateTime selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    Map<String, dynamic> newVisit = {
      "property_id": provider.list[widget.index]['property_id'],
      "user_id": FirebaseAuth.instance.currentUser!.uid,
      "status": "request",
      "date_and_time": selectedDateTime.toString(),
      "made_by": "buyer",
    };

    await makeVisit(newVisit);

    // kist.add(newVisit);
    // setState(() {});
    // _showPopupDialog(context, selectedDateTime);
  }
}
