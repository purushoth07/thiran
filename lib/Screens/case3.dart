import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:thiran/common/common_widgets.dart';
import 'package:thiran/controllers/appload_controller.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:firebase_database/firebase_database.dart';

class Item {
  final String title;
  final String description;
  final String location;
  final String time;

  Item({required this.title, required this.description, required this.location, required this.time});

  factory Item.fromSnapshot(DataSnapshot snapshot) {
    final value = snapshot.value as Map<dynamic, dynamic>;
    return Item(
      title: value['title'],
      description: value['description'],
      location: value['location'],
      time: value['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'time': time,
    };
  }
}

class UseCase3 extends StatefulWidget {
  const UseCase3({Key? key}) : super(key: key);

  @override
  _UseCase3State createState() => _UseCase3State();
}

class _UseCase3State extends State<UseCase3> {
  final AppLoadController appLoadController =
  Get.put(AppLoadController.getInstance(), permanent: true);

  final databaseReference = FirebaseDatabase.instance.ref();

  List<Item> _items = [];

  @override
  void initState() {
    super.initState();

    // Listen for changes to the items in the database
    databaseReference.child('items').onChildAdded.listen((event) {
      setState(() {
        _items.add(Item.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appLoadController.themeColor,
        foregroundColor: Colors.black,
        title: heading(text: 'UseCase 3'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  heading(text: item.title, color: Colors.black),
                  SizedBox(width: 5),
                  paragraph(text: item.description),
                  SizedBox(width: 5),
                  paragraph(text: item.location),
                  SizedBox(width: 5),
                  paragraph(text: item.time)
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Your action here
          showBarModalBottomSheet(
              context: context,
              builder: (context) => const FormBottomModule()
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class FormBottomModule extends StatefulWidget {
  const FormBottomModule({Key? key}) : super(key: key);

  @override
  _FormBottomModuleState createState() => _FormBottomModuleState();
}

class _FormBottomModuleState extends State<FormBottomModule> {
  final AppLoadController appLoadController =
  Get.put(AppLoadController.getInstance(), permanent: true);

  final databaseReference = FirebaseDatabase.instance.ref();

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    var dt = DateTime.now();
    timeController.text = '${dt.day}/${dt.month}/${dt.year}  ${dt.hour}:${dt.minute}:${dt.second}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                heading(text: 'Rice Ticket'),
                const SizedBox(height: 15),
                PrimaryInputText(hintText: 'Problem Title',
                  controller: titleController,
                  onValidate: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter Problem title';
                    }
                    return null;
                  },),
                const SizedBox(height: 15),
                PrimaryInputText(hintText: 'Problem Description',
                  controller: descController,
                  maxLines: 2,
                  onValidate: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter problem description';
                    }
                    return null;
                  },),
                const SizedBox(height: 15),
                PrimaryInputText(hintText: 'Location',
                  // controller: emailController,
                  controller: locationController,
                  onValidate: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },),
                const SizedBox(height: 15),
                PrimaryInputText(hintText: 'Time',
                  controller: timeController,
                  onValidate: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter email address';
                    }
                    return null;
                  },),
              ],
            ),
          ),
        ),
      bottomNavigationBar: GestureDetector(
        onTap: (){
          if(formKey.currentState!.validate()){
            // Create the item
            final item = Item(
              title: titleController.text,
              description: descController.text,
              location: locationController.text,
              time: timeController.text,
            );

            databaseReference.child('items').push().set(item.toJson());

            // Clear the form
            titleController.clear();
            descController.clear();
            locationController.clear();
            timeController.clear();
            print('the fcm token from the submit ${appLoadController.fcmToken}');
            final message = {
              'notification': {
                'title': titleController.text,
                'body': descController.text
              },
              'data': {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              'to': appLoadController.fcmToken,
            };

            http.post(
              Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'key=AAAA2zuLCHE:APA91bGlweQ3e4fNZ62slE73NmxQ9brJyLdfs3Y7CPB1-mOYy0LceAceXu6qG3nKlLyr9w5GiqDCmmta-SJL7y851AQQKmhdKCmCoolwC-2eg3XIhlOKPLVsLMpP1gBt9eRxmjgzPsrS',
              },
              body: jsonEncode(message),
            );

            // Dismiss the modal sheet
            Navigator.pop(context);
          }
          },
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 1,
          decoration: const BoxDecoration(
            color: Colors.cyan
          ),
          child: Center(child: heading(text: 'Submit', color: Colors.white)),
        ),
      ),
    );
  }
}

