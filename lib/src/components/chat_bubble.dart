import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  const ChatBubble({Key? key, required this.message, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: (isMe) ? Colors.blueGrey[700] : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              )),
          width: 145,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message,
            style: TextStyle(color: (isMe) ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}
