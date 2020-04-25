import 'package:intl/intl.dart';

class Generator{

  String getCurrentDate(){

    var now = new DateTime.now();

    return new DateFormat("dd-MM-yyyy").format(now);
  }

  String getCurrentTime(){
    var now = new DateTime.now();

    return new DateFormat("H:m:s").format(now);
  }
}