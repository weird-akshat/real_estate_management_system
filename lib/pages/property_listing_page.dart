import 'package:flutter/material.dart';

class PropertyListingPage extends StatelessWidget {
  const PropertyListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          BottomNavigationBar(backgroundColor: Colors.black, items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blueGrey,
            ),
            label: ""),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
          label: "",
        )
      ]),
      appBar: AppBar(
        leading: Icon(Icons.menu),
        actions: [
          Icon(Icons.notification_add_sharp),
          Icon(Icons.person),
        ],
      ),
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
                    onPressed: () {},
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
                CategoryChip(label: 'Appartments')
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
        surfaceTintColor: Colors.white,

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
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
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
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        padding: EdgeInsets.all(15),
      ),
    );
  }
}
