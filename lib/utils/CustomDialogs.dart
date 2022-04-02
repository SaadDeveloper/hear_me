
import 'package:flutter/material.dart';

class CustomDialogs{

  static showProgressDialog(BuildContext context, String msg) async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              backgroundColor: Colors.black87,
              content: loadingIndicator(msg),
            )
        );
      },
    );
  }

  static hideOpenDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Widget loadingIndicator(String text){
    return Container(
        padding: EdgeInsets.all(16),
        color: Colors.black.withOpacity(0.8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(),
              _getHeading(),
              _getText(text)
            ]
        )
    );
  }
  static Widget _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: CircularProgressIndicator(
                strokeWidth: 3
            ),
            width: 32,
            height: 32
        ),
        padding: EdgeInsets.only(bottom: 16)
    );
  }

  static Widget _getHeading() {
    return Padding(
        child: Text(
          'Please wait …',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16
          ),
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.only(bottom: 4)
    );
  }

  static Widget _getText(String displayedText) {
    return Text(
      displayedText,
      style: TextStyle(
          color: Colors.white,
          fontSize: 14
      ),
      textAlign: TextAlign.center,
    );
  }
}