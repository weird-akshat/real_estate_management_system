import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_management_system/pages/filter_page.dart';
import 'package:real_estate_management_system/pages/owned_properties_provider.dart';
import 'package:real_estate_management_system/pages/owned_property_card.dart';
import 'package:real_estate_management_system/pages/property_listing_page.dart';

//we'll just use the copy of the property cards, but in the property details page equivalent, we'll add the option to edit

class OwnedPropertyPage extends StatefulWidget {
  const OwnedPropertyPage({super.key});

  @override
  State<OwnedPropertyPage> createState() => _OwnedPropertyPageState();
}

class _OwnedPropertyPageState extends State<OwnedPropertyPage> {
  void refreshPage() {
    setState(() {});
  }

  List<Map<String, dynamic>> list = [];
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<OwnedPropertiesProvider>(context, listen: false)
            .getOwnedProperties());
  }

  @override
  Widget build(BuildContext context) {
    list = Provider.of<OwnedPropertiesProvider>(context).properties;
    print(list);
    return Scaffold(
        body: Column(
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
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
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
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                    backgroundColor: WidgetStatePropertyAll(
                        const Color.fromARGB(218, 12, 12, 12)),
                  ),
                  onPressed: () async {
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
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return OwnedPropertyCard(
                  index: index,
                  propertyId: list[index]['property_id'],
                  price: list[index]['price'],
                  area: list[index]['area'],
                  numBed: list[index]['bedrooms'],
                  propertyName: list[index]['name'],
                  onRefresh: refreshPage,
                );
              }),
        )
      ],
    ));
  }
}
