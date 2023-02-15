import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

String userName = '';

class AddWeightPage extends StatefulWidget {
  AddWeightPage(String id, {Key? key}) : super(key: key) {
    userName = id;
  }

  @override
  State<AddWeightPage> createState() => _AddWeightPageState();
}

class _AddWeightPageState extends State<AddWeightPage> {
  final databaseWeightRef = FirebaseFirestore.instance.collection('Users');
  DateTime _currentDate = (DateTime.now());
  DateTime _selectedDate = (DateTime.now());
  String _currentDateString = DateFormat.MMMd().format(DateTime.now());
  String _currentMonth = DateFormat.yMMM().format(DateTime(2023, 2, 14));
  DateTime _targetDateTime = DateTime(2023, 2, 14);
  String _date = '', _weight = '', _bodyFat = '';

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime(2023, 2, 10): [
        Event(
          date: DateTime.now(),
          title: 'Today',
          icon: _eventIcon,
          dot: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.deepPurpleAccent,
            height: 5.0,
            width: 5.0,
          ),
        ),
      ],
    },
  );

  static final Widget _eventIcon = Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.deepPurpleAccent, width: 2.0)),
    child: const Icon(
      Icons.person,
      color: Colors.blueAccent,
    ),
  );

  void uploadEntry(String newDate, String newWeight, String newBodyFat) async {
    databaseWeightRef
        .doc(userName)
        .collection('Weight')
        .add({'Date': newDate, 'Weight': newWeight, 'BodyFat': newBodyFat});
  }

  @override
  void initState() {
    _markedDateMap.add(
        DateTime(2019, 2, 25),
        Event(
          date: DateTime(2019, 2, 25),
          title: 'Event 5',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
        DateTime(2019, 2, 10),
        Event(
          date: DateTime(2019, 2, 10),
          title: 'Event 4',
          icon: _eventIcon,
        ));

    _markedDateMap.addAll(DateTime(2019, 2, 11), [
      Event(
        date: DateTime(2019, 2, 11),
        title: 'Event 1',
        icon: _eventIcon,
      ),
      Event(
        date: DateTime(2019, 2, 11),
        title: 'Event 2',
        icon: _eventIcon,
      ),
      Event(
        date: DateTime(2019, 2, 11),
        title: 'Event 3',
        icon: _eventIcon,
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF222222),
        appBar: AppBar(title: const Text('Add Entry')),
        body: Column(children: <Widget>[
          CalendarCarousel<Event>(
            onDayPressed: (date, events) {
              setState(() {
                _currentDate = date;
                _date = _currentDate.toString();
                _targetDateTime = date;
                _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                _selectedDate = date;
                _currentDateString = DateFormat.MMMd().format(_selectedDate);
              });
            },
            onCalendarChanged: (DateTime date) {
              setState(() {
                _targetDateTime = date;
                _currentMonth = DateFormat.yMMM().format(_targetDateTime);
              });
            },
            weekdayTextStyle: const TextStyle(
              color: Colors.deepPurpleAccent,
            ),
            weekendTextStyle: const TextStyle(
              color: Colors.deepPurpleAccent,
            ),
            thisMonthDayBorderColor: Colors.grey,
            headerText: _currentMonth,
            weekFormat: true,
            showOnlyCurrentMonthDate: false,
            markedDatesMap: _markedDateMap,
            height: 180.0,
            selectedDateTime: _selectedDate,
            targetDateTime: _targetDateTime,
            selectedDayBorderColor: Colors.deepPurpleAccent,
            selectedDayButtonColor: Colors.white10,
            showIconBehindDayText: true,
//          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
            customGridViewPhysics: const NeverScrollableScrollPhysics(),
            markedDateShowIcon: true,
            markedDateIconMaxShown: 2,
            selectedDayTextStyle: const TextStyle(
              color: Colors.deepPurpleAccent,
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
            todayBorderColor: Colors.white10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                child: const Text('Month -'),
                onPressed: () {
                  setState(() {
                    _targetDateTime = DateTime(
                        _targetDateTime.year, _targetDateTime.month - 1);
                    _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                  });
                },
              ),
              const SizedBox(width: 200),
              TextButton(
                child: const Text('Month +'),
                onPressed: () {
                  setState(() {
                    _targetDateTime = DateTime(
                        _targetDateTime.year, _targetDateTime.month + 1);
                    _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                  });
                },
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text(
              _currentDateString,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            ],
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Weight', labelStyle: TextStyle(color: Colors.blueAccent)),
            onChanged: (String? newWeight) {
              _weight = newWeight!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Body Fat Percentage', labelStyle: TextStyle(color: Colors.blueAccent)),
            onChanged: (String? newBodyFat) {
              _bodyFat = newBodyFat!;
            },
          ),
          MaterialButton(
            child: const Text('Submit', style: TextStyle(color: Colors.deepPurple)),
            onPressed: () {
              if (_date != '' && _weight != '') {
                setState(() {
                  uploadEntry(_date, _weight, _bodyFat);
                });
                Navigator.pop(context, 'Cancel');
              }
            },
          ),
          MaterialButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          )
        ]));
  }
}
