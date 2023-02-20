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
  final DateTime _currentDate = (DateTime.now());
  late DateTime _selectedDate;
  late DateTime _targetDateTime;
  late String _selectedDateString;
  late String _currentDateString;
  late String _targetDateString;

  String _date = '', _weight = '', _bodyFat = '';

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
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
    _selectedDate = _currentDate;
    _targetDateTime = _currentDate;
    _targetDateString = DateFormat.yMMM().format(_currentDate);
    _selectedDateString = DateFormat.MMMd().format(_currentDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF222222),
        appBar: AppBar(title: const Text('Add Entry')),
        body: Column(children: <Widget>[
          CalendarCarousel<Event>(
            onDayPressed: (date, events) {
              setState(() {
                _selectedDate = date;
                _selectedDateString = DateFormat.MMMd().format(_selectedDate);
                _date = DateFormat.yMMMd().format(_selectedDate);
              });
            },
            onCalendarChanged: (DateTime date) {
              setState(() {
                _targetDateTime = date;
                _targetDateString = DateFormat.yMMM().format(_targetDateTime);
              });
            },
            weekdayTextStyle: const TextStyle(
              color: Colors.deepPurpleAccent,
            ),
            weekendTextStyle: const TextStyle(
              color: Colors.deepPurpleAccent,
            ),
            thisMonthDayBorderColor: Colors.grey,
            headerText: _targetDateString,
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
              color: Colors.blueAccent,
            ),
            daysTextStyle: const TextStyle(
              color: Colors.deepPurpleAccent,
            ),
            markedDateIconBuilder: (event) {
              return event.icon ?? const Icon(Icons.help_outline);
            },
            minSelectedDate: _currentDate.subtract(const Duration(days: 360)),
            maxSelectedDate: _currentDate.add(const Duration(days: 360)),
            todayButtonColor: Colors.transparent,
            todayBorderColor: Colors.white10,
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text(
              _selectedDateString,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            ],
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
                label: Center(child: Text('Weight', style: TextStyle(color: Colors.blueAccent)),
                )),
            onChanged: (String? newWeight) {
              _weight = newWeight!;
            },
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
                label: Center(child: Text('Body Fat %', style: TextStyle(color: Colors.blueAccent)),
                )),
            onChanged: (String? newBodyFat) {
              _bodyFat = newBodyFat!;
            },
          ),
          const SizedBox(height: 20.0),
          MaterialButton(
            child: const Text('Submit', style: TextStyle(color: Colors.deepPurple)),
            onPressed: () {
              _date = DateFormat.yMMMd().format(_selectedDate);
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
