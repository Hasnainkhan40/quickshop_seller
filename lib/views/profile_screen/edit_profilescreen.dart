import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
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
        backgroundColor: lightGrey,
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.6), // translucent
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ), // iOS blur effect
              child: Container(color: Colors.white.withOpacity(0.2)),
            ),
          ),
          title: Text(
            editProfile,
            style: GoogleFonts.inter(
              // or sfPro if added
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: -0.2, // iOS-like tight spacing
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
          actions: [
            controller.isLoading.value
                ? lodingIndicator(circleColor: white)
                : TextButton(
                  onPressed: () async {
                    controller.isLoading(true);

                    final oldPass = controller.oldpassController.text.trim();
                    final newPass = controller.newpassController.text.trim();
                    final newName = controller.nameController.text.trim();
                    final currentPass = controller.snapshotData['password'];
                    final currentName = controller.snapshotData['vendor_name'];

                    bool isPasswordChangeRequested =
                        oldPass.isNotEmpty && newPass.isNotEmpty;
                    bool isNameChanged =
                        newName.isNotEmpty && newName != currentName;
                    bool isImageChanged =
                        controller.profileImageUrl.value.isNotEmpty &&
                        controller.profileImageUrl.value !=
                            controller.snapshotData['imageUrl'];

                    try {
                      if (isPasswordChangeRequested) {
                        if (oldPass == currentPass) {
                          await controller.changeAuthPassword(
                            email: controller.snapshotData['email'],
                            password: oldPass,
                            newpassword: newPass,
                          );

                          await controller.updateProfile(
                            imageUrl:
                                isImageChanged
                                    ? controller.profileImageUrl.value
                                    : controller.snapshotData['imageUrl'],
                            name: isNameChanged ? newName : currentName,
                            password: newPass,
                          );

                          VxToast.show(
                            context,
                            msg: "Password and profile updated",
                          );
                        } else {
                          VxToast.show(
                            context,
                            msg: "Old password is incorrect",
                          );
                        }
                      } else if (isNameChanged || isImageChanged) {
                        await controller.updateProfile(
                          imageUrl:
                              isImageChanged
                                  ? controller.profileImageUrl.value
                                  : controller.snapshotData['imageUrl'],
                          name: isNameChanged ? newName : currentName,
                          password: currentPass,
                        );
                        VxToast.show(context, msg: "Profile updated");
                      } else {
                        VxToast.show(context, msg: "Nothing to update");
                      }
                    } catch (e) {
                      VxToast.show(context, msg: "Error: $e");
                    } finally {
                      controller.isLoading(false);
                    }
                  },

                  child: normalText(text: save),
                ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
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
                  controller.updateProfilePicture(context);
                },
                child: normalText(text: changeImage, color: fontGrey),
              ),
              10.heightBox,

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
