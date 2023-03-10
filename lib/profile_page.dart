import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:strive/auth.dart';
import 'package:strive/community_page.dart';
import 'package:strive/strive_styles.dart';
import 'package:strive/weight_page.dart';
import 'package:strive/workout_page.dart';
import 'package:strive/user_settings_page.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(strive_cyan),
                            ),
                            child: const Text('signout', style: TextStyle(color: strive_lavender, fontSize: 8),),
                            onPressed: () async {
                              await AuthService().signOut();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/', (route) => false);
                            }),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        const Image(
                          image: AssetImage("assets/star_icon_light.png"),
                          height: 50,
                          width: 50,
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all<Size>(
                                const Size(80, 40)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: const BorderSide(
                                        color: strive_cyan,
                                        width: 15.0,
                                        style: BorderStyle.solid))),
                          ),
                          child: Text(
                            userName,
                            style: const TextStyle(
                                color: strive_lavender, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return UserSettingsPage(userName);
                            }));
                          },
                          icon: const Icon(Icons.settings,
                              color: strive_lavender),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                flex: 8,
                fit: FlexFit.tight,
                child: Column(
                  children: [
                    Flexible(
                      flex: 8,
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 1,
                          child: Column(
                            children: [
                              //Badges Row
                              Flexible(
                                flex: 4,
                                child: Container(
                                    color: strive_navy,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: const [
                                            Spacer(flex: 1),
                                            Text('Badges',
                                                style: TextStyle(
                                                    color: strive_lavender,
                                                    fontSize: 18,
                                                    decoration: TextDecoration
                                                        .underline)),
                                            Spacer(flex: 5),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Spacer(flex: 1),
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: strive_lavender,
                                              backgroundImage: AssetImage(
                                                  'assets/star_icon_light.png'),
                                            ),
                                            Spacer(flex: 1),
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: strive_lavender,
                                              backgroundImage: AssetImage(
                                                  'assets/star_icon_light.png'),
                                            ),
                                            Spacer(flex: 1),
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: strive_lavender,
                                              backgroundImage: AssetImage(
                                                  'assets/star_icon_light.png'),
                                            ),
                                            Spacer(flex: 1),
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: strive_lavender,
                                              backgroundImage: AssetImage(
                                                  'assets/star_icon_light.png'),
                                            ),
                                            Spacer(flex: 1),
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: strive_lavender,
                                              backgroundImage: AssetImage(
                                                  'assets/star_icon_light.png'),
                                            ),
                                            Spacer(flex: 1),
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: strive_lavender,
                                              backgroundImage: AssetImage(
                                                  'assets/star_icon_light.png'),
                                            ),
                                            Spacer(flex: 1),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                              //Spacer
                              const Spacer(flex: 1),
                              //Workout Row
                              Flexible(
                                flex: 6,
                                child: Container(
                                    color: strive_navy,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: const [
                                            Spacer(flex: 1),
                                            Text('Workouts',
                                                style: TextStyle(
                                                    color: strive_lavender,
                                                    fontSize: 18,
                                                    decoration: TextDecoration
                                                        .underline)),
                                            Spacer(flex: 5),
                                          ],
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      WorkoutPage(userName),
                                                ),
                                              );
                                            },
                                            child:
                                                const Text('Workout History')),
                                      ],
                                    )),
                              ),
                              const Spacer(flex: 1),
                              //Weight Row
                              Flexible(
                                flex: 8,
                                child: Container(
                                    color: strive_navy,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: const [
                                            Spacer(flex: 1),
                                            Text('Weight',
                                                style: TextStyle(
                                                    color: strive_lavender,
                                                    fontSize: 18,
                                                    decoration: TextDecoration
                                                        .underline)),
                                            Spacer(flex: 5),
                                          ],
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      WeightPage(userName),
                                                ),
                                              );
                                            },
                                            child:
                                                const Text('Weight History')),
                                      ],
                                    )),
                              ),
                              //Spacer
                              const Spacer(flex: 1),
                            ],
                          ),
                        ),
                      ),
                    ),
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
    );
  }
}
