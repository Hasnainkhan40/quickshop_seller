import 'package:quickshop_seller/const/const.dart';

import 'package:intl/intl.dart' as intl;

Widget chatBubbel(Map<String, dynamic> data) {
  var t =
      data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();
  var time = intl.DateFormat("h:mma").format(t);
  bool isCurrentUser = data['uid'] == currentUser!.uid;
  return Directionality(
    textDirection:
        data['uid'] == currentUser!.uid ? TextDirection.rtl : TextDirection.ltr,
    // textDirection: TextDirection.ltr,
    child: Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color:
            data['uid'] == currentUser!.uid
                ? purpleColor
                : Colors.blueGrey[900],
        // color: purpleColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(isCurrentUser ? 20 : 0),
          bottomRight: Radius.circular(isCurrentUser ? 0 : 20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "${data['msg']}".text.white.size(15).make(),
          // normalText(text: "your message here..."),
          10.heightBox,
          time.text.color(white.withOpacity(0.5)).make(),
          //normalText(text: "10.45PM"),
        ],
      ),
    ),
  );
}
