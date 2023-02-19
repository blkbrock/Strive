import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  String date='',exercise='',duration='';

  void uploadEntry(String newDate, String newExercise, String newDuration) async {
    databaseRef.doc(userName).collection('Workouts').add({'Date': newDate, 'Exercise': newExercise, 'Duration': newDuration});
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
                if (date!=''&&exercise!=''&&duration!='') {
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
        title: const Text("Workouts Page"),
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              return ListView(
                children: List<Widget>.from(snapshot.data?.docs.map((DocumentSnapshot document) {
                  return ListTile(
                    title: Text(document.get('Date').toString()),
                    subtitle: Text(document.get('Exercise').toString()+document.get('Duration').toString()),
                  );
                })?? []),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}