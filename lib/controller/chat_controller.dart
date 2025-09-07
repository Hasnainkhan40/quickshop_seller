import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/controller/home_controller.dart';

class ChatsController extends GetxController {
  @override
  void onInit() {
    getChatId();
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.offset;

      // user is near bottom if within 100px of max scroll
      isNearBottom.value = (maxScroll - currentScroll) < 100;
    });
    super.onInit();
  }

  var chats = firebaseFirestore.collection(chatsCollction);

  var friendName = Get.arguments[0];
  var frinedId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username;
  var currentId = currentUser!.uid;

  var msgController = TextEditingController();
  var scrollController = ScrollController();
  var isNearBottom = true.obs; // 👈 tracks if user is near bottom

  dynamic chatDocId;

  var isLoading = false.obs;

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  getChatId() async {
    isLoading(true);
    await chats
        .where('users', isEqualTo: {frinedId: null, currentId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            chatDocId = snapshot.docs.single.id;
          } else {
            chats
                .add({
                  'created_on': null,
                  'last_msg': '',
                  'users': [frinedId, currentId]..sort(),
                  'toId': '',
                  'fromId': '',
                  'friend_name': friendName,
                  'sender_name': senderName,
                })
                .then((value) {
                  chatDocId = value.id;
                });
          }
        });
    isLoading(false);
  }

  sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': frinedId,
        'fromId': currentId,
      });
      chats.doc(chatDocId).collection(messageCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }
}
