import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strive/profile_page.dart';
import 'package:strive/weight_page.dart';
import 'package:strive/workout_page.dart';
import 'package:strive/messages_page.dart';

final databaseUserRef = FirebaseFirestore.instance.collection('Users');
String userName = '';

class CommunityPage extends StatefulWidget {
  CommunityPage(String id, {super.key}) {
    userName = id;
  }

  @override
  State<CommunityPage> createState() => _CommunityPage();
}

class _CommunityPage extends State<CommunityPage> {
  String user = '';

  Future<DocumentSnapshot> retrieveProfileData(String id) async {
    return databaseUserRef.doc(id).get();
  }

  Future<void> getUserData() async {
  }

  _CommunityPage() {
    getUserData();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Strive Community"),
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
            const Spacer(flex: 1),
            Text(userName,
                style: const TextStyle(
                    color: Colors.deepPurpleAccent, fontSize: 28)),
            const SizedBox(height: 50),
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton (
                  icon: Image.asset("assets/star_icon_light.png"),
                  onPressed: () {
                  },
                ),

                const Spacer(flex: 1),
                IconButton (
                  icon: Image.asset("assets/apple_icon_dark.png"),
                  onPressed: () {
                     Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return ProfilePage(userName);
                    }));
                  },
                ),

                const Spacer(flex: 1),
                IconButton (
                  icon: Image.asset("assets/weights_icon_dark.png"),
                  onPressed: () {
                     Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return WorkoutPage(userName);
                    }));
                  },
                ),

                const Spacer(flex: 1),
                IconButton (
                  icon: Image.asset("assets/scale_icon_dark.png"),
                  onPressed: () {
                     Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return WeightPage(userName);
                    }));
                  },
                ),

                const Spacer(flex: 1),
                IconButton (
                  icon: Image.asset("assets/message_icon_dark.png"),
                  onPressed: () {
                     Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return MessagePage(userName);
                    }));
                  },
                ),
              ],
            ),
            ],),
          ],
        ),
      ),
      ),
    );
  }
}