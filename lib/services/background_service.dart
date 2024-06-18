import 'dart:async';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';

bool isLoggedIn = false;

void initializeService() {
  FlutterBackgroundService().configure(
    iosConfiguration: IosConfiguration(
      onBackground: onIosBackground,
      autoStart: true,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
    ),
  );
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize the notification group and channel
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: "task_channel_group",
        channelKey: "task_channel",
        channelName: "Task Notification",
        channelDescription: "Task Notification Channel"
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: "task_channel_group",
        channelGroupName: "Task Group"
      )
    ]
  );

  bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // Check tasks every minute if user is logged in
  Timer.periodic(const Duration(minutes: 1), (timer) async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('sorttasks_email');
    final String? password = prefs.getString('sorttasks_password');

    if (email != null && password != null) {
      isLoggedIn = await FirestoreUtils.login(email, password);
    }

    if (isLoggedIn) {
      // Check tasks due within 3 days
      await FirestoreUtils.checkTasksDueWithin3Days();
    }
  });
}

// Missing XCode to configure notifications for iOS, so no implementation here
@pragma('vm:entry-point')
FutureOr<bool> onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}
