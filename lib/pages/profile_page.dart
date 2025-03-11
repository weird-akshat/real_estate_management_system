import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  final String name = 'John Doe';
  final String phoneNumber = '+1 234 567 890';
  final String city = 'New York';
  final String state = 'NY';
  final String country = 'USA';
  final String email = 'john.doe@example.com';
  final String password = '******';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                                width: 4,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.blue[100],
                              child: Text(
                                name.substring(0, 1),
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ProfileSectionHeader(title: 'Contact Information'),
                      ProfileField(
                        fieldName: 'Phone',
                        fieldValue: phoneNumber,
                        icon: Icons.phone,
                      ),
                      ProfileField(
                        fieldName: 'Email',
                        fieldValue: email,
                        icon: Icons.email,
                      ),
                      ProfileSectionHeader(title: 'Location'),
                      ProfileField(
                        fieldName: 'City',
                        fieldValue: city,
                        icon: Icons.location_city,
                      ),
                      ProfileField(
                        fieldName: 'State',
                        fieldValue: state,
                        icon: Icons.map,
                      ),
                      ProfileField(
                        fieldName: 'Country',
                        fieldValue: country,
                        icon: Icons.public,
                      ),
                      ProfileSectionHeader(title: 'Security'),
                      ProfileField(
                        fieldName: 'Password',
                        fieldValue: password,
                        icon: Icons.security,
                        isPassword: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return EditProfilePage();
                      }));
                    },
                    icon: Icon(Icons.edit),
                    label: Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileSectionHeader extends StatelessWidget {
  final String title;

  const ProfileSectionHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[700],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String fieldName;
  final String fieldValue;
  final IconData icon;
  final bool isPassword;

  const ProfileField({
    Key? key,
    required this.fieldName,
    required this.fieldValue,
    required this.icon,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.blue[700],
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fieldName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  fieldValue,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(Icons.visibility, color: Colors.grey),
              onPressed: () {
                // Implement password visibility toggle
              },
            )
          else
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onPressed: () {
                // Implement edit specific field
              },
            ),
        ],
      ),
    );
  }
}
