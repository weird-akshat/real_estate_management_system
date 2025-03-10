import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/owned_property_card.dart';
import 'package:real_estate_management_system/pages/property_listing_page.dart';

//we'll just use the copy of the property cards, but in the property details page equivalent, we'll add the option to edit

class OwnedPropertyPage extends StatelessWidget {
  const OwnedPropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(
          'Owned Properties',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/loginbackground.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                OwnedPropertyCard(image: 'housepic.jpg'),
                OwnedPropertyCard(image: 'housepic2.jpeg'),
                OwnedPropertyCard(image: 'housepic3.jpeg')
              ],
            ),
          )
        ],
      ),
    );
  }
}
