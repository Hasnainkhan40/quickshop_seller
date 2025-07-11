import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:quickshop_seller/const/colors.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/loading_indicator.dart';
import 'package:quickshop_seller/const/strings.dart';
import 'package:quickshop_seller/services/store_services.dart';
import 'package:quickshop_seller/views/messages_screen.dart/chat_screen.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';
import 'package:intl/intl.dart' as intl;

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: white),
        ),
        title: boldText(text: messages, size: 16.0, color: white),
      ),
      body: StreamBuilder(
        stream: StoreServices.getMessage(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return lodingIndicator();
          } else {
            var data = snapshot.data!.docs;
            // print("Loaded messages: ${data.length}");
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(data.length, (index) {
                    var t =
                        data[index]['created_on'] == null
                            ? DateTime.now()
                            : data[index]['created_on'].toDate();
                    var time = intl.DateFormat("h:mma").format(t);
                    return ListTile(
                      onTap: () {
                        final sender = data[index]['sender_name'] ?? "Unknown";
                        final toId = data[index]['toId'];
                        final fromId = data[index]['fromId'];

                        final friendId =
                            toId == currentUser!.uid ? fromId : toId;

                        Get.to(
                          () => ChatScreen(),
                          arguments: [sender, friendId],
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: purpleColor,
                        child: Icon(Icons.person, color: white),
                      ),
                      title: boldText(
                        text: "${data[index]['sender_name']}",
                        color: fontGrey,
                      ),
                      subtitle: normalText(
                        text: "${data[index]['last_msg']}",
                        color: darkGrey,
                      ),
                      trailing: normalText(text: time, color: darkGrey),
                    ).box.white.roundedSM.outerShadowMd.make();
                  }),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
