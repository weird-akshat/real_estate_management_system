import 'package:flutter/material.dart';
import 'property_listing_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/loginbackground.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CCategoryChip(label: 'Houses'),
                  SizedBox(
                    width: 15,
                  ),
                  CategoryChip(label: 'Offices'),
                  SizedBox(
                    width: 15,
                  ),
                  CategoryChip(label: 'Appartments'),
                  SizedBox(
                    width: 15,
                  ),
                  CategoryChip(label: 'Bunglows')
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    PropertyCard(image: 'housepic.jpg'),
                    PropertyCard(image: 'housepic3.jpeg'),
                    PropertyCard(image: 'housepic2.jpeg'),
                  ],
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }
}

class CCategoryChip extends StatelessWidget {
  final String label;
  const CCategoryChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Chip(
        color: WidgetStatePropertyAll(Colors.black87),
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all((Radius.circular(14)))),
        label: Text(
          label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        padding: EdgeInsets.all(15),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  const CategoryChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Chip(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all((Radius.circular(14)))),
        label: Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        padding: EdgeInsets.all(15),
      ),
    );
  }
}
