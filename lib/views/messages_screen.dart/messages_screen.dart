import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/colors.dart';
import 'package:quickshop_seller/const/strings.dart';
import 'package:quickshop_seller/views/messages_screen.dart/chat_screen.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: darkGrey),
        ),
        title: boldText(text: messages, size: 16.0, color: fontGrey),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: List.generate(
              20,
              (index) => ListTile(
                onTap: () {
                  Get.to(() => ChatScreen());
                },
                leading: CircleAvatar(
                  backgroundColor: purpleColor,
                  child: Icon(Icons.person, color: white),
                ),
                title: boldText(text: "Username", color: fontGrey),
                subtitle: normalText(text: "last message...", color: darkGrey),
                trailing: normalText(text: "10:45PM", color: darkGrey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
