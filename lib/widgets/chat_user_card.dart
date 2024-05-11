import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messages/helper/custom_page_route.dart';
import 'package:messages/main.dart';
import 'package:messages/models/chat_user.dart';

import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
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
              Navigator.push(context, CustomPageRoute(child: ChatScreen(user: widget.user)));
            },
            borderRadius: BorderRadius.circular(mq.width * 0.04),
            child: Center(
              child: ListTile(
                leading: CachedNetworkImage(
                  imageUrl: widget.user.image!,
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
                title: Text(widget.user.name ?? ""),
                subtitle: Text(widget.user.about ?? "",
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green[400],
                  ),
                ),
                // trailing: const Text(
                //   "15:00",
                //   style: TextStyle(color: Colors.black54,fontSize: 15),
                // ),
              ),
            )),
      ),
    );
  }
}





// leading: ClipRRect(
//                   borderRadius: BorderRadius.circular(mq.height*08/2),
//                   child: CachedNetworkImage(
//                     fit: BoxFit.fill,
//                     height: mq.height * 0.08,
//                     width: mq.height * 0.08,
//                     imageUrl: widget.user.image!,
//                     placeholder: (context, url) =>
//                         const CircularProgressIndicator(),
//                     errorWidget: (context, url, error) => CircleAvatar(
//                       radius: mq.width * 0.08,
//                       child: const Icon(CupertinoIcons.person),
//                       // child: widget.user.image,
//                     ),
//                   ),
//                 ),