import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final databaseUserRef = FirebaseFirestore.instance.collection('Users');
  final databaseMsgRef = FirebaseFirestore.instance.collection('Msg');
  final databaseWeightRef = FirebaseFirestore.instance.collection('Weight');
  late String _userName;
  late String _curWeight,_curDate, _goalWeight, _height, _bodyFatPercentage;

  _User(String newUser) {
    _userName = newUser;
  }

  Future<DocumentSnapshot> retrieveWeightData(String id) async {
    return databaseWeightRef.doc(id).get();
  }

  void uploadWeight() {
    databaseWeightRef.doc(_userName).set({"Date": _curDate, "Weight": _curWeight});
  }

  Future<String> getWeightByDate(String date) async {
    DocumentSnapshot weightData = await retrieveWeightData(_userName);
    String weight = weightData.get("Weight");
    return weight;
  }

  void setCurWeight(String newCurWeight) {
    _curWeight = newCurWeight;
  }

  void setGoalWeight(String newGoal) {
    _goalWeight = newGoal;
  }

  void setHeight(String newHeight) {
    _height = newHeight;
  }

  void setBodyFat(String newBodyFat) {
    _bodyFatPercentage = newBodyFat;
  }

}