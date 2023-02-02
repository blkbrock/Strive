class Profile {
  late String _userName;
  late num curWeight, goalWeight, height, bodyFatPercentage;

  _Profile(String newUser) {
    _userName = newUser;
  }

  void setCurWeight(num currentW) {
    curWeight = currentW;
  }

  void setGoalWeight(num goalW) {
    goalWeight = goalW;
  }

  void setHeight(num h) {
    height = h;
  }

  void setBodyFat(num bodyFat) {
    bodyFatPercentage = bodyFat;
  }

}