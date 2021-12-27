import 'package:intl/intl.dart';

class DateUtility{

  DateUtility(){

  }

  String convertDate(String inputDate){
    DateTime dateTime = DateFormat("dd/MM/yyyy").parse(inputDate);

    if(_isToday(dateTime)){
      return 'Today';
    }
    return DateFormat('dd MMM').format(dateTime);
  }

  bool _isToday(DateTime inputDate){
    final now = DateTime.now();
    return now.day == inputDate.day &&
    now.month == inputDate.month &&
    now.year == inputDate.year;
  }

  bool isWorkoutToday(String workoutDate){
    DateTime dateTime = DateFormat("dd/MM/yyyy").parse(workoutDate);

    return _isToday(dateTime);
  }

  String convertTimestampToTimePassed(int millis){
    var duration = Duration(milliseconds: millis);
    /* 12h 33m 12s*/

    int hours = duration.inHours;
    int minutesRemainaing = duration.inMilliseconds - Duration(hours: hours).inMilliseconds; /* 33m 12s */


    int minutes = Duration(milliseconds: minutesRemainaing).inMinutes;
    int seconds = Duration(milliseconds: Duration(milliseconds: minutesRemainaing).inMilliseconds - Duration(minutes: minutes).inMilliseconds).inSeconds;

    if(hours > 0){
      return "${hours}s:${minutes}m:${seconds}s";
    }else if (minutes > 0){
      return "${minutes}m:${seconds}s";
    }else if (seconds >= 0){
      return "${seconds}s";
    }

    return "";
  }
}