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
}