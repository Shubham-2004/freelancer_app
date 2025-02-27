import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_app/chat_service/components/message_bubble.dart';
import 'package:freelancer_app/chat_service/services/ai_service.dart';
import 'package:freelancer_app/chat_service/services/message_service.dart';

class ChatScreen extends StatefulWidget {
  final String? receiverEmail;
  final String? recierverId;

  const ChatScreen({
    super.key,
    required this.receiverEmail,
    required this.recierverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController message = TextEditingController();
  final ScrollController scroll = ScrollController();
  final MessageService messageService = MessageService();
  final FirebaseAuth authenticate = FirebaseAuth.instance;
  List<String> suggestions = [];
  bool showSuggestions = false;

  String getFriendName() {
    return widget.receiverEmail!.split("@")[0][0].toUpperCase() +
        widget.receiverEmail!.split("@")[0].substring(1);
  }

  void scrollToBottom() {
    if (scroll.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scroll.jumpTo(scroll.position.maxScrollExtent);
      });
    }
  }

  void sendMessage() async {
    String text = message.text.trim();

    // Check if AI model is mentioned
    if (text.contains("@")) {
      // Call AI Model API
      setState(() {
        showSuggestions = false;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        },
      );

      String aiResponse = await getAIResponse(text);

      Navigator.of(context).pop();

      // Send AI response to receiver
      await messageService.sendMessage(widget.recierverId!, aiResponse);
    } else {
      // Normal message sending
      await messageService.sendMessage(widget.recierverId!, text);
    }

    message.clear();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getFriendName(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
      ),
      body: Stack(
        children: [
          //messages
          StreamBuilder(
            stream: messageService.getMessage(
              authenticate.currentUser!.uid,
              widget.recierverId!,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Error fetching the messages',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }
              if (scroll.hasClients) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => scrollToBottom(),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 85),
                  controller: scroll,
                  children:
                      snapshot.data!.docs.map((document) {
                        final Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        debugPrint(data["message"]);
                        return MessageBubble(
                          message: data["message"],
                          userName:
                              data['senderEmail'].toString().split("@")[0],
                          alignment:
                              data['senderId'] == authenticate.currentUser!.uid
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          timestamp: data["time"],
                        );
                      }).toList(),
                ),
              );
            },
          ),

          Positioned(
            bottom: 80,
            left: 10,
            right: 10,
            child:
                showSuggestions
                    ? Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children:
                            suggestions.map((model) {
                              return ListTile(
                                title: Text(model),
                                onTap: () {
                                  setState(() {
                                    message.text =
                                        "${message.text.split("@").first}@$model ";
                                    showSuggestions = false;
                                  });
                                },
                              );
                            }).toList(),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),

          //sned message button
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13.0,
                  vertical: 15,
                ),
                child: TextField(
                  // onChanged: (value) => onMessageChanged(value),
                  controller: message,
                  decoration: InputDecoration(
                    hintText: "Enter your message",
                    suffixIcon: IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: const Icon(Icons.send),
                      color: Colors.black,
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
