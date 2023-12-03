import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_main_page/main.dart';
import 'package:get/get.dart';

import '../constants/firebase_const.dart';

var isSubscribe = false;

class NotificationController extends GetxController {
  @override
  Future<void> onInit() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    print(settings.authorizationStatus);

    _getToken();

    _onMessage();
    super.onInit();
  }

  Future<void> _getToken() async {
    String? token = await messaging.getToken();

    try {
      if (prefs.getBool('isSubscribe') == false) {
        return;
      } else {
        FirebaseMessaging.instance.subscribeToTopic("connectTopic");
        prefs.setBool('isSubscribe', true);
      }

      print('이 장치의 토큰 : $token');
    } catch (e) {}
  }

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_imprtance_channel', "High Importance Notification",
      description: 'This channel is used for important notification.',
      importance: Importance.high);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _onMessage() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
          android: AndroidInitializationSettings('mipmap/ic_launcher'),
          iOS: IOSInitializationSettings()),
      onSelectNotification: (String? payload) async {},
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description),
          ),
        );
      }

      if (message.notification != null) {
        var db = FirebaseFirestore.instance.collection("UserInfo");

        db
            .doc(prefs.getString('userNumber').toString())
            .collection('alarmlog')
            .add({
          "alarm": message.notification!.body,
          "index": prefs.getInt('index'),
          "status": false,
        });

        _addIndex();
      }
    });
  }

  Future<void> _addIndex() async {
    var number = await prefs.getInt('index')! + 1;
    await prefs.setInt('index', number);
  }
}
