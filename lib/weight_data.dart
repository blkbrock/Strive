import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class weightData extends StatelessWidget {
  const weightData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weight Page"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('history').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent,),
            );
          }

          final int? historyCount = snapshot.data?.docs.length;
          return ListView.builder(
            itemCount: historyCount,
            itemBuilder: (context, index) {
              final DocumentSnapshot history =
              snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
              return ListTile(
                title: Text("Date: ${history['date']}", style: const TextStyle(color: Colors.white),),
                subtitle: Text("Rating: ${history['rating']}", style: const TextStyle(color: Colors.white70),),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {},
      ),
    );
  }
}