import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble({super.key, required this.message, required this.isCurrentUser});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 6),
      margin: widget.isCurrentUser? EdgeInsets.fromLTRB(90, 2, 8, 2) : EdgeInsets.fromLTRB(8, 2, 90, 2),
      decoration: BoxDecoration(
        color: widget.isCurrentUser? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(widget.message),
    );
  }
}
