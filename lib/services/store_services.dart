import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickshop_seller/const/const.dart';

class StoreServices {
  static getProfile(uid) {
    return firebaseFirestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: uid)
        .get();
  }

  static getChatMessages(docId) {
    return firebaseFirestore
        .collection(chatsCollction)
        .doc(docId)
        .collection(messageCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  // static Stream<QuerySnapshot> getMessagesForChat(String chatDocId) {
  //   try {
  //     return firebaseFirestore
  //         .collection(chatsCollction)
  //         .doc(chatDocId)
  //         .collection(messageCollection)
  //         .orderBy('created_on', descending: false)
  //         .snapshots();
  //   } catch (e) {
  //     print("Error getting messages: $e");
  //     rethrow;
  //   }
  // }

  // static Stream<QuerySnapshot> getChatsForUser(String uid) {
  //   return firebaseFirestore
  //       .collection(chatsCollction)
  //       .where('users', arrayContains: uid)
  //       .orderBy('created_on', descending: true)
  //       .snapshots();
  // }

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

  static getProduct(uid) {
    return firebaseFirestore
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }
}
