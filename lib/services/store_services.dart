import 'package:quickshop_seller/const/const.dart';

class StoreServices {
  static getProfile(uid) {
    
    return firebaseFirestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: uid)
        .get(); 
            
  }
}
