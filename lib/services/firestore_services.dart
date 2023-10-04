// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:street_wyze/models/feedback.dart';
// import 'package:street_wyze/models/firebase_users.dart';
// import 'package:street_wyze/models/message.dart';

// class FirestoreService {
//   final db = FirebaseFirestore.instance;

 

//   // static Future<void> addImageMessage({
//   //   required String receiverId,
//   //   required Uint8List file,
//   // }) async {
//   //   final image = await FirebaseStorageService.uploadImage(
//   //       file, 'image/chat/${DateTime.now()}');

//   //   final message = Message(
//   //     content: image,
//   //     sentTime: DateTime.now(),
//   //     receiverId: receiverId,
//   //     messageType: MessageType.image,
//   //     senderId: FirebaseAuth.instance.currentUser!.uid,
//   //   );
//   //   await _addMessageToChat(receiverId, message);
//   // }

  

//   // Future<FirestoreUser?> getUser(uuid) async {
//   //   final ref = db.collection("Users").doc(uuid).withConverter(
//   //         fromFirestore: FirestoreUser.fromFirestore,
//   //         toFirestore: (FirestoreUser firestoreUser, _) =>
//   //             firestoreUser.toFirestore(),
//   //       );
//   //   final docSnap = await ref.get();
//   //   final firestoreUser = docSnap.data(); // Convert to firestoreUser object
//   //   if (firestoreUser != null) {
//   //     print(firestoreUser);
//   //     return firestoreUser;
//   //   } else {
//   //     print("No such document.");
//   //     return null;
//   //   }
//   // }

//   String addFeedback(UxFeedback uxFeedback) {
//     String reply = "";
//     db.collection("Feedback").doc().set(uxFeedback.toJson()).whenComplete(() =>
//         reply =
//             "Thank you for giving us your honest feedback about our app we will work to improve everything");
//     return reply;
//   }
// }
