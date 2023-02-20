import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strive/chat_bar.dart';
import 'package:strive/community_page.dart';
import 'package:strive/food_page.dart';
import 'package:strive/profile_page.dart';
import 'package:strive/strive_styles.dart';
import 'package:strive/weight_page.dart';
import 'package:strive/workout_page.dart';
import 'loading.dart';

final firebaseMsgRef = FirebaseFirestore.instance.collection('GlobalMessages');
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
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 11,
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Messages(),
                  ChatBar(userName),
                ],
              ),
            ),
            Flexible(
              // Bottom navigation bar
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
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return WeightPage(userName);
                        }));
                      },
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

class Messages extends StatelessWidget {
  final Stream<QuerySnapshot> _chatsStream = FirebaseFirestore.instance
      .collection('GlobalMessages')
      .orderBy('createdAt', descending: false)
      .limit(15)
      .snapshots();

  Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('$snapshot.error'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        return Flexible(
          fit: FlexFit.tight,
          // Flexible prevents overflow error when keyboard is opened
          child: GestureDetector(
            // Close the keyboard if anything else is tapped
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List<Widget>.from(snapshot.data!.docs.map(
                (DocumentSnapshot doc) {
                  // Doc id
                  String id = doc.id;
                  // Chat data
                  Map<String, dynamic> data =
                      doc.data()! as Map<String, dynamic>;

                  // Chats sent by the current user
                  if (userName == data['owner']) {
                    return SentMessage(data: data);
                  } else {
                    // Chats sent by everyone else
                    return ReceivedMessage(data: data);
                  }
                },
              )),
            ),
          ),
        );
      },
    );
  }
}

class SentMessage extends StatelessWidget {
  const SentMessage({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(), // Dynamic width spacer
          Container(
            constraints: chatConstraints,
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 5.0,
              bottom: 5.0,
              right: 5.0,
            ),
            decoration: const BoxDecoration(
              gradient: sent,
              borderRadius: round,
            ),
            child: GestureDetector(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      data['text'],
                      textAlign: TextAlign.right,
                      style: chatText,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/strive_logo.png'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReceivedMessage extends StatelessWidget {
  const ReceivedMessage({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: chatConstraints,
            padding: const EdgeInsets.only(
              left: 5.0,
              top: 5.0,
              bottom: 5.0,
              right: 10.0,
            ),
            decoration: const BoxDecoration(
              gradient: received,
              borderRadius: round,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/strive_logo.png'),
                ),
                const SizedBox(width: 10.0),
                Flexible(
                  child: Text(
                    data['text'],
                    textAlign: TextAlign.left,
                    style: chatText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(), // Dynamic width spacer
        ],
      ),
    );
  }
}
