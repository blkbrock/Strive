import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:strive/add_weight_page.dart';
import 'package:strive/community_page.dart';
import 'package:strive/food_page.dart';
import 'package:strive/profile_page.dart';
import 'package:strive/strive_colors.dart';
import 'package:strive/weight_page.dart';
import 'package:strive/workout_page.dart';


final databaseMsgRef = FirebaseDatabase.instance.ref();
String userName = '';

class MessagePage extends StatefulWidget {
  MessagePage(String id, {super.key}) {
    userName = id;
  }
  @override
  State<MessagePage> createState() => _MessagesPage();
}

class MessagesQueue<T> {
  final int maxSize;
  final List<Widget> _queue;

  MessagesQueue(this.maxSize) : _queue = [];

  void add(Widget element) {
    if (_queue.length == maxSize) {
      _queue.removeLast();
    }
    _queue.insert(0, element);
  }

  List<Widget> get queue => _queue;
}

class _MessagesPage extends State<MessagePage> {
  MessagesQueue messagesQueue = MessagesQueue(20);
  List<Widget> messages = [];
  String sendMsg='';

  void addMessage(String sender, String message) {
    setState(() {
      final String formattedMessage = "$sender: $message";
      Text messageWidget = Text(
        formattedMessage,
        style: const TextStyle(fontSize: 18, color: Colors.white70),
      );
      messagesQueue.add(messageWidget);
    });
  }

  void sendMessage(String message) async {
    String name = userName;
    databaseMsgRef.push().set({'Sender': name, 'message': message});
  }


  @override
  initState() {
    super.initState();
    databaseMsgRef.onChildAdded.listen((DatabaseEvent event) {
      final String sender = event.snapshot.children.first.value.toString();
      final String message = event.snapshot.children.last.value.toString();
      addMessage(sender, message);
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
          children: [
            Flexible(
              flex: 9,
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Spacer(flex: 1),
                  Text(userName,
                      style: const TextStyle(
                          color: Colors.deepPurpleAccent, fontSize: 28)),
                  const Spacer(flex: 1),
                  Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: messagesQueue._queue.reversed.toList(),
                  ),
                ),
              ),
              Container(
                height: 120.0,
                alignment: Alignment.center,
                child: TextField(
                  onSubmitted: (String value) async {
                    sendMessage(value);
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurpleAccent)
                      ),
                      labelText: 'Strive Messaging',
                      hintText: 'Type a message!'
                  ),
                ),
              ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return AddWeightPage(userName);
                      }));
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
                      onPressed: () {Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return WeightPage(userName);
                        }));},
                    ),
                    const Spacer(flex: 1),
                    IconButton(
                      icon: Image.asset("assets/message_icon_light.png"),
                      onPressed: () {},
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