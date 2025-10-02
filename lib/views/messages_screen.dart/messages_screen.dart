import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:quickshop_seller/const/colors.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/loading_indicator.dart';
import 'package:quickshop_seller/const/strings.dart';
import 'package:quickshop_seller/services/store_services.dart';
import 'package:quickshop_seller/views/messages_screen.dart/chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.6),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(0.2)),
          ),
        ),
        title: Text(
          messages,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: -0.2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black87,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        //title: boldText(text: messages, size: 16.0, color: white),
      ),

      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search here...",
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Chats list
          Expanded(
            child: StreamBuilder(
              stream: StoreServices.getMessage(currentUser!.uid),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return lodingIndicator();
                } else {
                  var data = snapshot.data!.docs;

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index) {
                      var t =
                          data[index]['created_on'] == null
                              ? DateTime.now()
                              : data[index]['created_on'].toDate();
                      var time = intl.DateFormat("h:mm a").format(t);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            final sender =
                                data[index]['sender_name'] ?? "Unknown";
                            final toId = data[index]['toId'];
                            final fromId = data[index]['fromId'];
                            final friendId =
                                toId == currentUser!.uid ? fromId : toId;

                            Get.to(
                              () => const ChatScreen(),
                              arguments: [sender, friendId],
                            );
                          },
                          leading: const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blueGrey,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),

                          // leading: CircleAvatar(
                          //   radius: 24,
                          //   backgroundImage:
                          //       data[index]['sender_image'] != null
                          //           ? NetworkImage(data[index]['sender_image'])
                          //           : null,
                          //   backgroundColor: Colors.grey.shade300,
                          //   child:
                          //       data[index]['sender_image'] == null
                          //           ? const Icon(
                          //             Icons.person,
                          //             color: Colors.white,
                          //           )
                          //           : null,
                          // ),
                          title: Text(
                            data[index]['sender_name'],
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            data[index]['last_msg'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          trailing: Text(
                            time,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
