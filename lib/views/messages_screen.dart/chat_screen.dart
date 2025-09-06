// //import 'dart:developer';

// import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:quickshop_seller/const/const.dart';
// import 'package:quickshop_seller/const/loading_indicator.dart';
// import 'package:quickshop_seller/controller/chat_controller.dart';
// import 'package:quickshop_seller/services/store_services.dart';
// import 'package:quickshop_seller/views/messages_screen.dart/components/chat_bubble.dart';

// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(ChatsController());

//     return Scaffold(
//       backgroundColor: lightGrey,
//       appBar: AppBar(
//         backgroundColor: Colors.white.withOpacity(0.6), // translucent
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         flexibleSpace: ClipRRect(
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // iOS blur effect
//             child: Container(color: Colors.white.withOpacity(0.2)),
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             size: 20,
//             color: Colors.black87,
//           ),
//           onPressed: () {
//             Get.back();
//           },
//         ),
//         title: Text(
//           controller.friendName ?? "Friend",
//           style: GoogleFonts.inter(
//             // or sfPro if added
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//             letterSpacing: -0.2, // iOS-like tight spacing
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Obx(
//               () =>
//                   controller.isLoading.value
//                       ? Center(child: lodingIndicator())
//                       : Expanded(
//                         child: StreamBuilder(
//                           stream: StoreServices.getChatMessages(
//                             controller.chatDocId.toString(),
//                           ),
//                           builder: (
//                             BuildContext context,
//                             AsyncSnapshot<QuerySnapshot> snapshot,
//                           ) {
//                             if (!snapshot.hasData) {
//                               return Center(child: lodingIndicator());
//                             } else if (snapshot.data!.docs.isEmpty) {
//                               return Center(
//                                 child:
//                                     "Send a message..".text
//                                         .color(Colors.deepPurple)
//                                         .make(),
//                               );
//                             } else {
//                               return ListView(
//                                 children:
//                                     snapshot.data!.docs.mapIndexed((
//                                       doc,
//                                       index,
//                                     ) {
//                                       final rawData = doc.data();
//                                       if (rawData == null) {
//                                         return SizedBox();
//                                       }

//                                       var data =
//                                           rawData as Map<String, dynamic>;

//                                       return Align(
//                                         alignment:
//                                             data['uid'] != null &&
//                                                     data['uid'] ==
//                                                         currentUser?.uid
//                                                 ? Alignment.centerRight
//                                                 : Alignment.centerLeft,
//                                         child: chatBubble(data),
//                                       );
//                                     }).toList(),
//                               );
//                             }
//                           },
//                         ),
//                       ),
//             ),
//             10.heightBox,
//             SizedBox(
//               height: 60,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: controller.msgController,
//                       decoration: const InputDecoration(
//                         isDense: true,
//                         hintText: "Enter message",
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: purpleColor),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: purpleColor),
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       controller.sendMsg(controller.msgController.text);
//                       controller.msgController.clear();
//                     },
//                     icon: Icon(Icons.send, color: purpleColor),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ListView.builder(
// //                   itemCount: 20,
// //                   itemBuilder: ((context, index) {
// //                     return chatBubbel();
// //                   }),
// //                 ),

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/loading_indicator.dart';
import 'package:quickshop_seller/controller/chat_controller.dart';
import 'package:quickshop_seller/services/store_services.dart';
import 'package:quickshop_seller/views/messages_screen.dart/components/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());

    return Scaffold(
      backgroundColor: lightGrey, // ✅ Matches sample soft background
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.6), // ✅ translucent
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // ✅ iOS blur
            child: Container(color: Colors.white.withOpacity(0.2)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.friendName ?? "Friend",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: -0.2,
          ),
        ),
      ),

      body: Column(
        children: [
          // ✅ Chat messages
          Expanded(
            child: Obx(
              () =>
                  controller.isLoading.value
                      ? Center(child: lodingIndicator())
                      : StreamBuilder<QuerySnapshot>(
                        stream: StoreServices.getChatMessages(
                          controller.chatDocId.toString(),
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: lodingIndicator());
                          } else if (snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                "Send a message...",
                                style: GoogleFonts.inter(
                                  color: Colors.deepPurple,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          } else {
                            return Stack(
                              children: [
                                ListView.builder(
                                  padding: const EdgeInsets.all(12),
                                  //controller: controller.scrollController,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    var doc = snapshot.data!.docs[index];
                                    var data =
                                        doc.data() as Map<String, dynamic>? ??
                                        {};
                                    return Align(
                                      alignment:
                                          data['uid'] == currentUser?.uid
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                      child: chatBubble(data),
                                    );
                                  },
                                ),

                                // // FAB reacts to isNearBottom changes
                                // Obx(() {
                                //   if (!controller.isNearBottom.value) {
                                //     return Positioned(
                                //       bottom: 10,
                                //       right: 10,
                                //       child: FloatingActionButton(
                                //         mini: true,
                                //         backgroundColor: Colors.green,
                                //         child: const Icon(
                                //           Icons.arrow_downward,
                                //           color: Colors.black,
                                //         ),
                                //         onPressed:
                                //             () => controller.scrollToBottom(),
                                //       ),
                                //     );
                                //   } else {
                                //     return const SizedBox.shrink(); // nothing shown
                                //   }
                                // }),
                              ],
                            );
                          }
                        },
                      ),
            ),
          ),

          // ✅ Input field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                // Input
                Expanded(
                  child: TextFormField(
                    controller: controller.msgController,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: "Enter message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(color: purpleColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(color: purpleColor),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Send button
                CircleAvatar(
                  radius: 24,
                  backgroundColor: primaryColors,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (controller.msgController.text.trim().isNotEmpty) {
                        controller.sendMsg(
                          controller.msgController.text.trim(),
                        );
                        controller.msgController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
