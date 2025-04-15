import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_management_system/pages/owned_properties_provider.dart';
import 'package:real_estate_management_system/pages/owned_property_details_page.dart';

class OwnedPropertyCard extends StatelessWidget {
  final int index;
  final int propertyId;
  final String propertyName;
  final String numBed;
  final String area;
  final String price;
  final VoidCallback onRefresh;

  const OwnedPropertyCard({
    super.key,
    required this.index,
    required this.propertyId,
    required this.price,
    required this.area,
    required this.numBed,
    required this.propertyName,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final imageRelative =
        Provider.of<OwnedPropertiesProvider>(context, listen: false)
                .images[propertyId]
                ?.first ??
            '';
    final imageUrl = imageRelative.isNotEmpty
        ? 'https://real-estate-flask-api.onrender.com$imageRelative'
        : 'https://via.placeholder.com/150';

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OwnedPropertyDetailsPage(index),
        ));
        onRefresh();
      },
      child: Card(
        color: Color(0xffd8e2dc),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.black, width: 0)),
        surfaceTintColor: Colors.white70,
        margin: EdgeInsets.all(10),
        elevation: 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  )),
            ),
            Text(
              propertyName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(children: [Icon(Icons.bed), Text(numBed)]),
                  Row(children: [Icon(Icons.pin_drop), Text(area)]),
                  Row(children: [Icon(Icons.currency_rupee), Text(price)]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
