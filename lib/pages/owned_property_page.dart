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
  bool _isLoading = true;
  List<Map<String, dynamic>> list = [];

  void refreshPage() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<OwnedPropertiesProvider>(context, listen: false)
        .getOwnedProperties();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    list = Provider.of<OwnedPropertiesProvider>(context).properties;
    print(list);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : list.isEmpty
                  ? const Center(
                      child: Text('No Properties Owned'),
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return OwnedPropertyCard(
                          index: index,
                          propertyId: list[index]['property_id'],
                          price: list[index]['price'].toString(),
                          area: list[index]['area'],
                          numBed: list[index]['bedrooms'] + " BHK",
                          propertyName: list[index]['name'],
                          onRefresh: refreshPage,
                        );
                      },
                    ),
        )
      ],
    );
  }
}
