
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String message;
  String senderId;
  String receiverId;
  String senderEmail;
  Timestamp time;

  ChatMessage({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.senderEmail,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "senderId": senderId,
      "receiverId": receiverId,
      "senderEmail": senderEmail,
      "time": time
    };
  }
}
