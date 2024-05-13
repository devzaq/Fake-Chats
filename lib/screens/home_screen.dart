import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messages/api/apis.dart';
import 'package:messages/main.dart';
import 'package:messages/models/chat_user.dart';
import 'package:messages/screens/profile_screen.dart';
import 'package:messages/widgets/chat_user_card.dart';

import '../helper/custom_page_route.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          if (_isSearching) {
            setState(() {
              _isSearching = false;
            });
          } else {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: _isSearching
                ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextField(
                      autofocus: true,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          size: 20,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        hintText: 'eg. Peter Griffins',
                      ),
                      onChanged: (value) {
                        _searchList.clear();
                        for (var i in _list) {
                          if ((i.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  i.email
                                      .toLowerCase()
                                      .contains(value.toLowerCase())) &&
                              true) {
                            _searchList.add(i);
                            log(_searchList.toString());
                            setState(() {
                              _searchList;
                            });
                          }
                        }
                      },
                    ),
                  )
                : const Text(
                    'Messages',
                    style: TextStyle(letterSpacing: .5, fontSize: 25),
                  ),
            leading: _isSearching
                ? null
                : const Icon(
                    CupertinoIcons.bolt_horizontal_circle,
                    size: 30,
                    color: Colors.blue,
                  ),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(
                    _isSearching ? CupertinoIcons.clear : Icons.search,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  )),
              Visibility(
                visible: !_isSearching,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          CustomPageRoute(child: ProfileScreen(user: APIs.me)));
                    },
                    icon: const Icon(
                      CupertinoIcons.ellipsis_vertical,
                      size: 18,
                    )),
              ),
              Visibility(
                visible: _isSearching,
                child: const SizedBox(
                  width: 20,
                ),
              )
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: FloatingActionButton(
              onPressed: () async {
                Navigator.push(context,
                    CustomPageRoute(child: ProfileScreen(user: APIs.me)));
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.background,
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
                    _list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];
                    if (_list.isEmpty) {
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
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        padding:
                            EdgeInsets.only(top: 10, bottom: mq.height * 0.1),
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                              user: _isSearching
                                  ? _searchList[index]
                                  : _list[index]);
                          // return Text('Name: ${list[index].name}');
                        });
                }
              }),
        ),
      ),
    );
  }
}
