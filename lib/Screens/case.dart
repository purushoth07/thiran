import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thiran/Screens/case3.dart';
import 'package:thiran/controllers/appload_controller.dart';
import 'package:get/get.dart';
import 'package:thiran/common/common_widgets.dart';
import 'package:thiran/Screens/case1.dart';
import 'package:thiran/Screens/case2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UseCase extends StatefulWidget {
  const UseCase({Key? key}) : super(key: key);

  @override
  State<UseCase> createState() => _UseCaseState();
}

class _UseCaseState extends State<UseCase> {
  final AppLoadController appLoadController =
  Get.put(AppLoadController.getInstance(), permanent: true);

  @override

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initState() {
    super.initState();

    // Get the FCM token for this device
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
      setState(() {
        appLoadController.fcmToken = token.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 1,
        decoration: BoxDecoration(
          color: appLoadController.themeColor
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset("assets/logo.png", height:300),
                ),
              ),
              fullColorButton(title: 'UseCase 1', textColor: Colors.white, buttonColor: Colors.black54, context: context, onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const UseCase1(),
                ));
              }),
              SizedBox(height: 10),
              fullColorButton(title: 'UseCase 2', textColor: Colors.white, buttonColor: Colors.black54, context: context, onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const UseCase2(),
                ));
              }),
              SizedBox(height: 10),
              fullColorButton(title: 'UseCase 3', textColor: Colors.white, buttonColor: Colors.black54, context: context, onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const UseCase3(),
                ));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
