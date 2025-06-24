import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/colors.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/strings.dart';
import 'package:quickshop_seller/views/widgets/custom_textfield.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';

class ShopSetting extends StatelessWidget {
  const ShopSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: white),
        ),
        title: boldText(text: shopSetting, size: 16.0),
        actions: [TextButton(onPressed: () {}, child: normalText(text: save))],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            customTextField(lable: shopname, hint: nameHint),
            10.heightBox,
            customTextField(lable: address, hint: shopAddressHint),
            10.heightBox,
            customTextField(lable: mobile, hint: shopMobileHint),
            10.heightBox,
            customTextField(lable: website, hint: shopWebsiteHint),
            10.heightBox,
            customTextField(
              isDesc: true,
              lable: description,
              hint: shopDescHint,
            ),
          ],
        ),
      ),
    );
  }
}
