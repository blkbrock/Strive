import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strive/community_page.dart';
import 'package:strive/food_page.dart';
import 'package:strive/messages_page.dart';
import 'package:strive/profile_page.dart';
import 'package:strive/strive_styles.dart';
import 'package:strive/weight_page.dart';

String userName = '';

class WorkoutPage extends StatefulWidget {
  WorkoutPage(String id, {super.key}) {
    userName = id;
  }
  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final databaseRef = FirebaseFirestore.instance.collection('Users');
  late Stream<QuerySnapshot> _stream;
  String date = '', exercise = '', duration = '';

  void uploadEntry(
      String newDate, String newExercise, String newDuration) async {
    databaseRef.doc(userName).collection('Workouts').add(
        {'Date': newDate, 'Exercise': newExercise, 'Duration': newDuration});
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Workout Data'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Date'),
                  onChanged: (String? newDate) {
                    date = newDate!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Exercise'),
                  onChanged: (String? newExercise) {
                    exercise = newExercise!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Duration'),
                  onChanged: (String? newDuration) {
                    duration = newDuration!;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
            MaterialButton(
              child: const Text('Submit'),
              onPressed: () {
                if (date != '' && exercise != '' && duration != '') {
                  setState(() {
                    uploadEntry(date, exercise, duration);
                  });
                  Navigator.pop(context, 'Cancel');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _stream = databaseRef.doc(userName).collection('Workouts').snapshots();
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
          children: [
            Flexible(
              flex: 11,
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Spacer(flex: 1),
                  StreamBuilder(
                    stream: _stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        default:
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3,
                            child: ListView(
                              children: List<Widget>.from(snapshot.data?.docs
                                      .map((DocumentSnapshot document) {
                                    return ListTile(
                                      title:
                                          Text(document.get('Date').toString()),
                                      subtitle: Text(document
                                              .get('Exercise')
                                              .toString() +
                                          document.get('Duration').toString()),
                                    );
                                  }) ??
                                  []),
                            ),
                          );
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showAddDialog();
                    },
                    child: const Text('Add Workout Data'),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                decoration: const BoxDecoration(color: strive_lavender),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset("assets/star_icon_dark.png"),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ProfilePage(userName);
                        }));
                      },
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
                      icon: Image.asset("assets/weights_icon_light.png"),
                      onPressed: () {},
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
