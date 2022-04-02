
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:hear_me_final/utils/Preference.dart';
import 'package:intl/intl.dart';

import 'Color.dart';

class Utils {

  static String getCurrentDateTime(){
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);
  }

  static showToast(BuildContext context, String msg,
      {double duration = 2, ToastGravity? gravity}) {
    if (gravity == null) gravity = ToastGravity.BOTTOM;

    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: CColor.white,
        textColor: CColor.txt_black,
        fontSize: 14.0);
  }

  static bool isLogin() {
    var uid = Preference.shared.getString(Preference.USER_ID);
    return (uid != null && uid.isNotEmpty);
  }

  static int calculateDate(int year, int month, int day){
    DateTime currentDate = DateTime.now();
    int month1 = currentDate.month;
    int age = currentDate.year - year;
    if (month > month1) {
      age--;
    } else if (month1 == month) {
      int day1 = currentDate.day;
      if (day > day1) {
        age--;
      }
    }
    return age;
  }

  static showErrorDialog(BuildContext context, dynamic err, {VoidCallback? voidCallback}){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(err.toString()),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: voidCallback == null?() {
                  Navigator.of(context).pop();
                }: voidCallback,
              )
            ],
          );
        });
  }

}
