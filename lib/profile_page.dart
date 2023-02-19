import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:strive/add_weight_page.dart';
import 'package:strive/community_page.dart';
import 'package:strive/strive_colors.dart';
import 'package:strive/weight_page.dart';
import 'package:strive/workout_page.dart';

import 'food_page.dart';
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
  String user = '', msg = '', sendID = '', sendMsg = '';
  num numMsgs = 0;

  Future<DocumentSnapshot> retrieveProfileData(String id) async {
    return databaseUserRef.doc(id).get();
  }

  Future<void> getUserData() async {}

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
        toolbarHeight: 100,
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: Image.asset("assets/strive_logo.png"),
              iconSize: 140,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return CommunityPage(userName);
                }));
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/strive_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 11,
                fit: FlexFit.tight,
                  child: Column(
                children: [
                  const Spacer(flex: 1),
                  Text(userName,
                      style: const TextStyle(
                          color: Colors.deepPurpleAccent, fontSize: 28)),
                  Lottie.asset(
                    'assets/astro_ride.json',
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    fit: BoxFit.fill,
                  ),
                  const Spacer(flex: 2),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WeightPage(userName),
                          ),
                        );
                      },
                      child: const Text('Weight History')),
                  const Spacer(flex: 1),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return WorkoutPage(userName);
                        }));
                      },
                      child: const Text('Workout History')),
                  const Spacer(flex: 1),
                  Text(
                    msg,
                    style: const TextStyle(
                        color: Colors.deepPurpleAccent, fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return MessagePage(userName);
                      }));
                    },
                    child: const Text("Messages ->"),
                  ),
                  const Spacer(flex: 1),
                ],
              )),
              Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                decoration: const BoxDecoration(color: strive_lavender),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset("assets/star_icon_light.png"),
                      onPressed: () {},
                    ),
                    const Spacer(flex: 1),
                    IconButton(
                      icon: Image.asset("assets/apple_icon_dark.png"),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return FoodPage(userName);
                        }));
                      },
                    ),
                    const Spacer(flex: 1),
                    IconButton(
                      icon: Image.asset("assets/weights_icon_dark.png"),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return WorkoutPage(userName);
                        }));
                      },
                    ),
                    const Spacer(flex: 1),
                    IconButton(
                      icon: Image.asset("assets/scale_icon_dark.png"),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return WeightPage(userName);
                        }));
                      },
                    ),
                    const Spacer(flex: 1),
                    IconButton(
                      icon: Image.asset("assets/message_icon_dark.png"),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return MessagePage(userName);
                        }));
                      },
                    ),
                  ],
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
