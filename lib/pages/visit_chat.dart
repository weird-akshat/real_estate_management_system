import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_management_system/pages/make_offer.dart';
import 'package:real_estate_management_system/pages/make_visit.dart.dart';

class VisitChat extends StatefulWidget {
  final String buyerId;
  final int propertyId;
  const VisitChat({super.key, required this.buyerId, required this.propertyId});

  @override
  State<VisitChat> createState() => _NegotiationChatState();
}

class _NegotiationChatState extends State<VisitChat> {
  Future confirmVisit(int visitId) async {
    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/update_visit_status/$visitId');

    final response = await http.put(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      return true;
    } else {
      print("error");
    }
  }

  List<Map<String, dynamic>> kist = [];
  void _showDateTimePicker(BuildContext context) async {
    DateTime now = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    DateTime selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    Map<String, dynamic> newVisit = {
      "property_id": widget.propertyId,
      "user_id": widget.buyerId,
      "status": "request",
      "date_and_time": selectedDateTime.toString(),
      "made_by": "buyer",
    };

    await makeVisit(newVisit);

    kist.add(newVisit);
    setState(() {});
    // _showPopupDialog(context, selectedDateTime);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      List<Map<String, dynamic>> fetchedList = await fetchVisits();
      setState(() {
        kist = fetchedList;
        print(kist);
      });
    });
  }

  void refresh() {
    setState(() {});
  }

  void showVisitConfirmationDialog(BuildContext context, int visitId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Visit"),
          content: Text("Do you want to confirm this visit?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                bool success = await confirmVisit(visitId);
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Visit confirmed successfully")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to confirm visit")),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text("Accept"),
            ),
          ],
        );
      },
    );
  }
  //since i have all the visits scheduled between a pers
  //since i have all the visits scheduled between a person and a property
  //i need a dialogue box essentially? that'll show the date essentially

  // Function to show the Make Offer Dialog

  Future<List<Map<String, dynamic>>> fetchVisits() async {
    String userId = widget.buyerId;
    int propId = widget.propertyId;
    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/get_visits/$propId/$userId');

    final response = await http.get(url);
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Expected a list but got something else');
      }
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: kist.length,
              itemBuilder: (context, index) {
                if (kist[index]['made_by'] != 'buyer') {
                  return GestureDetector(
                    onTap: () {
                      showVisitConfirmationDialog(
                          context, kist[index]['visit_id']);
                    },
                    child: DateChatBox(
                        status: kist[index]['status'],
                        date: DateTime.parse(kist[index]['date_and_time']),
                        isUser: kist[index]['made_by'] == 'buyer'),
                  );
                }
                return DateChatBox(
                    status: kist[index]['status'],
                    date: DateTime.parse(kist[index]['date_and_time']),
                    isUser: kist[index]['made_by'] == 'buyer');
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    // await addVisits();
                    _showDateTimePicker(context);
                  },
                  child: Text('Request Visit')),
            ],
          )
        ],
      ),
    );
  }
}

class DateChatBox extends StatelessWidget {
  final DateTime date;
  final bool isUser;
  final String status;

  const DateChatBox(
      {super.key,
      required this.date,
      required this.isUser,
      required this.status});

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE, MMM d, yyyy • hh:mm a').format(date);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: status == 'confirmed'
              ? Colors.lightGreenAccent
              : (isUser
                  ? Colors.lightBlueAccent.withOpacity(0.9)
                  : Colors.redAccent.withOpacity(0.9)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time_filled,
              color: Colors.white70,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              formattedDate,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//okay cool the visit chat is ready

//now i need to add the button to request visits in the property_details page