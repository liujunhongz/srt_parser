import 'package:sprintf/sprintf.dart';

class SrtUtils {
  SrtUtils._();

  static const _millisInSecond = 1000;

  static const _millisInMinute = _millisInSecond * 60;

  static const _millisInHour = _millisInMinute * 60;

  static const _patternTime = r'^([\d]{2}):([\d]{2}):([\d]{2}),([\d]{3})$';

  /// HH:mm:ss,SSS to millis
  static int textTime2Millis(String textTime) {
    var regx = RegExp(_patternTime);

    var match = regx.firstMatch(textTime);

    int hour = int.parse(match.group(1));
    int minute = int.parse(match.group(2));
    int second = int.parse(match.group(3));
    int millis = int.parse(match.group(4));

    int msTime = 0;
    if (hour > 0) {
      msTime += hour * _millisInHour;
    }
    if (minute > 0) {
      msTime += minute * _millisInMinute;
    }
    if (second > 0) {
      msTime += second * _millisInSecond;
    }
    msTime += millis;
    return msTime;
  }

  /// millis to HH:mm:ss,SSS
  static String millis2TextTime(int msTime) {
    int millisToSeconds = msTime ~/ 1000;
    int hour = millisToSeconds ~/ 3600;
    int minute = (millisToSeconds % 3600) ~/ 60;
    int second = millisToSeconds % 60;
    int millis = msTime % 1000;

    if (hour < 0) {
      hour = 0;
    }

    if (minute < 0) {
      millis = 0;
    }

    if (second < 0) {
      second = 0;
    }

    if (millis < 0) {
      millis = 0;
    }

    String result = sprintf('%02d:%02d:%02d,%03d', [hour, minute, second, millis]);

    return result;
  }

  /// millis to 'HH:mm:ss,SSS --> HH:mm:ss,SSS'
  static String millis2Text(int millisIn, int millisOut) {
    var textTimeIn = millis2TextTime(millisIn);
    var textTimeOut = millis2TextTime(millisOut);
    return '$textTimeIn --> $textTimeOut';
  }
}
