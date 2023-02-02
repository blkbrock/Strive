import 'package:flutter/material.dart';
import 'package:strive/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  void showHistory() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Name',
            ),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          title: const Text('History'),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  ColoredBox(
                                      color: Colors.white10,
                                      child: Text('| will show weight history |')),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                                child: const Text("Close"),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                                  setState(() {});
                                })
                          ],
                        );
                      });
                },
                child: const Text('Weight History')),
            ColoredBox(
                color: Colors.deepPurple.shade200, child: const Text('test')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return const StriveHomePage(title: 'Strive Home');
          }));
        },
        child: const Icon(Icons.account_tree),
      ),
    );
  }
}
