import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickshop_seller/const/api.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:dio/dio.dart' as dio;
import 'package:quickshop_seller/const/keys.dart';

class ProfileController extends GetxController {
  late QueryDocumentSnapshot snapshotData;

  var profileImagePath = ''.obs; // local file path
  var profileImageUrl = ''.obs; // uploaded image URL

  var isLoading = false.obs;

  //textFiled
  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  //shop cantroller
  var shopNameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopMobileController = TextEditingController();
  var shopWebsiteController = TextEditingController();
  var shopDescController = TextEditingController();

  // changeImage(context) async {
  //   try {
  //     final img = await ImagePicker().pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 70,
  //     );
  //     if (img == null) return;
  //     profileImagePath.value = img.path;
  //   } on PlatformException catch (e) {
  //     VxToast.show(context, msg: e.toString());
  //   }
  // }
  Future<dio.Response> uploadImage(File image) async {
    try {
      // Construct the Cloudinary API endpoint
      String api = UApiUrls.uploadApi(UKeys.cloudName);

      final fileName = image.path.split('/').last;

      final formData = dio.FormData.fromMap({
        'upload_preset': UKeys.uploadPreset,
        'folder': UKeys.profileFolder,
        'file': await dio.MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
      });

      final dioInstance = dio.Dio();

      // Optional: Logging interceptor for debugging
      dioInstance.interceptors.add(
        dio.LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );

      final response = await dioInstance.post(api, data: formData);

      // Optional: Check for success response
      if (response.statusCode == 200) {
        return response;
      } else {
        throw 'Cloudinary upload failed with status code: ${response.statusCode}';
      }
    } catch (e) {
      debugPrint('❌ Upload Image Error: $e');
      rethrow; // Propagate error to calling function
    }
  }

  Future<void> updateProfilePicture(context) async {
    try {
      // Pick Image from Gallery
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
      );
      if (image == null) return;

      // Optionally save local path for display (not used in Firestore)
      profileImagePath.value = image.path;

      // Upload Image to Cloudinary
      File file = File(image.path);
      dio.Response response = await uploadImage(file);

      if (response.statusCode == 200) {
        final data = response.data;

        // Save secure network URL
        profileImageUrl.value = data['secure_url'] ?? '';
        // Correct print

        if (profileImageUrl.value.isEmpty) {
          throw 'Image upload did not return a valid URL.';
        }

        // NOW update Firestore with new image URL!
        await updateProfile(
          imageUrl: profileImageUrl.value,
          name: nameController.text,
          password: oldpassController.text,
        );

        VxToast.show(context, msg: "Profile picture updated successfully!");
      } else {
        throw 'Failed to upload profile picture. Please try again.';
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  updateProfile({name, password, imageUrl}) async {
    var store = firebaseFirestore
        .collection(vendorsCollection)
        .doc(currentUser!.uid);
    await store.set({
      'vendor_name': name,
      'password': password,
      'imageUrl': imageUrl,
    }, SetOptions(merge: true));
    isLoading(false);
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!
        .reauthenticateWithCredential(cred)
        .then((value) {
          currentUser!.updatePassword(newpassword);
        })
        .catchError((error) {});
  }

  updateShop({shopname, shopaddress, shopmobile, shopwebsite, shopdesc}) async {
    var store = firebaseFirestore
        .collection(vendorsCollection)
        .doc(currentUser!.uid);
    await store.set({
      'shop_name': shopname,
      'shop_address': shopaddress,
      'shop_mobile': shopmobile,
      'shop_website': shopwebsite,
      'shop_desc': shopdesc,
    }, SetOptions(merge: true));
    isLoading(false);
  }
}
