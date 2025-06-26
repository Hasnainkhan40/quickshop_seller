import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/images.dart';
import 'package:quickshop_seller/const/loading_indicator.dart';
import 'package:quickshop_seller/controller/profile_controller.dart';
import 'package:quickshop_seller/views/widgets/custom_textfield.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';

class EditProfilescreen extends StatefulWidget {
  final String? username;
  const EditProfilescreen({super.key, this.username});

  @override
  State<EditProfilescreen> createState() => _EditProfilescreenState();
}

class _EditProfilescreenState extends State<EditProfilescreen> {
  var controller = Get.find<ProfileController>();

  @override
  void initState() {
    controller.nameController.text = widget.username!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: editProfile, size: 16.0),
          actions: [
            controller.isLoading.value
                ? lodingIndicator(circleColor: white)
                : TextButton(
                  onPressed: () async {
                    controller.isLoading(true);
                    //if old password matches data base
                    if (controller.snapshotData['password'] ==
                        controller.oldpassController.text) {
                      await controller.changeAuthPassword(
                        email: controller.snapshotData['email'],
                        password: controller.oldpassController.text,
                        newpassword: controller.newpassController.text,
                      );

                      await controller.updateProfile(
                        imageUrl: '',
                        name: controller.nameController.text,
                        password: controller.newpassController.text,
                      );
                      VxToast.show(context, msg: "Update");
                    } else if (controller
                            .oldpassController
                            .text
                            .isEmptyOrNull &&
                        controller.nameController.text.isEmptyOrNull) {
                      await controller.updateProfile(
                        imageUrl: '',
                        name: controller.nameController.text,
                        password: controller.snapshotData['password'],
                      );
                      VxToast.show(context, msg: "Update");
                    } else {
                      VxToast.show(context, msg: "Some error occured");
                      controller.isLoding(false);
                    }
                  },
                  child: normalText(text: save),
                ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              controller.snapshotData['imageUrl'] == '' &&
                      controller.profileImagePath.isEmpty
                  ? Image.asset(
                    imgProduct,
                    width: 100,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make()
                  : controller.snapshotData['imageUrl'] != '' &&
                      controller.profileImagePath.isEmpty
                  ? Image.network(
                    controller.snapshotData['imageUrl'],
                    width: 100,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make()
                  : Image.file(
                    File(controller.profileImagePath.value),
                    width: 100,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: white),
                onPressed: () {
                  controller.changeImage(context);
                },
                child: normalText(text: changeImage, color: fontGrey),
              ),
              10.heightBox,
              Divider(color: white),
              customTextField(
                lable: name,
                hint: "eg. Bada Devs",
                controller: controller.nameController,
              ),
              30.heightBox,
              Align(
                alignment: Alignment.centerLeft,
                child: boldText(text: "Chenge your password"),
              ),
              10.heightBox,
              customTextField(
                lable: password,
                hint: passwordHint,
                controller: controller.oldpassController,
              ),
              10.heightBox,
              customTextField(
                lable: confirmPass,
                hint: passwordHint,
                controller: controller.newpassController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
