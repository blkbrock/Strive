import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

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
  late DateTime _currentDate = DateTime(2019, 2, 3);
  String _date = '', _weight = '', _bodyFat = '';

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime(2019, 2, 10): [
        Event(
          date: DateTime(2019, 2, 10),
          title: 'Event 1',
          icon: Icons.accessible_forward as Widget,
          dot: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
      ],
    },
  );

  void uploadEntry(String newDate, String newWeight, String newBodyFat) async {
    databaseWeightRef
        .doc(userName)
        .collection('Weight')
        .add({'Date': newDate, 'Weight': newWeight, 'BodyFat': newBodyFat});
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
                CalendarCarousel<Event>(
                onDayPressed: (date, events) {
          setState(() {
          _currentDate = date;
          _date = _currentDate.toString();
          });
          },
            weekendTextStyle: const TextStyle(
              color: Colors.red,
            ),
            thisMonthDayBorderColor: Colors.grey,
//          weekDays: null, /// for pass null when you do not want to render weekDays
            headerText: 'Custom Header',
            weekFormat: true,
            markedDatesMap: _markedDateMap,
            height: 200.0,
            selectedDateTime: _currentDate,
            showIconBehindDayText: true,
//          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
            customGridViewPhysics: const NeverScrollableScrollPhysics(),
            markedDateShowIcon: true,
            markedDateIconMaxShown: 2,
            selectedDayTextStyle: const TextStyle(
              color: Colors.yellow,
            ),
            todayTextStyle: const TextStyle(
              color: Colors.blue,
            ),
            markedDateIconBuilder: (event) {
              return event.icon ?? const Icon(Icons.help_outline);
            },
            minSelectedDate: _currentDate.subtract(const Duration(days: 360)),
            maxSelectedDate: _currentDate.add(const Duration(days: 360)),
            todayButtonColor: Colors.transparent,
            todayBorderColor: Colors.green,
            markedDateMoreShowTotal:
            true, // null for not showing hidden events indicator
//          markedDateIconMargin: 9,
//          markedDateIconOffset: 3,
          ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Weight'),
                  onChanged: (String? newWeight) {
                    _weight = newWeight!;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Body Fat Percentage'),
                  onChanged: (String? newBodyFat) {
                    _bodyFat = newBodyFat!;
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
                if (_date != '' && _weight != '') {
                  setState(() {
                    uploadEntry(_date, _weight, _bodyFat);
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
                children: List<Widget>.from(
                    snapshot.data?.docs.map((DocumentSnapshot document) {
                          return ListTile(
                            title: Text(document.get('Date').toString()),
                            subtitle: Text(document.get('Weight').toString()+document.get('BodyFat').toString()),
                          );
                        }) ??
                        []),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
