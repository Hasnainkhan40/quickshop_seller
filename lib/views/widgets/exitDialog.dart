import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/styles.dart';
import 'package:quickshop_seller/views/widgets/our_button.dart';

Widget exitDialog(context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child:
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            "Comfirm".text.fontFamily(bold).size(18).color(darkFontGrey).make(),
            const Divider(),
            10.heightBox,
            "Are you sure you want to exit?".text
                .size(16)
                .color(darkFontGrey)
                .make(),
            10.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ourButton(
                  color: redColor,
                  onPress: () {
                    SystemNavigator.pop();
                  },
                  textcolor: whiteColor,
                  title: "Yes",
                ),
                ourButton(
                  color: redColor,
                  onPress: () {
                    Navigator.pop(context);
                  },
                  textcolor: whiteColor,
                  title: "No",
                ),
              ],
            ),
            10.heightBox,
          ],
        ).box.color(lightGrey).roundedSM.make(),
  );
}
