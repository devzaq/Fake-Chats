import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messages/api/apis.dart';
import 'package:messages/main.dart';
import 'package:messages/models/chat_user.dart';
import 'package:messages/screens/auth/login_screen.dart';
import 'package:messages/screens/profile_screen.dart';
import 'package:messages/widgets/chat_user_card.dart';

import '../helper/custom_page_route.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(letterSpacing: .5, fontSize: 25),
        ),
        leading: const Icon(
          CupertinoIcons.bolt_horizontal_circle,
          size: 30,
          color: Colors.blue,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              )),
          IconButton(
              onPressed: () {
                log("List[0]: ${list[0]}");
                Navigator.push(
                    context,
                    CustomPageRoute(child: ProfileScreen(user: APIs.me)));
              },
              icon: const Icon(
                CupertinoIcons.ellipsis_vertical,
                size: 18,
              ))
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 20),
        child: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
                context,
                CustomPageRoute(
                    child: ProfileScreen(user: APIs.me)));
          },
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: APIs.getAllUsers(),
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
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];
                if (list.isEmpty) {
                  return const Center(
                      child: Text(
                    "No connections found!",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.justify,
                  ));
                }
                return ListView.builder(
                    itemCount: list.length,
                    padding: EdgeInsets.only(top: 10, bottom: mq.height * 0.1),
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemBuilder: (context, index) {
                      return ChatUserCard(user: list[index]);
                      // return Text('Name: ${list[index].name}');
                    });
            }
          }),
    );
  }
}
