import 'package:srt_parser/srt_parser.dart';

main(List<String> arguments) async {
//  final time = '10:20:30,333';
//  var msTime = SrtUtils.textTime2Millis(time);
//  print(msTime);
//  var textTime = SrtUtils.millis2TextTime(msTime);
//  print(textTime);

//  String path = './files/test.srt';
  String path = './files/001 Welcome-en_US.srt';
  var subtitles = SrtParser.getSubtitlesFromFile(path);
  subtitles.forEach((subtitle) => print(subtitle));

//  for (var subtitle in subtitles) {
//    print(subtitle);
//  }
  var index = SrtParser.findIndexByBinarySearch(subtitles, 15000);
  if (index > -1) {
    print(subtitles[index]);
  } else {
    print('Not found');
  }
}
