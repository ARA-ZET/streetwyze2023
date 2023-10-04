import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:street_wyze/providers/firebase_controller.dart';
import 'package:intl/intl.dart';

import '../models/message.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({Key? key, required this.receiverId}) : super(key: key);
  final String receiverId;
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'TODAY';
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return 'YESTERDAY';
    } else if (difference.inDays < 7) {
      final dayOfWeek = DateFormat('EEEE').format(dateTime);
      return dayOfWeek;
    } else {
      final formatter = DateFormat('MMM dd, yyyy');
      return formatter.format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<FirebaseProvider>(
      builder: (context, value, child) {
        final messages = value.messages;
        return messages.isEmpty
            ? Expanded(
                child: Container(
                  child: const Icon(Icons.waving_hand),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  controller:
                      Provider.of<FirebaseProvider>(context, listen: false)
                          .scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isTextMessage =
                        message.messageType == MessageType.text;
                    final isMe = receiverId != message.senderId;
                    final previousMessage =
                        index > 0 ? messages[index - 1] : null;
                    final showDateSeparator = previousMessage == null ||
                        !isSameDate(message.sentTime, previousMessage.sentTime);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (showDateSeparator)
                          Wrap(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 160, 175, 183),
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                margin: EdgeInsets.all(8),
                                child: Text(
                                  formatDate(message
                                      .sentTime), // Format date as needed
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        isTextMessage
                            ? Wrap(
                                children: [
                                  isMe
                                      ? Container(
                                          width: width,
                                          margin: const EdgeInsets.only(
                                              right: 8, left: 42, bottom: 8),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.green,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Wrap(
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                message.content,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('HH:mm')
                                                    .format(message.sentTime),
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          width: width,
                                          margin: const EdgeInsets.only(
                                              right: 42, left: 8, bottom: 8),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 246, 255, 246),
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.green,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Wrap(
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                message.content,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('HH:mm')
                                                    .format(message.sentTime),
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                ],
                              )
                            : Container(),
                      ],
                    );
                  },
                ),
              );
      },
    );
  }
}
