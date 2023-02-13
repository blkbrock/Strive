import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String userName = '';
class WeightDataPage extends StatefulWidget {
  WeightDataPage(String id, {super.key}) {
     userName = id;
  }
  @override
  State<WeightDataPage> createState() => _WeightDataPageState();
}

class _WeightDataPageState extends State<WeightDataPage> {
  final databaseWeightRef = FirebaseFirestore.instance.collection('Users');
  late Stream<QuerySnapshot> _stream;
  String date='',weight='',bodyFat='';

  void uploadEntry(String newDate, String newWeight, String newBodyFat) async {
    databaseWeightRef.doc(userName).collection('Weight').add({'Date': newDate, 'Weight': newWeight, 'bodyFat': newBodyFat});
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Weight Data'),
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
                  decoration: const InputDecoration(labelText: 'Weight'),
                  onChanged: (String? newWeight) {
                    weight = newWeight!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Body Fat Percentage'),
                  onChanged: (String? newBodyFat) {
                    bodyFat = newBodyFat!;
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
                if (date!=''&&weight!='') {
                  setState(() {
                    uploadEntry(date, weight, bodyFat);
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
    _stream = databaseWeightRef.doc(userName).collection('Weight').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weight Page"),
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
                    subtitle: Text(document.get('Weight').toString()),
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