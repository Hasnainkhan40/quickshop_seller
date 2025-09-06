// import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:quickshop_seller/const/colors.dart';
// import 'package:quickshop_seller/const/const.dart';
// import 'package:quickshop_seller/const/images.dart';
// import 'package:quickshop_seller/const/loading_indicator.dart';
// import 'package:quickshop_seller/controller/auth_controller.dart';
// import 'package:quickshop_seller/controller/profile_controller.dart';
// import 'package:quickshop_seller/services/store_services.dart';
// import 'package:quickshop_seller/views/auth_screen/login_screen.dart';
// import 'package:quickshop_seller/views/messages_screen.dart/messages_screen.dart';
// import 'package:quickshop_seller/views/profile_screen/edit_profilescreen.dart';
// import 'package:quickshop_seller/views/shop_screen/shop_setting_screen.dart';
// import 'package:quickshop_seller/views/widgets/text_style.dart';
// import 'package:velocity_x/velocity_x.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(ProfileController());
//     return Scaffold(
//       backgroundColor: purpleColor,
//       appBar: AppBar(
//         backgroundColor: Colors.white.withOpacity(0.6), // translucent
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         flexibleSpace: ClipRRect(
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // iOS blur effect
//             child: Container(color: Colors.white.withOpacity(0.2)),
//           ),
//         ),
//         title: Text(
//           settings,
//           style: GoogleFonts.inter(
//             // or sfPro if added
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//             letterSpacing: -0.2, // iOS-like tight spacing
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: Icon(Icons.arrow_back, color: white),
//         ),

//         actions: [
//           IconButton(
//             onPressed: () {
//               Get.to(
//                 () => EditProfilescreen(
//                   username: controller.snapshotData['vendor_name'],
//                 ),
//               );
//             },
//             icon: Icon(Icons.edit, color: lightGrey),
//           ),
//           TextButton(
//             onPressed: () async {
//               await Get.find<AuthControler>().signoutMethod(context);
//               Get.offAll(() => const LoginScreen());
//             },
//             child: normalText(text: logout),
//           ),
//         ],
//       ),

//       body: FutureBuilder(
//         future: StoreServices.getProfile(currentUser!.uid),

//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           print("Current UID: ${currentUser!.uid}");
//           if (!snapshot.hasData) {
//             return lodingIndicator(circleColor: white);
//           } else if (snapshot.data!.docs.isEmpty) {
//             return Center(child: normalText(text: 'No profile data found.'));
//           } else {
//             controller.snapshotData = snapshot.data!.docs[0];

//             return Container(
//               height: 250,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF0C4226), // dark green
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ListTile(
//                     leading:
//                         controller.snapshotData['imageUrl'] != null &&
//                                 controller.snapshotData['imageUrl'] != ''
//                             ? Image.network(
//                               controller.snapshotData['imageUrl'],
//                               width: 50,
//                               height: 50,
//                               fit: BoxFit.cover,
//                             ).box.roundedFull.clip(Clip.antiAlias).make()
//                             : Image.asset(
//                               imgProduct,
//                               width: 50,
//                               height: 50,
//                             ).box.roundedFull.clip(Clip.antiAlias).make(),
//                     title: boldText(
//                       text: "${controller.snapshotData['vendor_name']}",
//                     ),
//                     subtitle: normalText(
//                       text: "${controller.snapshotData['email']}",
//                     ),
//                   ),
//                   const Divider(),
//                   10.heightBox,
//                   Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Column(
//                       children: List.generate(
//                         proflileButtonTitles.length,
//                         (index) => ListTile(
//                           onTap: () {
//                             switch (index) {
//                               case 0:
//                                 Get.to(() => ShopSetting());
//                                 break;
//                               case 1:
//                                 Get.to(() => MessagesScreen());
//                                 break;
//                               default:
//                             }
//                           },
//                           leading: Icon(
//                             proflileButtonIcons[index],
//                             color: white,
//                           ),
//                           title: normalText(text: proflileButtonTitles[index]),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: StoreServices.getProfile(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: lodingIndicator(circleColor: purpleColor));
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No profile data found.'));
          } else {
            controller.snapshotData = snapshot.data!.docs[0];

            final String imageUrl = controller.snapshotData['imageUrl'] ?? '';
            final String vendorName =
                controller.snapshotData['vendor_name'] ?? '';
            final String email = controller.snapshotData['email'] ?? '';

            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ), // gradient background
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : const AssetImage(imgProduct)
                                      as ImageProvider,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          vendorName,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Account Overview + Actions
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account Overview",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // White card
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildProfileTile(
                                  icon: Icons.storefront_outlined,
                                  iconColor: Colors.blueAccent,
                                  title: "Shop Settings",
                                  onTap:
                                      () => Get.to(() => const ShopSetting()),
                                ),

                                _buildProfileTile(
                                  icon: Icons.chat_bubble_outline,
                                  iconColor: Colors.green,
                                  title: "Messages",
                                  onTap:
                                      () =>
                                          Get.to(() => const MessagesScreen()),
                                ),
                                _buildProfileTile(
                                  icon: Icons.edit_note_outlined,
                                  iconColor: Colors.cyanAccent,
                                  title: "Edit Profile",
                                  onTap: () {
                                    Get.to(
                                      () => EditProfilescreen(
                                        username: vendorName,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Action buttons
                          Row(
                            children: [
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Logout",
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () async {
                                    await Get.find<AuthControler>()
                                        .signoutMethod(context);
                                    Get.offAll(() => const LoginScreen());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
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

  // Helper for clean tiles
  Widget _buildProfileTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
    );
  }
}
