import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickshop_seller/const/const.dart';

class ProfileController extends GetxController {
  late QueryDocumentSnapshot snapshotData;
  var profileImagePath = ''.obs;

  var isLoading = false.obs;

  //textFiled
  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  changeImage(context) async {
    try {
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (img == null) return;
      profileImagePath.value = img.path;
    } on PlatformException catch (e) {
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
}
