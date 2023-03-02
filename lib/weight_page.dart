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
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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
  late Stream<QuerySnapshot> _stream;
  final Map<String, Entry> _weightDataMap = {};
  final List _weightDataList = [];
  final List<Entry> _sevenDayEntryList = [];
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
      Entry entry = Entry(
          weight.get('Date').toString(),
          double.parse(weight.get('Weight').toString()),
          double.parse(weight.get('BodyFat').toString()));
      _weightDataMap[weight.get('Date').toString()] = entry;
      _weightDataList.add(entry);
    }
    _sortedWeightData = _weightDataMap.keys.toList()..sort();
    for (int i = 0; i < 7; i++) {
      _sevenDayEntryList.add(_weightDataMap[_sortedWeightData[i]]!);
    }
    setState(() {});
  }

  @override
  void initState() {
    _stream = databaseWeightRef.doc(userName).collection('Weight').snapshots();
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
                      child: _sevenDaySnapshot(),
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return AddWeightPage(userName);
                          }));
                        },
                        child: const Text('Add Weight Data',
                            style:
                                TextStyle(color: strive_purple, fontSize: 8)),
                      ),
                    ],
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
    );
  }

  Container _sevenDaySnapshot() {
    if (_sortedWeightData.isEmpty) {
      return Container();
    } else {
      return Container(
        color: strive_navy,
        child: Column(children: [
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Weight Over the Past 7 Days'),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
              SplineSeries<Entry, String>(
                dataSource: _sevenDayEntryList,
                xValueMapper: (Entry entry, _) => entry.getDate,
                yValueMapper: (Entry entry, _) => entry.getWeight,
                name: 'Weight',
                color: strive_purple,
                width: 6.0,
                trendlines: List<Trendline>.generate(
                  1,
                  (int index) => Trendline(
                    name: 'Trend',
                    type: TrendlineType.linear,
                    color: strive_cyan,
                    width: 3,
                  ),
                ),
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Body Fat Over the Past 7 Days'),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
              SplineSeries<Entry, String>(
                dataSource: _sevenDayEntryList,
                xValueMapper: (Entry entry, _) => entry.getDate,
                yValueMapper: (Entry entry, _) => entry.getBodyFat,
                name: 'Body Fat',
                color: strive_purple,
                width: 6.0,
                trendlines: List<Trendline>.generate(
                  1,
                  (int index) => Trendline(
                    name: 'Trend',
                    type: TrendlineType.linear,
                    color: strive_cyan,
                    width: 3,
                  ),
                ),
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ]),
      );
    }
  }
}

class Entry {
  String date;
  double weight;
  double bodyFat;

  String get getDate => date;
  double get getWeight => weight;
  double get getBodyFat => bodyFat;

  Entry(this.date, this.weight, this.bodyFat);
}
