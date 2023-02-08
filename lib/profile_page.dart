import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strive/main.dart';

final databaseUserRef = FirebaseFirestore.instance.collection('Users');
final databaseMsgRef = FirebaseFirestore.instance.collection('Msg');
String profileID = '';

class ProfilePage extends StatefulWidget {
  ProfilePage(String id, {super.key}) {
    profileID = id;
  }

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  void showHistory() {}
  String user = '', msg = '',sendID='',sendMsg='';
  num numMsgs=0;

  Future<DocumentSnapshot> retrieveProfileData(String id) async {
    return databaseUserRef.doc(id).get();
  }

  Future<DocumentSnapshot> retrieveMsgData(String id) async {
    return databaseMsgRef.doc(id).get();
  }

  Future<void> getUserData() async {
    DocumentSnapshot profileData = await retrieveProfileData(profileID);
    if (profileData.data() != null) {
      user = profileData.data().toString();
    }
    if (profileData.data() == null) {
      user = '';
    }
  }

  Future<void> getUserMsg() async {
    DocumentSnapshot msgData = await retrieveMsgData(profileID);
    if (msgData.data() != null) {
      msg = msgData.data().toString();
    }
    if (msgData.data() == null) {
      msg = '';
    }
  }

  void sendMessage(String id, String msg) {
    databaseMsgRef.doc(id).set({"Msg": msg});
  }

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
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50),
            Text(user,
                style: const TextStyle(
                    color: Colors.deepPurpleAccent, fontSize: 24)),
            const SizedBox(height: 100),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      barrierColor: Colors.black,
                      context: context,
                      builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(title: const Text("Weight History")),
                          body: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                              itemCount: 25,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  splashColor: Colors.black,
                                    leading: const Icon(Icons.list),
                                    trailing: const Text(
                                      "Date",
                                      style: TextStyle(color: Colors.blueAccent, fontSize: 12),
                                    ),
                                    title: Text("List item $index", style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 16),));
                              }),
                        );
                      });
                },
                child: const Text('Weight History')),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      barrierColor: Colors.black,
                      context: context,
                      builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(title: const Text("Weight History")),
                          body: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              itemCount: 25,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    splashColor: Colors.black,
                                    leading: const Icon(Icons.list),
                                    trailing: const Text(
                                      "Date",
                                      style: TextStyle(color: Colors.blueAccent, fontSize: 12),
                                    ),
                                    title: Text("List item $index", style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 16),));
                              }),
                        );
                      });
                },
                child: const Text('Workout History')),
            const SizedBox(height: 100),

            const SizedBox(height: 20),
            Text(
              msg,
              style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 16),
            ),
            ElevatedButton(onPressed: () {
              showDialog(
                  barrierColor: Colors.black,
                  context: context,
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(title: const Text("Messages")),
                      body: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          itemCount: 25,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                splashColor: Colors.black,
                                leading: const Icon(Icons.list),
                                trailing: const Text(
                                  "From: _____",
                                  style: TextStyle(color: Colors.blueAccent, fontSize: 12),
                                ),
                                title: Text("List item $index", style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 16),));
                          }),
                    );
                  });
            },
              child: const Text("Messages ->"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  backgroundColor: Colors.grey,
                  title: const Text('Send Message'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'ID (1-5)',
                                icon: Icon(Icons.account_box),
                              ),
                              onChanged: (String? newID) {
                                sendID = newID!;
                              }),
                          TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Message',
                                icon: Icon(Icons.abc),
                              ),
                              onChanged: (String? newMsg) {
                                sendMsg = newMsg!;
                              }),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context, 'Cancel');
                              }),
                          const SizedBox(width: 50),
                          ElevatedButton(
                              child: const Text("Submit"),
                              onPressed: () {
                                sendMessage(sendID, sendMsg);
                                setState(() {});
                                Navigator.pop(context, 'Cancel');
                              })
                        ],
                      ),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
