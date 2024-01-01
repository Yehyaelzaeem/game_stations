import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call initializeApp before using other Firebase services.
  // await Firebase.initializeApp();
  _onMessageStreamController.add(message.data);

  print("Handling a background message: ${message.data}");
}

StreamController<Map<String, dynamic>> _onMessageStreamController =
    StreamController.broadcast();

class FirebaseNotifications {
  FirebaseMessaging? _firebaseMessaging;

  StreamController<Map<String, dynamic>> get notificationSubject {
    return _onMessageStreamController;
  }

  void killNotification() {
    _onMessageStreamController.close();
  }

  FlutterLocalNotificationsPlugin? _notificationsPlugin;

  Map<String, dynamic>? _not;

  Future<void> setUpFirebase() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging!.setAutoInitEnabled(true);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    // checkLastMessage();
    firebaseCloudMessagingListeners();

    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    // _notificationsPlugin!
    //     .resolvePlatformSpecificImplementation<
    //         IOSFlutterLocalNotificationsPlugin>()
    //     ?.requestPermissions(
    //       alert: true,
    //       badge: true,
    //       sound: true,
    //     );
    var android = AndroidInitializationSettings('@mipmap/launcher_icon');
    var ios = IOSInitializationSettings(
        defaultPresentBadge: true,
        defaultPresentAlert: true,
        defaultPresentSound: true);
    var initSetting = InitializationSettings(android: android, iOS: ios);
    _notificationsPlugin!.initialize(initSetting,
        onSelectNotification: onSelectNotification);
  }

  Future<void> checkLastMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print(initialMessage.data.toString());
      handlePath(initialMessage.data);
    }
  }

  Future<void> firebaseCloudMessagingListeners() async {
    if (Platform.isIOS) iOSPermission();
    await FirebaseMessaging.instance.subscribeToTopic('gamestation');

    FirebaseMessaging.onMessage.listen((RemoteMessage data) {
      print('on message ${data.data}');
      print('on message notification body ${data.notification!.body!}');
      print('on message notification title ${data.notification!.title}');
      _onMessageStreamController.add(data.data);

      _not = data.data;
      showNotification(
          data.data, data.notification!.title!, data.notification!.body!);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage data) {
      print('on Opened ' + data.data.toString());

      handlePath(data.data);
    });
  }

  showNotification(
      Map<String, dynamic> _message, String title, String body) async {
    print("Notification Response : $_message");

    var androidt = AndroidNotificationDetails(
        'channel_id', 'channel_name', 'channel_description',
        priority: Priority.high,
        channelShowBadge: true,
        playSound: true,
        ticker: 'ticker',
        icon: "@mipmap/launcher_icon",
        enableVibration: true,
        enableLights: true,
        importance: Importance.max);
    var iost = IOSNotificationDetails();
    var platform = NotificationDetails(android: androidt, iOS: iost);
    await _notificationsPlugin!.show(0, title, body, platform, payload: "");
  }

  Future<void> showNotificationWithAttachment(Map<String, dynamic> _message,
      String title, String body, String imageUrl) async {
    print("Notification Response : $_message");
    var attachmentPicturePath = await _downloadAndSaveFile(
        imageUrl ?? 'https://via.placeholder.com/800x200',
        'attachment_img.jpg');
    var iOSPlatformSpecifics = IOSNotificationDetails(
      attachments: [IOSNotificationAttachment(attachmentPicturePath)],
    );
    var bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(attachmentPicturePath),
      contentTitle: '<b>$title</b>',
      htmlFormatContentTitle: true,
      summaryText: '$body',
      htmlFormatSummaryText: true,
    );
    var androidChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      'channel_description',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
    );
    var notificationDetails = NotificationDetails(
        android: androidChannelSpecifics, iOS: iOSPlatformSpecifics);
    print("notificationDetails $notificationDetails");
    await _notificationsPlugin!.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  void iOSPermission() {
    FirebaseMessaging.instance.requestPermission();
  }

  void handlePath(Map<String, dynamic> dataMap) {
    handlePathByRoute(dataMap);
  }

  Future<void> handlePathByRoute(Map<String, dynamic> dataMap) async {
    String type = dataMap["key"].toString();
    print("type $type");
    // push(NotificationsScreen());
  }

  Future<void> onSelectNotification(String payload) async {
    print(payload.toString());
    handlePath(_not!);
  }
}
