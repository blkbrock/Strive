import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';
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
          if (snapshot.hasError) {}
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
          Widget loading = const MaterialApp();
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
  final databaseRef = FirebaseFirestore.instance.collection('Users');
  String id = '', name = '', title = '', removeID = '';
  String user1 = '', user2 = '', user3 = '', user4 = '', user5 = '';

  void createCustomUser(String id, String name, String title) {
    databaseRef.doc(id).set({"Nickname": name});
  }

  Future<void> getUser() async {
    DocumentSnapshot data1 = await retrieveData("1");
    if (data1.data() != null) {
      user1 = data1.get("Nickname");
    }
    if (data1.data() == null) {
      user1 = '';
    }
    DocumentSnapshot data2 = await retrieveData("2");
    if (data2.data() != null) {
      user2 = data2.get("Nickname");
    }
    if (data2.data() == null) {
      user2 = '';
    }
    DocumentSnapshot data3 = await retrieveData("3");
    if (data3.data() != null) {
      user3 = data3.get("Nickname");
    }
    if (data3.data() == null) {
      user3 = '';
    }
    DocumentSnapshot data4 = await retrieveData("4");
    if (data4.data() != null) {
      user4 = data4.get("Nickname");
    }
    if (data4.data() == null) {
      user4 = '';
    }
    DocumentSnapshot data5 = await retrieveData("5");
    if (data5.data() != null) {
      user5 = data5.get("Nickname");
    }
    if (data5.data() == null) {
      user5 = '';
    }
    setState(() {});
  }

  Future<DocumentSnapshot> retrieveData(String id) async {
    return databaseRef.doc(id).get();
  }

  void removeUser(String id) {
    databaseRef.doc(id).delete();
  }

  _StriveHomePageState() {
    getUser();
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Lottie.asset(
                    'assets/avocado_jump_rope.json',
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 5,
              child: Column(
                children: <Widget>[
                  const Text('Choose Profile',
                      style: TextStyle(
                          color: Colors.deepPurpleAccent, fontSize: 32)),
                  TextButton(
                      onPressed: getUser,
                      child: const Text("refresh",
                          style: TextStyle(
                              color: Colors.deepPurpleAccent, fontSize: 10))),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ProfilePage(user1);
                      }));
                    },
                    style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.deepPurpleAccent)),
                    child: Text(user1,
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent, fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ProfilePage(user2);
                      }));
                    },
                    style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.deepPurpleAccent)),
                    child: Text(user2,
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent, fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ProfilePage(user3);
                      }));
                    },
                    style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.deepPurpleAccent)),
                    child: Text(user3,
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent, fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ProfilePage(user4);
                      }));
                    },
                    style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.deepPurpleAccent)),
                    child: Text(user4,
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent, fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ProfilePage(user5);
                      }));
                    },
                    style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.deepPurpleAccent)),
                    child: Text(user5,
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent, fontSize: 16)),
                  ),
                ],
              ),
            ),
            Flexible(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Text('Add New User'),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'ID (1-5)',
                                              icon: Icon(Icons.account_box),
                                            ),
                                            onChanged: (String? newID) {
                                              id = newID!;
                                            }),
                                        TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Name',
                                              icon: Icon(Icons.abc),
                                            ),
                                            onChanged: (String? newName) {
                                              name = newName!;
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              createCustomUser(id, name, title);
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
                      child: const Text('Add New User',
                          style: TextStyle(
                              color: Colors.deepPurpleAccent, fontSize: 16)),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Remove User'),
                                content: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'ID',
                                      icon: Icon(Icons.account_box),
                                    ),
                                    onChanged: (String? newID) {
                                      removeID = newID!;
                                    }),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            removeUser(removeID);
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: const Text('Confirm'))
                                    ],
                                  )
                                ],
                              );
                            });
                      },
                      child: const Text(
                        "Remove User",
                        style: TextStyle(
                            color: Colors.deepPurpleAccent, fontSize: 8),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
