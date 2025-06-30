import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/controller/home_controller.dart';
import 'package:quickshop_seller/models/category_model.dart';
import 'package:path/path.dart';

class ProductController extends GetxController {
  var isloading = false.obs;
  //text filed controllers

  var pnameController = TextEditingController();
  var pdescController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();

  var categoryList = <String>[].obs;
  var subcategoryList = <String>[].obs;
  List<Category> category = [];
  var pImagesLinks = [];
  var pImagesList = RxList<dynamic>.generate(3, (index) => null);

  var categoryvalue = ''.obs;
  var subcategoryvalue = ''.obs;
  var selectedColorIndex = 0.obs;

  getCategories() async {
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var cat = categoryModelFromJson(data);
    category = cat.categories;
  }

  populateCategoryList() {
    categoryList.clear();

    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  populateSubcategory(cat) {
    subcategoryList.clear();
    var data = category.where((element) => element.name == cat).toList();

    for (var i = 0; i < data.first.subcategory.length; i++) {
      subcategoryList.add(data.first.subcategory[i]);
    }
  }

  pickImage(index, context) async {
    try {
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (img == null) {
        return;
      } else {
        pImagesList[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadImages() async {
    pImagesLinks.clear();

    // Optional: remove null or invalid files
    pImagesList.removeWhere((file) => file == null || !file.existsSync());

    for (var i = 0; i < pImagesList.length; i++) {
      var item = pImagesList[i];

      if (item != null && await item.exists()) {
        final size = await item.length();

        if (size == 0) {
          debugPrint("❌ Skipping file at index $i: File is empty.");
          continue;
        }

        try {
          final filename = basename(item.path);
          final safeFilename =
              '${DateTime.now().millisecondsSinceEpoch}_$filename';
          final destination =
              'images/vendors/${currentUser!.uid}/$safeFilename';

          debugPrint("✅ Uploading: ${item.path} to $destination");

          Reference ref = FirebaseStorage.instance.ref().child(destination);
          UploadTask uploadTask = ref.putFile(item);
          TaskSnapshot snapshot = await uploadTask;

          final downloadUrl = await snapshot.ref.getDownloadURL();
          pImagesLinks.add(downloadUrl);

          debugPrint("✅ Uploaded: $downloadUrl");
        } catch (e) {
          debugPrint("❌ Error uploading file at index $i: $e");
        }
      } else {
        debugPrint("❌ File at index $i is null or does not exist: $item");
      }
    }

    debugPrint("✅ Uploaded ${pImagesLinks.length} image(s).");
  }

  // uploadImages() async {
  //   pImagesLinks.clear();
  //   for (var item in pImagesList) {
  //     if (item != null) {
  //       var filename = basename(item.path);
  //       var destination = 'images/vendors/${currentUser!.uid}/$filename';
  //       Reference ref = FirebaseStorage.instance.ref().child(destination);
  //       await ref.putFile(item);
  //       var n = await ref.getDownloadURL();
  //       pImagesLinks.add(n);
  //     }
  //   }
  // }

  uploadProduct(context) async {
    var store = firebaseFirestore.collection(productsCollection).doc();
    await store.set({
      'is_featured': false,
      'P_category': categoryvalue.value,
      'P_subcategory': categoryvalue.value,
      'P_colors': FieldValue.arrayUnion([Colors.red.value, Colors.brown.value]),
      'P_imgs': FieldValue.arrayUnion(pImagesLinks),
      'P_wishlist': FieldValue.arrayUnion([]),
      'P_desc': pdescController.text,
      'P_name': pnameController.text,
      'P_price': ppriceController.text,
      'P_quantity': pquantityController.text,
      'P_seller': Get.find<HomeController>().username,
      'P_reting': "5.0",
      'vendor_id': currentUser!.uid,
      'featured_id': '',
    });
    isloading(false);
    VxToast.show(context, msg: "Product uploaded");
  }

  addFeatured(docId) async {
    await firebaseFirestore.collection(productsCollection).doc(docId).set({
      'featured_id': currentUser!.uid,
      'is_featured': true,
    }, SetOptions(merge: true));
  }

  removeFeatured(docId) async {
    await firebaseFirestore.collection(productsCollection).doc(docId).set({
      'featured_id': '',
      'is_featured': false,
    }, SetOptions(merge: true));
  }

  removeProduct(docId) async {
    await firebaseFirestore.collection(productsCollection).doc(docId).delete();
  }
}
