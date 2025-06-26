import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

User? currentUser = auth.currentUser;

//collection
const vendorsCollection = "vendors";
const productsCollection = "products";
const chatsCollction = "chats";
const messageCollection = "messages";
const ordersCollection = "orders";
