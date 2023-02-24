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
  bool visible = false;
  String units = 'Imperial';

  Future<DocumentSnapshot> retrieveSettingsSnapshot(String id) async {
    return databaseUserRef
        .doc(id)
        .collection('Settings')
        .doc('userSettings')
        .get();
  }

  Future<void> getUserData() async {
    final DocumentSnapshot settingsSnapshot =
        await retrieveSettingsSnapshot(userName);
    visible = settingsSnapshot.get('Visible');
  }

  _UserSettingsPageState() {
    getUserData();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
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
                      Text(
                        'Settings',
                        style: TextStyle(color: strive_lavender, fontSize: 18),
                      ),
                    ],
                  )),
              const Spacer(flex: 1),
              Container(
                color: strive_navy,
                child: Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        userName,
                        style:
                            const TextStyle(color: strive_purple, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Container(
                color: strive_navy,
                child: Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Spacer(flex: 1),
                      const Text(
                        "Visible:",
                        style: TextStyle(color: strive_purple, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 3),
                      Text(
                        visible.toString(),
                        style:
                            const TextStyle(color: strive_purple, fontSize: 16),
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Container(
                color: strive_navy,
                child: Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
              const Spacer(flex: 1),
                      const Text(
                        "Placeholder:",
                        style: TextStyle(color: strive_purple, fontSize: 16),
                      ),
                      const Spacer(flex: 3),
                      Text(
                        visible.toString(),
                        style:
                            const TextStyle(color: strive_purple, fontSize: 16),
                      ),
              const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Container(
                color: strive_navy,
                child: Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
              const Spacer(flex: 1),
                      const Text(
                        "Placeholder:",
                        style: TextStyle(color: strive_purple, fontSize: 16),
                      ),
                      const Spacer(flex: 3),
                      Text(
                        visible.toString(),
                        style:
                            const TextStyle(color: strive_purple, fontSize: 16),
                      ),
              const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Container(
                color: strive_navy,
                child: Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
              const Spacer(flex: 1),
                      const Text(
                        "Placeholder:",
                        style: TextStyle(color: strive_purple, fontSize: 16),
                      ),
                      const Spacer(flex: 3),
                      Text(
                        visible.toString(),
                        style:
                            const TextStyle(color: strive_purple, fontSize: 16),
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
