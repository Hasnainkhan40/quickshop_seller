import 'package:flutter/material.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/images.dart';
import 'package:quickshop_seller/views/widgets/custom_textfield.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';

class EditProfilescreen extends StatelessWidget {
  const EditProfilescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        title: boldText(text: editProfilr, size: 16.0),
        actions: [TextButton(onPressed: () {}, child: normalText(text: save))],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(
              imgProduct,
              width: 150,
            ).box.roundedFull.clip(Clip.antiAlias).make(),
            10.heightBox,
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: white),
              onPressed: () {},
              child: normalText(text: changeImage, color: fontGrey),
            ),
            10.heightBox,
            Divider(color: white),
            customTextField(lable: name, hint: "eg. Bada Devs"),
            10.heightBox,
            customTextField(lable: password, hint: passwordHint),
            10.heightBox,
            customTextField(lable: confirmPass, hint: passwordHint),
          ],
        ),
      ),
    );
  }
}
