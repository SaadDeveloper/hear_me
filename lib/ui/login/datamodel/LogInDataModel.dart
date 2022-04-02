
import 'package:flutter/material.dart';
import 'package:hear_me_final/utils/Params.dart';

import 'LogInData.dart';

class LogInDataModel{
  BuildContext? context;

  String? email;
  String? password;



  Map<String,dynamic>toJson()=>{
    Params.EMAIL: email,
    Params.PASSWORD: password,
  };




}