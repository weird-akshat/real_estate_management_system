import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/favorite_body_property_card.dart';
import 'package:real_estate_management_system/pages/filter_page.dart';
import 'package:real_estate_management_system/pages/property_listing_page.dart';

class FavoriteBodyPropertyList extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  const FavoriteBodyPropertyList(
    this.list, {
    super.key,
  });

  @override
  State<FavoriteBodyPropertyList> createState() =>
      _FavoriteBodyPropertyListState();
}

class _FavoriteBodyPropertyListState extends State<FavoriteBodyPropertyList> {
  void refreshPage() {
    setState(() {});
  }

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
        Expanded(
          child: ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                return FavoriteBodyPropertyCard(
                  index: index,
                  propertyId: widget.list[index]['property_id'],
                  price: widget.list[index]['price'],
                  area: widget.list[index]['area'],
                  numBed: widget.list[index]['bedrooms'],
                  propertyName: widget.list[index]['name'],
                  onRefresh: refreshPage,
                );
              }),
        )
      ],
    );
  }
}
