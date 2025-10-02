import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:intl/intl.dart' as intl;

Widget chatBubble(Map<String, dynamic> data) {
  final bool isMe = data['uid'] == currentUser!.uid;
  final DateTime t =
      data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();
  final String time = intl.DateFormat("h:mm a").format(t);

  return Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      constraints: BoxConstraints(maxWidth: Get.context!.width * 0.7),
      decoration: BoxDecoration(
        color: isMe ? primaryColors : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isMe ? 18 : 0),
          bottomRight: Radius.circular(isMe ? 0 : 18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "${data['msg']}",
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: isMe ? Colors.white.withOpacity(0.7) : Colors.black54,
            ),
          ),
        ],
      ),
    ),
  );
}
