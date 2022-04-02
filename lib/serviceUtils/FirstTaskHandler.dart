import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hear_me_final/custom/drawer/datamodel/SongDTO.dart';
import 'package:hear_me_final/firebase/FirebaseInstantiation.dart';
import 'package:hear_me_final/utils/Preference.dart';

class FirstTaskHandler implements TaskHandler {

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    // streamSubscription = positionStream.listen((event) {
    //   // Update notification content.
    //   FlutterForegroundTask.updateService(
    //       notificationTitle: 'Current Position',
    //       notificationText: '${event.latitude}, ${event.longitude}');
    //
    //   // Send data to the main isolate.
    //   sendPort?.send(event);
    // });
    sendPort?.send(timestamp);
    print("Task handler - OnStart");
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    sendPort?.send(timestamp);
    // print("Task handler - onEvent");
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print("Task handler - onDestroy");
  }
}
