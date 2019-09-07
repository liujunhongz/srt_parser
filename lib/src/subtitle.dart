class Subtitle {
  int id;
  String startTime;
  String endTime;
  String text;
  int timeIn;
  int timeOut;
  Subtitle nextSubtitle;

  Subtitle({this.id, this.startTime, this.endTime, this.text, this.timeIn, this.timeOut, this.nextSubtitle});

  @override
  String toString() {
    return 'id: $id, timeIn: $timeIn, timeOut: $timeOut';
  }
//  @override
//  String toString() {
//    return 'id: $id, startTime: $startTime, endTime: $endTime, text: $text, timeIn: $timeIn, timeOut: $timeOut';
//  }
}
