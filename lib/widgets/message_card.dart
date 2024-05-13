import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messages/api/apis.dart';
import 'package:messages/helper/my_date_util.dart';
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
            const SizedBox(
              width: 15,
            ),
            (widget.message.read.isNotEmpty)
                ? const Icon(
                    Icons.done_all_rounded,
                    color: Colors.blue,
                    size: 20,
                  )
                : const Icon(
                    Icons.done,
                    color: Colors.grey,
                    size: 20,
                  ),
            const SizedBox(
              width: 4,
            ),
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromARGB(66, 37, 211, 101), width: 2),
              color: const Color.fromRGBO(220, 248, 198, 1),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14)),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .03, vertical: mq.width * 0.02),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.002),
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
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      log("Message Read Updated.🥲");
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(82, 236, 229, 221),
              border: Border.all(
                  color: const Color.fromRGBO(236, 229, 221, 1), width: 2),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14)),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .03, vertical: mq.width * 0.02),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.002),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
