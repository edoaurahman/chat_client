import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';

class FirebaseApi {
  final _fireBaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _fireBaseMessaging.requestPermission();
    final fcmToken = await _fireBaseMessaging.getToken();
    if (GetStorage().read('fcmToken') == null) {
      GetStorage().write('fcmToken', fcmToken);
    }
  }
}
