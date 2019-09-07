import 'dart:convert';
import 'dart:io';

import 'srt_utils.dart';
import 'subtitle.dart';

class SrtParser {
  SrtParser._();

  static const _patternTime = r'^([\d]{2}:[\d]{2}:[\d]{2},[\d]{3}).*([\d]{2}:[\d]{2}:[\d]{2},[\d]{3})$';

  static const _patternNumbers = r'^(\d+)$';

  /// get all subtitles
  static List<Subtitle> getSubtitlesFromFile(String path, {bool newline = true, bool usingNodes = false}) {
    final List<Subtitle> subtitles = [];
    try {
      File file = File(path);
      var lines = file.readAsLinesSync(encoding: utf8);
      RegExp idReg = RegExp(_patternNumbers);
      RegExp timeReg = RegExp(_patternTime);
      Subtitle subtitle;
      StringBuffer buffer = StringBuffer();
      for (var line in lines) {
        // id
        if (idReg.hasMatch(line)) {
          Match match = idReg.firstMatch(line);
          if (subtitle != null) {
            if (usingNodes) {
              subtitle.nextSubtitle = Subtitle();
              subtitle = subtitle.nextSubtitle;
            } else {
              subtitle = Subtitle();
            }
          } else {
            subtitle = Subtitle();
          }
          subtitle.id = int.parse(match.group(1));
        }
        // time
        else if (timeReg.hasMatch(line)) {
          Match match = timeReg.firstMatch(line);
          subtitle.startTime = match.group(1);
          subtitle.endTime = match.group(2);
          subtitle.timeIn = SrtUtils.textTime2Millis(subtitle.startTime);
          subtitle.timeOut = SrtUtils.textTime2Millis(subtitle.endTime);
        } else {
          // text
          if (line.isNotEmpty) {
            buffer.write(line);
            // for new lines '\n' removed from BufferedReader
            if (newline) {
              buffer.write('\n');
            } else if (!line.endsWith(' ')) {
              buffer.write(' ');
            }
          }
          // empty line
          else {
            // handle empty lines inside subtitle
            // maybe end or start
            if (buffer.isEmpty || subtitle == null) {
              continue;
            }

            var srt = buffer.toString();
            // clear all tags
            srt = srt.substring(0, srt.length - 1).replaceAll(RegExp(r'<[^>]*>'), '');

            subtitle.text = srt;
            subtitles.add(subtitle);
            // reset
            buffer.clear();
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return subtitles;
  }

  /// find subtitle
  static int findIndexByBinarySearch(List<Subtitle> listSubtitles, int timeMillis) {
    int low = 0;
    int high = listSubtitles.length - 1;
    int middle = 0;
    if (timeMillis < listSubtitles[0].timeIn || timeMillis > listSubtitles[high].timeOut || low > high) {
      return -1;
    }
    while (low <= high) {
      middle = (low + high) ~/ 2;
      var timeIn = listSubtitles[middle].timeIn;
      var timeOut = listSubtitles[middle].timeOut;
      if (timeMillis > timeOut) {
        low = middle + 1;
      } else if (timeMillis < timeIn) {
        high = middle - 1;
      } else {
        if (timeMillis >= timeIn && timeMillis <= timeOut) {
          return middle;
        }
        break;
      }
    }
    return -1;
  }
}
