import 'package:flutter/material.dart';

class PropertyDetailsPage extends StatelessWidget {
  const PropertyDetailsPage({super.key});
  final double textSize = 17.0;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/images/housepic3.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Building Name',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              //property type
              //price
              //location
              //area
              //number of bedrooms and bathrooms
              //balcony and terrace availablity
              //parking availability
              //contact number and email
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Price- 46,00,000',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Description',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          Card(
            elevation: 5,
            color: Color.fromARGB(176, 247, 245, 159),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Lmao this is supposed to be the property description. You write whatever the fuck you want to write about the fucking property so that people can read i guess. I hope you fucking know what a description is',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('OverView',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          Card(
              color: Color.fromRGBO(187, 208, 255, 1),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Property Type',
                            style: TextStyle(fontSize: textSize)),
                        Text('Price', style: TextStyle(fontSize: textSize)),
                        Text('Location', style: TextStyle(fontSize: textSize)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Area', style: TextStyle(fontSize: textSize)),
                        Text('B and B', style: TextStyle(fontSize: textSize)),
                        Text('Balcony', style: TextStyle(fontSize: textSize)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Parking', style: TextStyle(fontSize: textSize)),
                        Text('Contact Number',
                            style: TextStyle(fontSize: textSize)),
                        Text('Email', style: TextStyle(fontSize: textSize)),
                      ],
                    ),
                  ],
                ),
              )
              // child: GridView(
              // gridDelegate:
              // SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              // ),
              ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Contact Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text('Phone Number  Email ID'),
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xffff8fa3)),
                ),
                child: Text(
                  'Add to favourites',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                  ),
                  child: Text(
                    'Show Interest',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
