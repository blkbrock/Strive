import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strive/add_weight_page.dart';
import 'package:strive/community_page.dart';
import 'package:strive/food_page.dart';
import 'package:strive/messages_page.dart';
import 'package:strive/profile_page.dart';
import 'package:strive/strive_styles.dart';
import 'package:strive/workout_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

String userName = '';

class WeightPage extends StatefulWidget {
  WeightPage(String id, {Key? key}) : super(key: key) {
    userName = id;
  }

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  final databaseWeightRef = FirebaseFirestore.instance.collection('Users');
  final Map<DateTime, WeightEntry> _weightDataMap = {};
  final List _weightDataList = [];
  final List<WeightEntry> _sevenDayEntryList = [];
  List _sortedWeightData = [];

  void uploadEntry(String newDate, String newWeight, String newBodyFat) async {
    databaseWeightRef
        .doc(userName)
        .collection('Weight')
        .add({'Date': newDate, 'Weight': newWeight, 'BodyFat': newBodyFat});
  }

  Future<void> _getWeightData() async {
    final QuerySnapshot weightData =
        await databaseWeightRef.doc(userName).collection('Weight').get();
    for (final QueryDocumentSnapshot weight in weightData.docs) {
      WeightEntry entry = WeightEntry(
          weight.get('Date').toString(),
          double.parse(weight.get('Weight').toString()),
          double.parse(weight.get('BodyFat').toString()));
      _weightDataMap[DateTime.parse(weight.get('Date'))] = entry;
      _weightDataList.add(entry);
    }
    _sortedWeightData = _weightDataMap.keys.toList()
      ..sort(
        (a, b) => a.compareTo(b),
      );
    int length = _sortedWeightData.length;
    int lengthMinusSeven = length - 7;
    for (int i = lengthMinusSeven; i < length; i++) {
      _sevenDayEntryList.add(_weightDataMap[_sortedWeightData[i]]!);
    }
    setState(() {});
  }

  @override
  void initState() {
    _getWeightData();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return WeightPage(userName);
                      }));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: strive_lavender,
                      backgroundColor: strive_navy,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    child: const Text("Refresh",
                        style:
                            TextStyle(fontSize: 12, color: strive_lavender))),
              ],
            ),
            Flexible(
              flex: 11,
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 8,
                    child: SingleChildScrollView(
                        child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          _sevenDaySnapshot(),
                        ],
                      ),
                    )),
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
                      icon: Image.asset("assets/scale_icon_light.png"),
                      onPressed: () {},
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          elevation: 5,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return AddWeightPage(userName);
            }));
          },
          backgroundColor: strive_purple,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Container _sevenDaySnapshot() {
    if (_sortedWeightData.isEmpty) {
      return Container();
    } else {
      return Container(
        color: strive_navy,
        child: Column(children: [
          const SizedBox(height: 20),
          SfCartesianChart(
            palette: const <Color>[strive_purple, strive_cyan],
            primaryXAxis: CategoryAxis(
                labelPlacement: LabelPlacement.onTicks,
                labelRotation: 30,
                labelStyle: const TextStyle(
                    color: strive_lavender,
                    fontSize: 10,
                    fontFamily: 'Roboto')),
            primaryYAxis: NumericAxis(
                labelStyle: const TextStyle(
                    color: strive_lavender,
                    fontSize: 10,
                    fontFamily: 'Roboto')),
            margin: const EdgeInsets.all(8.0),
            title: ChartTitle(
              text: 'Weight Over the Past 7 Days',
              textStyle: const TextStyle(
                  color: strive_purple, fontSize: 20, fontFamily: 'Roboto'),
            ),
            borderColor: strive_cyan,
            borderWidth: 3,
            plotAreaBorderColor: Colors.transparent,
            legend: Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
              SplineSeries<WeightEntry, String>(
                animationDelay: 100,
                animationDuration: 3000.0,
                dataSource: _sevenDayEntryList,
                xValueMapper: (WeightEntry entry, _) => entry.getDate,
                yValueMapper: (WeightEntry entry, _) => entry.getWeight,
                name: 'Weight',
                color: strive_purple,
                width: 6.0,
                trendlines: List<Trendline>.generate(
                  1,
                  (int index) => Trendline(
                    animationDelay: 2200,
                    animationDuration: 2000.0,
                    name: 'Trend',
                    type: TrendlineType.linear,
                    color: strive_cyan,
                    width: 3,
                  ),
                ),
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(
                      color: strive_cyan,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SfCartesianChart(
            primaryXAxis: CategoryAxis(
                labelPlacement: LabelPlacement.onTicks,
                labelRotation: 30,
                labelStyle: const TextStyle(
                  color: strive_lavender,
                  fontSize: 10,
                  fontFamily: 'Roboto',
                )),
            primaryYAxis: NumericAxis(
                labelStyle: const TextStyle(
                    color: strive_lavender,
                    fontSize: 10,
                    fontFamily: 'Roboto')),
            title: ChartTitle(
              text: 'Body Fat Over the Past 7 Days',
              textStyle: const TextStyle(
                  color: strive_purple, fontSize: 20, fontFamily: 'Roboto'),
            ),
            borderColor: strive_cyan,
            borderWidth: 3,
            plotAreaBorderColor: Colors.transparent,
            legend: Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
              SplineSeries<WeightEntry, String>(
                animationDelay: 100,
                animationDuration: 3000.0,
                dataSource: _sevenDayEntryList,
                xValueMapper: (WeightEntry entry, _) => entry.getDate,
                yValueMapper: (WeightEntry entry, _) => entry.getBodyFat,
                name: 'Body Fat',
                color: strive_purple,
                width: 6.0,
                trendlines: List<Trendline>.generate(
                  1,
                  (int index) => Trendline(
                    animationDelay: 2200,
                    animationDuration: 2000.0,
                    name: 'Trend',
                    type: TrendlineType.linear,
                    color: strive_cyan,
                    width: 3,
                  ),
                ),
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(
                      color: strive_cyan,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ]),
      );
    }
  }
}

class WeightEntry {
  String date;
  double weight;
  double bodyFat;

  String get getDate => date;
  double get getWeight => weight;
  double get getBodyFat => bodyFat;

  WeightEntry(this.date, this.weight, this.bodyFat);
}
