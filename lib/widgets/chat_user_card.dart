import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messages/api/apis.dart';
import 'package:messages/helper/my_date_util.dart';
import 'package:messages/main.dart';
import 'package:messages/models/chat_user.dart';
import 'package:messages/models/message.dart';

import '../helper/custom_page_route.dart';
import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height * 0.12,
      child: Card(
        margin: EdgeInsets.symmetric(
            horizontal: mq.width * 0.02, vertical: mq.height * 0.005),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mq.width * 0.04)),
        // color: Colors.amber,
        elevation: 1,
        child: InkWell(
            onTap: () {
              Navigator.push(context,
                  CustomPageRoute(child: ChatScreen(user: widget.user)));
            },
            borderRadius: BorderRadius.circular(mq.width * 0.04),
            child: Center(
              child: StreamBuilder(
                  stream: APIs.getLastMessage(widget.user),
                  builder: (context, snapshot) {
                    final data = snapshot.data?.docs;
                    final list =
                        data?.map((e) => Message.fromJson(e.data())).toList() ??
                            [];
                    if (list.isNotEmpty) _message = list[0];
                    return ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: widget.user.image,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(CupertinoIcons.person),
                      ),
                      title: Text(widget.user.name),
                      subtitle: Text(
                          _message != null ? _message!.msg : widget.user.about,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      trailing: _message == null
                          ? null
                          : _message!.read.isEmpty &&
                                  _message!.fromId != APIs.user.uid
                              ? Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green[400],
                                  ),
                                )
                              : Text(
                                  MyDateUtil.getFormattedTime(
                                      context: context, time: _message!.sent),
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 15),
                                ),
                    );
                  }),
            )),
      ),
    );
  }
}
