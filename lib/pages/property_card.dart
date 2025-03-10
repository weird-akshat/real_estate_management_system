import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/property_details.dart';

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
