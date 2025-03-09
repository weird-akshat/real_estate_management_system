import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
    );
  }
}

class PropertyCard extends StatelessWidget {
  final String image;
  const PropertyCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      // color: Colors.black87,
      // borderRadius: BorderRadius.circular(20),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.black, width: 0.1)),
        surfaceTintColor: Colors.white70,

        margin: EdgeInsets.all(10),
        elevation: 15,
        // decoration: BoxDecoration(
        // border: Border.all(),
        // borderRadius: BorderRadius.circular(20),
        // ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/$image',
                ),
              ),
            ),
            Text(
              'Shanti Nivaas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.bed),
                    Text('3 bedroom'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.pin_drop),
                    Text('Locality'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.currency_rupee),
                    Text('46,00,000'),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
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
