import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:strive/add_workout_page.dart';
import 'package:strive/community_page.dart';
import 'package:strive/food_page.dart';
import 'package:strive/messages_page.dart';
import 'package:strive/profile_page.dart';
import 'package:strive/strive_styles.dart';
import 'package:strive/weight_page.dart';

String userName = '';

class WorkoutPage extends StatefulWidget {
  WorkoutPage(String id, {super.key}) {
    userName = id;
  }
  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final databaseWorkoutRef = FirebaseFirestore.instance.collection('Users');
  final Map<String, WorkoutEntry> _workoutDataMap = {};
  final List _workoutDataList = [];
  final List<WorkoutEntry> _sevenDayEntryList = [];
  List _sortedWorkoutData = [];
  String date = '', exercise = '', duration = '';
  final DateTime _currentDate = (DateTime.now());
  late DateTime _selectedDate;
  late DateTime _targetDateTime;
  late String _selectedDateString;
  late String _targetDateString;

  void uploadEntry(
      String newDate, String newWorkout, String newDuration) async {
    databaseWorkoutRef.doc(userName).collection('Workouts').add(
        {'Date': newDate, 'WorkoutType': newWorkout, 'Duration': newDuration});
  }

  Future<void> _getWorkoutData() async {
    final QuerySnapshot workoutData =
        await databaseWorkoutRef.doc(userName).collection('Workouts').get();
    while (workoutData.docs.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    for (final QueryDocumentSnapshot workout in workoutData.docs) {
      WorkoutEntry entry = WorkoutEntry(
          workout.get('Date').toString(),
          workout.get('WorkoutType').toString(),
          workout.get('Duration').toString());
      _workoutDataMap[workout.get('Date').toString()] = entry;
      _workoutDataList.add(entry);
    }
    _sortedWorkoutData = _workoutDataMap.keys.toList()..sort();
    for (int i = 0; i < 7; i++) {
      _sevenDayEntryList.add(_workoutDataMap[_sortedWorkoutData[i]]!);
    }
    setState(() {});
  }

  @override
  _WorkoutPageState() {
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {});
    });
  }

  @override
  void initState() {
    _getWorkoutData();
    _selectedDate = _currentDate;
    _targetDateTime = _currentDate;
    _targetDateString = DateFormat.yMMM().format(_currentDate);
    _selectedDateString = DateFormat.MMMd().format(_currentDate);
    super.initState();
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
              flex: 11,
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CalendarCarousel<Event>(
                    onDayPressed: (date, events) {
                      _selectedDate = date;
                      _selectedDateString =
                          DateFormat.MMMd().format(_selectedDate);
                      setState(() {});
                    },
                    onCalendarChanged: (DateTime date) {
                      setState(() {
                        _targetDateTime = date;
                        _targetDateString =
                            DateFormat.yMMM().format(_targetDateTime);
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
                    height: 180.0,
                    selectedDateTime: _selectedDate,
                    targetDateTime: _targetDateTime,
                    selectedDayBorderColor: strive_cyan,
                    selectedDayButtonColor: strive_purple,
                    showIconBehindDayText: true,
                    daysHaveCircularBorder: true,
                    customGridViewPhysics: const NeverScrollableScrollPhysics(),
                    pageScrollPhysics: const ScrollPhysics(),
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
                    minSelectedDate:
                        _currentDate.subtract(const Duration(days: 360)),
                    maxSelectedDate:
                        _currentDate.add(const Duration(days: 360)),
                    todayButtonColor: Colors.transparent,
                    todayBorderColor: Colors.white10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Spacer(flex: 1),
                        Flexible(
                          flex: 1,
                          child: Column(
                            children: [
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
                        ),
                        const Spacer(flex: 1),
                        Flexible(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _workoutDataWidget(),
                            ],
                          ),
                        ),
                        const Spacer(flex: 1),
                        Flexible(
                          flex: 6,
                          fit: FlexFit.tight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _workoutStreakWidget(),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                      icon: Image.asset("assets/weights_icon_light.png"),
                      onPressed: () {},
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
                      icon: Image.asset("assets/message_icon_dark.png"),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return MessagePage(userName);
                        }));
                      },
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

  Widget _workoutDataWidget() {
    if (_workoutDataMap[DateFormat.yMMMd().format(_selectedDate).toString()]
            ?.getWorkoutType ==
        null) {
      return _noDataWidget();
    } else {
      return _dataWidget();
    }
  }

  Widget _dataWidget() {
    return Column(
        children: [
          Text(
              _workoutDataMap[
                      DateFormat.yMMMd().format(_selectedDate).toString()]!
                  .getWorkoutType
                  .toString(),
              style: const TextStyle(
                  color: strive_cyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0)),
          Text(
              "${_workoutDataMap[DateFormat.yMMMd().format(_selectedDate).toString()]!.duration} minutes",
              style: const TextStyle(
                  color: strive_cyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0)),
        ],
    );
  }

  Flexible _noDataWidget() {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No Workout Data Found!',
            style: TextStyle(
              color: strive_cyan,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return AddWorkoutPage(userName, _selectedDate);
              }));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(strive_purple),
            ),
            child: const Text(
              'Add Workout Data?',
              style: TextStyle(
                color: strive_cyan,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  _workoutStreakWidget() {
    return const ColoredBox(color: strive_purple, child: Text("Workout Streak Widget", style: TextStyle(color: strive_cyan),));
  }
}

class WorkoutEntry {
  String date;
  String workoutType;
  String duration;

  String get getDate => date;
  String get getDuration => duration;
  String get getWorkoutType => workoutType;

  WorkoutEntry(this.date, this.workoutType, this.duration);
}
