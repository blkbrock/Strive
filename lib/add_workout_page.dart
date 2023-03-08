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
import 'package:strive/workout_page.dart';

String userName = '';
late DateTime _currentDate;

class AddWorkoutPage extends StatefulWidget {
  AddWorkoutPage(String id, DateTime currentSelectedDay, {Key? key})
      : super(key: key) {
    userName = id;
    _currentDate = currentSelectedDay;
  }

  @override
  State<AddWorkoutPage> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final databaseWorkoutRef = FirebaseFirestore.instance.collection('Users');

  late DateTime _selectedDate;
  late DateTime _targetDateTime;
  late String _selectedDateString;
  late String _targetDateString;

  String _date = '', _workoutType = '';
  int durationScroll = 0;

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

  void uploadEntry(
      String newDate, String newWorkoutType, String newDuration) async {
    databaseWorkoutRef.doc(userName).collection('Workouts').add({
      'Date': newDate,
      'WorkoutType': newWorkoutType,
      'Duration': newDuration
    });
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
        appBar: AppBar(title: const Text('Add Workout Entry')),
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
            TextFormField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Workout Type',
                labelStyle: TextStyle(color: strive_cyan, fontSize: 20.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
              onChanged: (value) {
                _workoutType = value;
              },
            ),
            const SizedBox(height: 20.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Spacer(flex: 2),
              const Expanded(
                flex: 4,
                child: Text('Duration (min)',
                    style: TextStyle(color: strive_cyan, fontSize: 20.0)),
              ),
              const Spacer(flex: 1),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: NumberPicker(
                  minValue: 0,
                  maxValue: 300,
                  value: durationScroll,
                  onChanged: ((value) =>
                      setState(() => durationScroll = value)),
                ),
              ),
              const Spacer(flex: 1),
            ]),
            const SizedBox(height: 20.0),
            MaterialButton(
              child: const Text('Submit',
                  style: TextStyle(color: strive_purple, fontSize: 16.0)),
              onPressed: () {
                _date = DateFormat.yMMMd().format(_selectedDate);
                setState(() {
                  uploadEntry(_date, _workoutType, durationScroll.toString());
                });
                Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return WorkoutPage(userName);
                        }));
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
