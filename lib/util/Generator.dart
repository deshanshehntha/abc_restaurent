///Student ID : IT17103732
///Name : Silva N.P.S
///Class to get the current date and time

import 'package:intl/intl.dart';

class Generator{

  ///function to return the current date
  String getCurrentDate(){

    var now = new DateTime.now();

    return new DateFormat("dd-MM-yyyy").format(now);
  }

  ///function to return the current time
  String getCurrentTime(){
    var now = new DateTime.now();

    return new DateFormat("H:m:s").format(now);
  }
}