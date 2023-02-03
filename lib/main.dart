import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:strive/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
      //checking for errors
      if (snapshot.hasError) {
        print("Couldn't connect!");
      }
      //Once complete, show app:
      if (snapshot.connectionState == ConnectionState.done) {
        return MaterialApp(
          title: 'Strive!',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            canvasColor: Colors.white12,
          ),
          home: const StriveHomePage(title: 'Strive Home'),
        );
      }
      Widget loading = MaterialApp();
      return loading;
    });
  }
}

class StriveHomePage extends StatefulWidget {
  const StriveHomePage({super.key, required this.title});

  final String title;

  @override
  State<StriveHomePage> createState() => _StriveHomePageState();
}

class _StriveHomePageState extends State<StriveHomePage> {
  final databaseRef = FirebaseFirestore.instance.collection('User');
  final String createText = "Create User";
  final String getText = "Get User";
  final String removeText = "Remove User";

  void createUser() {
    databaseRef.doc("2").set({"Name": "Resu", "Title": "User 2"});
  }

  Future<void> getUser() async {
    DocumentSnapshot data = await retrieveData();
    print(data.data().toString());
  }

  Future<DocumentSnapshot> retrieveData() async {
    return databaseRef.doc("1").get();
  }

  void removeUser() {
    databaseRef.doc("2").delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const ProfilePage();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.black38,
                    minimumSize: const Size(200, 40),
                  ),
                  child: const Text(
                    'Profile ->',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const Text(
              'You have this many opportunities:',
            ),
            Text(
              'boo',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(onPressed: createUser, child: Text(createText)),
            TextButton(onPressed: getUser, child: Text(getText)),
            TextButton(onPressed: removeUser, child: Text(removeText)),
          ],
        ),
      ),
    );
  }
}
