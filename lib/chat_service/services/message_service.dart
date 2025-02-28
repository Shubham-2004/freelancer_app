import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_app/chat_service/models/chat_message.dart';

class MessageService extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;

  // sending the message
  Future<void> sendMessage(String receiverId, String message) async {
    final Timestamp timestamp = Timestamp.now();
    final currentUserId = auth.currentUser!.uid;
    final currentUserEmail = auth.currentUser!.email;

    List<String> chatId = [currentUserId, receiverId];
    chatId.sort();

    await store
        .collection("chat")
        .doc(chatId.join("*"))
        .collection("messages")
        .add(
          ChatMessage(
            message: message,
            senderId: currentUserId,
            receiverId: receiverId,
            senderEmail: currentUserEmail!,
            time: timestamp,
          ).toMap(),
        );
  }

  // receiving the message

  Stream<QuerySnapshot> getMessage(
    String currentUserId,
    String receiverUserId,
  ) {
    List<String> chatId = [currentUserId, receiverUserId];
    chatId.sort();

    return store
        .collection("chat")
        .doc(chatId.join("*"))
        .collection("messages")
        .orderBy("time", descending: false)
        .snapshots();
  }
}
