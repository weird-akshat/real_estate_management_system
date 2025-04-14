import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_management_system/pages/favorite_provider.dart';

import 'package:real_estate_management_system/pages/favorites_property_details.dart';
import 'package:real_estate_management_system/property_details_provider.dart';

class FavoriteBodyPropertyCard extends StatelessWidget {
  final int index;
  final int propertyId;
  final String propertyName;
  final String numBed;
  final String area;
  final double price;
  final VoidCallback onRefresh;
  const FavoriteBodyPropertyCard(
      {super.key,
      required this.index,
      required this.propertyId,
      required this.price,
      required this.area,
      required this.numBed,
      required this.propertyName,
      required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    final propertyId =
        (provider.list.isNotEmpty && index < provider.list.length)
            ? provider.list[index]['property_id'] as int?
            : null;

    final imagePath = (propertyId != null &&
            provider.images[propertyId] != null &&
            provider.images[propertyId]!.isNotEmpty)
        ? provider.images[propertyId]![0]
        : null;

    final imageUrl = imagePath != null
        ? 'https://real-estate-flask-api.onrender.com$imagePath'
        : 'https://via.placeholder.com/150';

    // print('hey');
    // print(Provider.of<FavoriteProvider>(context, listen: false)
    //     .images[propertyId]);
    // print('hey2');
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return FavoritesPropertyDetails(index);
        }));
        onRefresh();
      },
      child: Container(
        decoration: BoxDecoration(),
        // color: Colors.black87,
        // borderRadius: BorderRadius.circular(20),
        child: Card(
          color: Color(0xcfd8e2dc),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.black, width: 0)),
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
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )

                      // child: Image.network(image)
                      )),
              Text(
                propertyName,
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
                        Text(numBed),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.pin_drop),
                        Text(area),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.currency_rupee),
                        Text(price.toString()),
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
