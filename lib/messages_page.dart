import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


final databaseMsgRef = FirebaseDatabase.instance.ref();
String profileID = '';

class MessagePage extends StatefulWidget {
  MessagePage(String id, {super.key}) {
    profileID = id;
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
    String name = profileID;
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
      appBar: AppBar(title: const Text("Messages")),
      body: IntrinsicHeight(
          child: Column(
            children: <Widget>[
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
              )
            ],
          )
      ),
    );
  }
}