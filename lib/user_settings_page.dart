import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strive/community_page.dart';
import 'package:strive/strive_styles.dart';

final databaseUserRef = FirebaseFirestore.instance.collection('Users');
String userName = '';

class UserSettingsPage extends StatefulWidget {
  UserSettingsPage(String id, {super.key}) {
    userName = id;
  }

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  String user = '';

  Future<DocumentSnapshot> retrieveProfileData(String id) async {
    return databaseUserRef.doc(id).get();
  }

  Future<void> getUserData() async {}

  _UserSettingsPageState() {
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
        child: Expanded(
          flex: 9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Text('Settings', style: TextStyle(color: strive_lavender, fontSize: 18),),
                ],
              )),
              const Spacer(flex: 1),
              Text(userName,
                  style: const TextStyle(
                      color: Colors.deepPurpleAccent, fontSize: 28)),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
