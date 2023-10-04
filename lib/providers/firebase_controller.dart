import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:street_wyze/models/firebase_users.dart';
import 'package:street_wyze/models/message.dart';

class FirebaseProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  FirebaseUser? currentUsser;
  FirebaseUser? user;
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Message> _messages = [];
  List<FirebaseUser> search = [];
  List<Message> get messages => _messages;

  FirebaseUser? getUserById(String userId) {
    db
        .collection('Users')
        .doc(userId)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      this.user = FirebaseUser.fromJson(user.data()!);
      notifyListeners();
    });
    return user;
  }

  createUser(FirebaseUser firebaseUser) {
    db
        .collection("Users")
        .doc(firebaseUser.uid)
        .set(firebaseUser.toJson())
        .whenComplete(() => debugPrint("user created ${firebaseUser.uid}"));
  }

  Future addTextMessage(Message message) async {
    await _addMessageToChat("MO8KcaC1kZRNKH8lDPnQHbZ3il13", message);
  }

  Future<void> _addMessageToChat(
    String receiverId,
    Message message,
  ) async {
    await db
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    await db
        .collection('Users')
        .doc(receiverId)
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .add(message.toJson());
  }

  getCurrentUser(uid) {}

  List<Message> getMessages(String receiverId) {
    db
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      _messages =
          messages.docs.map((doc) => Message.fromJson(doc.data())).toList();
      notifyListeners();

      scrollDown();
    });
    return _messages;
  }

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
}
