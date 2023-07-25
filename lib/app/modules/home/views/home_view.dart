import 'package:chat_client/app/data/models/user_model.dart';
import 'package:chat_client/app/modules/home/controllers/home_controller.dart';
import 'package:chat_client/app/modules/home/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  @override
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          children: [
            _top(),
            _body(),
          ],
        ),
      ),
    );
  }

  Widget _top() {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 30, bottom: 30),
      child: const SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chat with \nyour friends',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Obx(
              () => ListView.builder(
                padding: const EdgeInsets.only(top: 35),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.usersMessage.length,
                itemBuilder: (context, index) {
                  final username =
                      controller.usersMessage.keys.elementAt(index);
                  final userMessages = controller.usersMessage[username] ?? [];

                  // Get the latest message for this user
                  final latestMessage =
                      userMessages.isNotEmpty ? userMessages.last : null;
                  final latestTime = latestMessage?.time ?? '';

                  return _itemChats(
                    avatar: 'assets/images/2.jpg',
                    name: username,
                    chat: latestMessage?.message ?? 'No messages yet',
                    time: latestTime,
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: FloatingActionButton(
                  onPressed: () => Get.to(() => StartMessage()),
                  backgroundColor: Colors.indigo,
                  child: const Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemChats(
      {String avatar = '', name = '', chat = '', time = '00.00'}) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          Get.to(() => ChatPage(), arguments: name);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 20),
          elevation: 0,
          child: Row(
            children: [
              // Icon(Icons.person, color: Colors.indigo, size: 60),
              Avatar(image: avatar),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$name',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$time',
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$chat',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class Avatar extends StatelessWidget {
  final double size;
  final String image;
  final EdgeInsets margin;

  const Avatar(
      {super.key,
      required this.image,
      this.size = 50,
      this.margin = const EdgeInsets.all(0)});

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
          image: DecorationImage(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}

class StartMessage extends GetView<HomeController> {
  StartMessage({super.key});
  @override
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          children: [
            _top(),
            _body(),
          ],
        ),
      ),
    );
  }

  Widget _top() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              child: TextField(
                onSubmitted: (value) => controller.searchUser(value),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: SizedBox(
        child: Obx(
          () => ListView.builder(
            itemCount: controller.listUser.length,
            itemBuilder: (context, index) {
              return _itemUser(index: index);
            },
          ),
        ),
      ),
    );
  }

  Widget _itemUser({required int index}) {
    final sharedPref = GetStorage();
    List<Map<String, dynamic>>? userList =
        sharedPref.read('userList')?.cast<Map<String, dynamic>>();

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        title: Text(controller.listUser[index].username!),
        onTap: () {
          User selectedUser = controller.listUser[index];

          // Add the selected user to the list
          if (userList == null) {
            userList = [selectedUser.toJson()];
          } else {
            userList!.add(selectedUser.toJson());
          }

          // Save the list of users to GetStorage
          sharedPref.write('userList', userList);

          Get.off(() => ChatPage(), arguments: selectedUser.username);
        },
      ),
    );
  }
}
