//import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: darkGrey),
        ),
        title:
            (controller.friendName ?? "Friend")
                .toString()
                .text
                .bold
                .color(darkGrey)
                .make(),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () =>
                  controller.isLoading.value
                      ? Center(child: lodingIndicator())
                      : Expanded(
                        child: StreamBuilder(
                          stream: StoreServices.getChatMessages(
                            controller.chatDocId.toString(),
                          ),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot,
                          ) {
                            if (!snapshot.hasData) {
                              return Center(child: lodingIndicator());
                            } else if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                child:
                                    "Send a message..".text
                                        .color(Colors.deepPurple)
                                        .make(),
                              );
                            } else {
                              return ListView(
                                children:
                                    snapshot.data!.docs.mapIndexed((
                                      doc,
                                      index,
                                    ) {
                                      final rawData = doc.data();
                                      if (rawData == null) {
                                        return SizedBox();
                                      }

                                      var data =
                                          rawData as Map<String, dynamic>;

                                      return Align(
                                        alignment:
                                            data['uid'] != null &&
                                                    data['uid'] ==
                                                        currentUser?.uid
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        child: chatBubbel(data),
                                      );
                                    }).toList(),
                              );
                            }
                          },
                        ),
                      ),
            ),
            10.heightBox,
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.msgController,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: "Enter message",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: purpleColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: purpleColor),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.sendMsg(controller.msgController.text);
                      controller.msgController.clear();
                    },
                    icon: Icon(Icons.send, color: purpleColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ListView.builder(
//                   itemCount: 20,
//                   itemBuilder: ((context, index) {
//                     return chatBubbel();
//                   }),
//                 ),