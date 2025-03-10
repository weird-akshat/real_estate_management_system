import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/loginbackground.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  Text(
                    'Add the photos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  // SizedBox(height: 10),
                  SizedBox(
                    height: 290,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: 6,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildAddImageButton();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  InfoField(text: 'Property Name', iconData: Icons.home),
                  InfoField(text: 'Location', iconData: Icons.location_on),
                  InfoField(text: 'Price', iconData: Icons.currency_rupee),
                  InfoField(text: 'Ownership Type', iconData: Icons.business),
                  InfoField(text: 'Area', iconData: Icons.square_foot),
                  InfoField(text: 'Configuration', iconData: Icons.weekend),
                  InfoField(text: 'Number of Bedrooms', iconData: Icons.bed),
                  InfoField(
                      text: 'Number of Bathrooms', iconData: Icons.bathroom),
                  InfoField(text: 'Owner Name', iconData: Icons.person),
                  InfoField(text: 'Owner\'s email', iconData: Icons.mail),
                  InfoField(
                      text: 'Owner\'s Phone Number', iconData: Icons.phone),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: TextButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                          ),
                          backgroundColor:
                              const WidgetStatePropertyAll(Colors.black),
                          fixedSize:
                              const WidgetStatePropertyAll(Size(300, 50)),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(Icons.add, size: 40, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  final String text;
  final IconData iconData;
  const InfoField({super.key, required this.text, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(iconData),
          hintText: text,
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
