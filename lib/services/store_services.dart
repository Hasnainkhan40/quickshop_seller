import 'package:quickshop_seller/const/const.dart';

class StoreServices {
  static getProfile(uid) {
    return firebaseFirestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: uid)
        .get();
  }

  static getMessage(uid) {
    return firebaseFirestore
        .collection(chatsCollction)
        .where('toId', isEqualTo: uid)
        .snapshots();
  }

  static getOrders(uid) {
    return firebaseFirestore
        .collection(ordersCollection)
        .where('vendors', arrayContains: uid)
        .snapshots();
  }
}
