import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/filter_page.dart';

import 'package:real_estate_management_system/pages/property_details.dart';

late Widget chip1, chip2, chip3, chip4;

class PropertyListingPage extends StatefulWidget {
  const PropertyListingPage({super.key});

  @override
  State<PropertyListingPage> createState() => _PropertyListingPageState();
}

class _PropertyListingPageState extends State<PropertyListingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BodyPropertyList());
  }
}

class SidebarButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icondata;
  final String text;
  final Widget widget;

  const SidebarButton(
    this.icondata,
    this.text,
    this.widget, {
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap,
        style: ButtonStyle(
          iconSize: WidgetStatePropertyAll(5),
        ),
        child: Row(
          children: [
            Icon(
              icondata,
              size: 40,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}

class BodyPropertyList extends StatefulWidget {
  const BodyPropertyList({
    super.key,
  });

  @override
  State<BodyPropertyList> createState() => _BodyPropertyListState();
}

class _BodyPropertyListState extends State<BodyPropertyList> {
  @override
  void initState() {
    super.initState();
    chip1 = CategoryChip(
      label: 'Houses',
      color: Colors.black,
    );
    // chip1.color = Colors.black;
    chip2 = CategoryChip(
      label: 'Offices',
      color: Colors.white,
    );
    chip3 = CategoryChip(label: 'Appartments', color: Colors.white);
    chip4 = CategoryChip(
      label: 'Bunglows',
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  focusColor: Colors.black,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Location',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(58, 58)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                    backgroundColor: WidgetStatePropertyAll(
                        const Color.fromARGB(218, 12, 12, 12)),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PropertyFilterPage();
                    }));
                  },
                  child: Icon(
                    Icons.tune,
                    color: Colors.white,
                  )),
            )
          ],
        ),
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
        Categories(),
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
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          chip1,
          SizedBox(
            width: 15,
          ),
          chip2,
          SizedBox(
            width: 15,
          ),
          chip3,
          SizedBox(
            width: 15,
          ),
          chip4
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PropertyDetailsPage();
        }));
      },
      child: Container(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryChip extends StatefulWidget {
  final Color color;
  final String label;
  const CategoryChip({super.key, required this.label, required this.color});

  @override
  State<CategoryChip> createState() => _CategoryChipState(color);
}

class _CategoryChipState extends State<CategoryChip> {
  _CategoryChipState(this.color);
  late Color color;
  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        color = color == Colors.white ? Colors.black : Colors.white;
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Chip(
          backgroundColor: color,
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all((Radius.circular(14)))),
          label: Text(
            widget.label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color == Colors.white ? Colors.black : Colors.white),
          ),
          padding: EdgeInsets.all(15),
        ),
      ),
    );
  }
}
