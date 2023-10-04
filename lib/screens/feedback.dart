import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:street_wyze/models/message.dart';
import 'package:street_wyze/models/user.dart';
import 'package:street_wyze/providers/firebase_controller.dart';
import 'package:street_wyze/services/notification_service.dart';
import 'package:street_wyze/widgets/chat_screen.dart';

class UserFeedback extends StatefulWidget {
  const UserFeedback({super.key, required this.receiverId});
  final String receiverId;

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  TextEditingController feedback = TextEditingController();
  final notificationService = NotificationsService();

  String feedbackStatus =
      "Thank you for giving us your honest feedback about our app we will work to improve everything";
  String userMsg = "";
  bool hasRespondend = false;

  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false)
        .getMessages(widget.receiverId);
    notificationService.getReceiverToken(widget.receiverId);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    feedback.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    StreetWyzeUser? user = Provider.of<StreetWyzeUser?>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.green,
            )),
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            "USER FEEDBACK",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
          ),
        ),
        actions: const [
          Icon(
            Icons.message_outlined,
            color: Colors.green,
          ),
          SizedBox(
            width: 16,
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
        padding: const EdgeInsets.only(bottom: 12),
        width: width,
        height: height * 0.95,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/chat.jpg"),
            fit: BoxFit.fitHeight,
            opacity: 0.03,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: const Color.fromARGB(47, 9, 175, 31),
          ),
        ),
        child: Column(
          children: [
            ChatMessages(receiverId: widget.receiverId),
            Container(
              alignment: Alignment.center,
              width: width * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 1,
                  color: const Color.fromARGB(255, 83, 185, 78),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextField(
                      onTap: () {},
                      minLines: 1,
                      maxLines: 6,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(fontSize: 14),
                      controller: feedback,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (feedback.text.isNotEmpty) {
                        await context.read<FirebaseProvider>().addTextMessage(
                            Message(
                                content: feedback.text,
                                sentTime: DateTime.now(),
                                messageType: MessageType.text,
                                senderId:
                                    FirebaseAuth.instance.currentUser!.uid,
                                receiverId: widget.receiverId,
                                adminId: ""));
                        await notificationService.sendNotification(
                          body: feedback.text,
                          senderId: FirebaseAuth.instance.currentUser!.uid,
                        );
                        feedback.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
