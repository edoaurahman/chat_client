import 'package:chat_client/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _chatScreenState();
}

// ignore: camel_case_types
class _chatScreenState extends State<ChatPage> {
  final controller = Get.find<HomeController>();
  final argument = Get.arguments;

  @override
  void initState() {
    super.initState();
    controller.isChatScreenOpen.value = true;
  }

  @override
  void dispose() {
    controller.isChatScreenOpen.value = false;
    Future.delayed(const Duration(milliseconds: 100), () {
      controller.isRead(argument);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((data) {
      controller.scrollController
          .jumpTo(controller.scrollController.position.maxScrollExtent);
    });

    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _topChat(argument),
                _bodyChat(argument),
                const SizedBox(
                  height: 120,
                )
              ],
            ),
            _formChat(),
          ],
        ),
      ),
    );
  }

  _topChat(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 5),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: const IconButton(
                  icon: Icon(Icons.call, size: 25, color: Colors.white),
                  onPressed: null,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: const Icon(
                  Icons.videocam,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _bodyChat(String username) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
          color: Colors.white,
        ),
        child: Obx(
          () => ListView.builder(
            shrinkWrap: true,
            controller: controller.scrollController,
            itemCount: controller.usersMessage[username]?.length ?? 0,
            itemBuilder: (context, index) {
              final messageList = controller.usersMessage[username]!;
              final isUnreadMessage = controller.isReaded[username] != 0 &&
                  (index + 1) ==
                      messageList.length - controller.isReaded[username]!;

              if (isUnreadMessage) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: Column(
                      children: [
                        Text(
                          'New Message',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        // long line like hr in html
                        Divider(),
                      ],
                    ),
                  ),
                );
              } else {
                return _itemChat(
                  chat: messageList[index].sender == username ? 1 : 0,
                  message: messageList[index].message,
                  time: messageList[index].time,
                );
              }
            },
            physics: const BouncingScrollPhysics(),
          ),
        ),
      ),
    );
  }

  // 0 = Sender
  // 1 = Receiver
  _itemChat({required int chat, String? avatar, message, time}) {
    return Row(
      mainAxisAlignment:
          chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (chat == 0)
          Text(
            '$time',
            style: TextStyle(color: Colors.grey.shade400),
          )
        else
          Avatar(
            imageUrl: avatar,
          ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: chat == 0 ? Colors.indigo.shade100 : Colors.indigo.shade50,
              borderRadius: chat == 0
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
            ),
            child: Text('$message'),
          ),
        ),
        chat == 1
            ? Text(
                '$time',
                style: TextStyle(color: Colors.grey.shade400),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _formChat() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 120,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          color: Colors.white,
          child: TextField(
            controller: controller.messageTextController,
            onSubmitted: (_) => controller.sendMessage(Get.arguments),
            decoration: InputDecoration(
              hintText: 'Type your message...',
              suffixIcon: GestureDetector(
                onTap: () => controller.sendMessage(Get.arguments),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.indigo),
                  padding: const EdgeInsets.all(14),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.all(20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final double size;
  final String? imageUrl;
  final EdgeInsets margin;

  const Avatar({
    Key? key,
    this.imageUrl,
    this.size = 50,
    this.margin = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                )
              : null,
        ),
        child: imageUrl != null
            ? null // Tampilkan gambar profil jika ada
            : Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 216, 216, 216)),
                child: Icon(
                  Icons.person,
                  color: Colors.indigo,
                  size: size *
                      0.8, // Sesuaikan ukuran ikon dengan ukuran kontainer
                ),
              ),
      ),
    );
  }
}
