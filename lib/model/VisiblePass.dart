
class VisiblePass {
  int duration;
  int risetime;

  VisiblePass(this.duration, this.risetime);

  VisiblePass.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    risetime = json['risetime'];
  }

  int get endTime => risetime + duration;
}