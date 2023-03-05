import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:numberpicker/numberpicker.dart';
import 'package:strive/strive_styles.dart';

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
  late String _targetDateString;

  String _date = '';
  int weightScroll = 0, bodyFatScroll = 0;

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {},
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

  Future<void> _getScrollValues() async {
    await databaseWeightRef
        .doc(userName)
        .collection('Weight')
        .get()
        .then((value) {
      weightScroll = int.parse(value.docs.first.get('Weight'));
      bodyFatScroll = int.parse(value.docs.first.get('BodyFat'));
    });
    setState(() {});
  }

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
    _getScrollValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text('Add Weight Entry')),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/strive_background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: <Widget>[
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
                color: strive_purple,
              ),
              weekendTextStyle: const TextStyle(
                color: strive_purple,
              ),
              thisMonthDayBorderColor: Colors.grey,
              headerText: _targetDateString,
              headerTextStyle: const TextStyle(color: strive_cyan),
              weekFormat: true,
              showOnlyCurrentMonthDate: false,
              markedDatesMap: _markedDateMap,
              height: 200.0,
              selectedDateTime: _selectedDate,
              targetDateTime: _targetDateTime,
              selectedDayBorderColor: strive_purple,
              selectedDayButtonColor: strive_purple,
              showIconBehindDayText: true,
              daysHaveCircularBorder: true,

              /// null for not rendering any border, true for circular border, false for rectangular border
              customGridViewPhysics: const NeverScrollableScrollPhysics(),
              pageSnapping: true,
              markedDateShowIcon: true,
              markedDateIconMaxShown: 2,
              selectedDayTextStyle:
                  const TextStyle(color: strive_cyan, fontSize: 18.0),
              todayTextStyle: const TextStyle(
                color: strive_cyan,
              ),
              daysTextStyle: const TextStyle(
                color: strive_purple,
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
              children: <Widget>[
                Text(
                  _selectedDateString,
                  style: const TextStyle(
                    color: strive_cyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Spacer(flex: 2),
              const Expanded(
                flex: 3,
                child: Text('Weight',
                    style: TextStyle(color: strive_cyan, fontSize: 20.0)),
              ),
              const Spacer(flex: 1),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: NumberPicker(
                  step: 1,
                  haptics: true,
                  minValue: 0,
                  maxValue: 300,
                  value: weightScroll,
                  onChanged: ((value) => setState(() => weightScroll = value)),
                ),
              ),
              const Flexible(
                  flex: 1,
                  child: Text('lbs',
                      style: TextStyle(fontSize: 20.0, color: strive_cyan))),
              const Spacer(flex: 1),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Spacer(flex: 2),
              const Expanded(
                flex: 3,
                child: Text('BodyFat %',
                    style: TextStyle(color: strive_cyan, fontSize: 20.0)),
              ),
              const Spacer(flex: 1),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: NumberPicker(
                  haptics: true,
                  minValue: 0,
                  maxValue: 300,
                  value: bodyFatScroll,
                  onChanged: ((value) => setState(() => bodyFatScroll = value)),
                ),
              ),
              const Flexible(
                  flex: 1,
                  child: Text('%',
                      style: TextStyle(fontSize: 20.0, color: strive_cyan))),
              const Spacer(flex: 1),
            ]),
            const SizedBox(height: 20.0),
            MaterialButton(
              child: const Text('Submit',
                  style: TextStyle(color: strive_purple, fontSize: 16.0)),
              onPressed: () {
                _date = DateFormat.yMMMd().format(_selectedDate);
                setState(() {
                  uploadEntry(
                      _date, weightScroll.toString(), bodyFatScroll.toString());
                });
                Navigator.pop(context, 'Cancel');
              },
            ),
            MaterialButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: strive_navy, fontSize: 16.0),
              ),
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            )
          ]),
        ));
  }
}
