import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:eschoolmobile/helpers.dart';
import 'package:eschoolmobile/services/local_notification_service.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  static String? fMCToken;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    fMCToken = await Helpers.getFMCToken();
    if (fMCToken == null) {
      fMCToken = await _firebaseMessaging.getToken();
      await Helpers.saveFMCToken(fMCToken!);
    }
    // FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService().showNotification(
        message.notification?.title,
        message.notification?.body,
      );
      // Handle foreground messages here
    });
  }
}
