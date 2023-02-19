import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:strive/weight_page.dart';
import 'package:strive/workout_page.dart';

import 'messages_page.dart';

final databaseUserRef = FirebaseFirestore.instance.collection('Users');
final databaseMsgRef = FirebaseDatabase.instance.ref();
String userName = '';

class ProfilePage extends StatefulWidget {
  ProfilePage(String id, {super.key}) {
    userName = id;
  }

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  void showHistory() {}
  String user = '', msg = '',sendID='',sendMsg='';
  num numMsgs=0;

  Future<DocumentSnapshot> retrieveProfileData(String id) async {
    return databaseUserRef.doc(id).get();
  }

  Future<void> getUserData() async {
  }

  _ProfilePage() {
    getUserData();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Text(userName,
                style: const TextStyle(
                    color: Colors.deepPurpleAccent, fontSize: 28)),
            const SizedBox(height: 50),
            Lottie.asset(
              'assets/astro_ride.json',
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WeightDataPage(userName),
                    ),
                  );
                },
                child: const Text('Weight History')),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return WorkoutDataPage(userName);
                  }));
                },
                child: const Text('Workout History')),
            const SizedBox(height: 100),

            const SizedBox(height: 20),
            Text(
              msg,
              style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 16),
            ),
            ElevatedButton(onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return MessagePage(userName);
              }));
            },
              child: const Text("Messages ->"),
            ),
          ],
        ),
      ),
    );
  }
}