import 'package:chat_client/app/data/models/message_model.dart';
import 'package:chat_client/app/data/models/user_model.dart';
import 'package:chat_client/app/data/providers/user_provider.dart';
import 'package:chat_client/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:soundpool/soundpool.dart';

class HomeController extends GetxController {
  final userProvider = Get.find<UserProvider>();
  final messageTextController = TextEditingController();
  final DateFormat timeFormat = DateFormat('HH:mm');
  final isChatScreenOpen = false.obs;

  final scrollController = ScrollController();
  // socket?.io instance
  late IO.Socket? socket;
  // Messages list
  final messages = <Message>[].obs;
  final usersMessage = <String, List<Message>>{}.obs;
  // Whether the user has joined the chat
  final joined = false.obs;
  // User name
  final name = ''.obs;
  // Typing display message
  final typingDisplay = ''.obs;
  // is connected
  final isConnected = false.obs;
  final username = GetStorage().read('username');
  final listSearchUser = <User>[].obs;

  // isReaded
  final isReaded = <String, int>{}.obs;

  final _soundpoolOptions = const SoundpoolOptions();

  Soundpool? _pool;
  int? _soundId;

  @override
  void onInit() async {
    super.onInit();
    // Load usersMessage from GetStorage
    Map<String, dynamic>? storedData = GetStorage().read('usersMessage');
    if (storedData != null) {
      usersMessage.assignAll(
        Map<String, List<Message>>.from(storedData.map(
          (key, value) => MapEntry(
              key,
              (value as List<dynamic>)
                  .map((message) => Message.fromJson(message))
                  .toList()),
        )),
      );
    }
    // Load isReaded
    Map<String, dynamic>? storedData2 = GetStorage().read('isReaded');
    if (storedData2 != null) {
      isReaded.assignAll(
        Map<String, int>.from(storedData2.map(
          (key, value) => MapEntry(
            key,
            value,
          ),
        )),
      );
    }

    _pool = Soundpool.fromOptions(options: _soundpoolOptions);
    var asset = await rootBundle.load("assets/audios/pop.wav");
    _soundId = await _pool?.load(asset);

    socket = IO.io(ConfigEnvironment.baseUrl,
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket?.onConnect((_) => {
          showConnectionStatus(true),
          join(),
        });
    socket?.onDisconnect(
        (_) => showConnectionStatus(false, 'Check Internet Connection'));
    socket
        ?.onConnectError((data) => showConnectionStatus(false, 'error: $data'));
    openListener();
  }

// isRead functiom
  void isRead(String username) {
    isReaded[username] = 0;
    GetStorage().write('isReaded', isReaded);
  }

// searchUsername
  void searchUser(String username) async {
    listSearchUser.clear();
    dynamic res = await userProvider.searchUsername(username);
    List<User> users = userProvider.parseUsers(res.bodyString);
    if (res.statusCode == 200) {
      for (var user in users) {
        if (GetStorage().read('username') != user.username) {
          listSearchUser.add(user);
        }
      }
    }
  }

  // Snackbar Notification
  void showConnectionStatus(bool isConnected, [String? message]) {
    final snackBar = GetSnackBar(
      messageText: Text(
        message ?? (isConnected ? 'Connected' : 'Disconnected'),
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isConnected ? Colors.green : Colors.red,
      duration: const Duration(seconds: 1),
    );
    Get.showSnackbar(snackBar);
  }

  void openListener() {
    // Listen for new messages
    socket?.on('newPrivateMessage', (message) async {
      if (message is Map<String, dynamic>) {
        final newMessage = Message(
          sender: message['sender'] ?? '',
          receiver: message['receiver'] ?? '',
          message: message['message'] ?? '',
          time: message['time'] ?? '',
        );
        messages.add(newMessage);
        usersMessage.update(
          message['sender'],
          (value) => [
            ...value,
            newMessage
          ], // Add the new message to the existing list
          ifAbsent: () =>
              [newMessage], // Create a new list with the new message
        );

        await GetStorage().write('usersMessage', usersMessage);
        // play a sound with soundpool
        await _pool?.play(_soundId!);
        Future.delayed(const Duration(milliseconds: 300), () async {
          if (isChatScreenOpen.value) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              curve: Curves.linear,
              duration: const Duration(milliseconds: 300),
            );
          } else {
            // add total number of message
            isReaded.update(
              message['sender'],
              (value) => value + 1,
              ifAbsent: () => 1,
            );

            await GetStorage().write('isReaded', isReaded);
          }
        });
      }
    });
  }

  // Send a message
  void sendMessage(String username) async {
    if (messageTextController.text.isNotEmpty) {
      final Message newMessage = Message(
        sender: GetStorage().read('username'),
        receiver: username,
        message: messageTextController.text,
        time: timeFormat.format(DateTime.now()),
      );
      usersMessage.update(
        username,
        (value) =>
            [...value, newMessage], // Add the new message to the existing list
        ifAbsent: () => [newMessage], // Create a new list with the new message
      );

      socket?.emit('privateMessage', {
        'sender': GetStorage().read('username'),
        'receiver': username,
        'message': messageTextController.text,
        'time': timeFormat.format(DateTime.now()),
      });

      messageTextController.text = '';
      // Save usersMessage to GetStorage
      await GetStorage().write('usersMessage', usersMessage);

      Future.delayed(const Duration(milliseconds: 500), () {
        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );
      });
    }
  }

  // Join the chat
  void join() async {
    socket?.emit('join', {'username': username});
  }

  @override
  void onClose() {
    socket?.dispose();
    messageTextController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void jumpDown() {
    Future.delayed(const Duration(milliseconds: 10), () {
      scrollController.jumpTo(
        scrollController.position.maxScrollExtent,
      );
    });
  }
}
