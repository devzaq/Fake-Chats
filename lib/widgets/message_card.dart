import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messages/api/apis.dart';
import 'package:messages/main.dart';

import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return widget.message.fromId == APIs.user.uid
        ? _greenMessage()
        : _greyMessage();
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(width: 15,),
            const Icon(Icons.done_all_rounded,color: Colors.blue,size: 20,),
            const SizedBox(width: 4,),
            Text(
              widget.message.sent,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: Color.fromARGB(66, 37, 211, 101), width: 2),
              color: const Color.fromRGBO(220, 248, 198, 1),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            padding: EdgeInsets.symmetric(horizontal: mq.width * .03,vertical: mq.width*0.02),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  Widget _greyMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(82, 236, 229, 221),
              border: Border.all(
                  color: const Color.fromRGBO(236, 229, 221, 1), width: 2),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
           padding: EdgeInsets.symmetric(horizontal: mq.width * .03,vertical: mq.width*0.02),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Text(
            widget.message.sent,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
