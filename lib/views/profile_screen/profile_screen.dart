import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/colors.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/images.dart';
import 'package:quickshop_seller/const/loading_indicator.dart';
import 'package:quickshop_seller/controller/auth_controller.dart';
import 'package:quickshop_seller/controller/profile_controller.dart';
import 'package:quickshop_seller/services/store_services.dart';
import 'package:quickshop_seller/views/auth_screen/login_screen.dart';
import 'package:quickshop_seller/views/messages_screen.dart/messages_screen.dart';
import 'package:quickshop_seller/views/profile_screen/edit_profilescreen.dart';
import 'package:quickshop_seller/views/shop_screen/shop_setting_screen.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: white),
        ),
        title: boldText(text: settings, size: 16.0),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => EditProfilescreen(
                  username: controller.snapshotData['vendor_name'],
                ),
              );
            },
            icon: Icon(Icons.edit, color: lightGrey),
          ),
          TextButton(
            onPressed: () async {
              await Get.find<AuthControler>().signoutMethod(context);
              Get.offAll(() => const LoginScreen());
            },
            child: normalText(text: logout),
          ),
        ],
      ),

      body: FutureBuilder(
        future: StoreServices.getProfile(currentUser!.uid),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print("Current UID: ${currentUser!.uid}");
          if (!snapshot.hasData) {
            return lodingIndicator(circleColor: white);
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(child: normalText(text: 'No profile data found.'));
          } else {
            controller.snapshotData = snapshot.data!.docs[0];

            return Column(
              children: [
                ListTile(
                  leading:
                      controller.snapshotData['imageUrl'] != null &&
                              controller.snapshotData['imageUrl'] != ''
                          ? Image.network(
                            controller.snapshotData['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make()
                          : Image.asset(
                            imgProduct,
                            width: 50,
                            height: 50,
                          ).box.roundedFull.clip(Clip.antiAlias).make(),
                  title: boldText(
                    text: "${controller.snapshotData['vendor_name']}",
                  ),
                  subtitle: normalText(
                    text: "${controller.snapshotData['email']}",
                  ),
                ),
                const Divider(),
                10.heightBox,
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: List.generate(
                      proflileButtonTitles.length,
                      (index) => ListTile(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Get.to(() => ShopSetting());
                              break;
                            case 1:
                              Get.to(() => MessagesScreen());
                              break;
                            default:
                          }
                        },
                        leading: Icon(proflileButtonIcons[index], color: white),
                        title: normalText(text: proflileButtonTitles[index]),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
