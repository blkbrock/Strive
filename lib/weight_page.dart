import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strive/add_weight_page.dart';

String userName = '';

class WeightDataPage extends StatefulWidget {
  WeightDataPage(String id, {Key? key}) : super(key: key) {
    userName = id;
  }

  @override
  State<WeightDataPage> createState() => _WeightDataPageState();
}

class _WeightDataPageState extends State<WeightDataPage> {
  final databaseWeightRef = FirebaseFirestore.instance.collection('Users');
  late Stream<QuerySnapshot> _stream;

  void uploadEntry(String newDate, String newWeight, String newBodyFat) async {
    databaseWeightRef
        .doc(userName)
        .collection('Weight')
        .add({'Date': newDate, 'Weight': newWeight, 'BodyFat': newBodyFat});
  }

  @override
  void initState() {
    _stream = databaseWeightRef.doc(userName).collection('Weight').snapshots();
    super.initState();
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
                children: List<Widget>.from(
                    snapshot.data?.docs.map((DocumentSnapshot document) {
                          return ListTile(
                            title: Text(document.get('Date').toString()),
                            subtitle: Text("${document.get('Weight')}lbs;   ${document.get('BodyFat')}%", style: const TextStyle(color: Colors.deepPurple, fontSize: 18),),
                          );
                        }) ??
                        []),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return AddWeightPage(userName);
        }));},
        child: const Icon(Icons.add),
      ),
    );
  }
}
