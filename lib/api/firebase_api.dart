import 'package:chat_client/app/data/models/user_model.dart';
import 'package:chat_client/app/data/providers/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class FirebaseApi {
  final _fireBaseMessaging = FirebaseMessaging.instance;
  final _userProvider = Get.put(UserProvider());

  Future<void> initNotifications() async {
    List<User> users = [];
    await _fireBaseMessaging.requestPermission();
    final fcmToken = await _fireBaseMessaging.getToken(vapidKey: 'BHkzzmB0ZI-AnQ7TQ9Fydvuk3knDrAHyM__A1ekSWiwb-LVWF22R3lkdOCXEPHAsdIYkMOvLUMdNrTopHAFeLOI');
    if(GetStorage().read('fcmToken') != null) {
      dynamic res =
          await _userProvider.searchUsername(GetStorage().read('username'));
      users = _userProvider.parseUsers(res.bodyString);
      if (res.statusCode == 200) {
        for (var user in users) {
          if (GetStorage().read('fcmToken') != user.fcmToken) {
            await _userProvider.patchUser(
                user.username!, user.email!, fcmToken!);
          }
        }
      }
    }

    if (GetStorage().read('fcmToken') == null) {
      GetStorage().write('fcmToken', fcmToken);
    }

    _fireBaseMessaging.onTokenRefresh.listen((fcmToken) async {
      GetStorage().write('fcmToken', fcmToken);
      for (var user in users) {
        if (GetStorage().read('fcmToken') != user.fcmToken) {
          await _userProvider.patchUser(user.username!, user.email!, fcmToken);
        }
      }
    });
  }
}
