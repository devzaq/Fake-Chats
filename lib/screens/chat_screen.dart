import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messages/api/apis.dart';
import 'package:messages/main.dart';
import 'package:messages/models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appbar(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: APIs.getAllMessages(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        log("Message:  ${jsonEncode(data![0].data())}");
                        // _list = data ?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                        final _list = [];
                        if (_list.isEmpty) {
                          return Center(
                              child: Text(
                            "Say Hi 👋 to ${widget.user.name}.",
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.justify,
                          ));
                        }
                        return ListView.builder(
                            itemCount: _list.length,
                            padding: EdgeInsets.only(
                                top: 10, bottom: mq.height * 0.1),
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemBuilder: (context, index) {
                              return Text('Message : ${_list[index]}');
                            });
                    }
                  }),
            ),
            _chatInput()
          ],
        ),
      ),
    );
  }

  Widget _appbar() {
    return SafeArea(
      child: Center(
        child: Row(
          children: [
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.user.image!,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      CupertinoIcons.person_alt_circle,
                      size: 40,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name ?? "",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        "Last seen unavailable",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Container(
      alignment: Alignment.center,
      // width: mq.width*0.95,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      // color: Colors.amber,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueGrey,
                        size: 26,
                      )),
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 6,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0),
                        border: InputBorder.none,
                        hintText: "Message...",
                        hintStyle: TextStyle(
                          color: Colors.blueGrey.shade300,
                        )),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blueGrey,
                        size: 26,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.blueGrey,
                        size: 26,
                      )),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {},
            padding: const EdgeInsets.all(10),
            minWidth: 0,
            color: Theme.of(context).colorScheme.secondary,
            shape: const CircleBorder(),
            child: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.background,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}