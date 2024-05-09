import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messages/api/apis.dart';
import 'package:messages/helper/dialogs.dart';
import 'package:messages/main.dart';
import 'package:messages/models/chat_user.dart';
import 'package:messages/screens/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(letterSpacing: .5, fontSize: 25),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * 0.03,
                  ),
                  Stack(
                    children: [
                      CachedNetworkImage(
                        // alignment: Alignment.center,
                        imageUrl: widget.user.image!,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 175.0,
                          height: 175.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fill),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(CupertinoIcons.person),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 0,
                        child: MaterialButton(
                          onPressed: () {},
                          elevation: 1,
                          minWidth: 20,
                          height: 40,
                          shape: const CircleBorder(),
                          color: Theme.of(context).colorScheme.primary,
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: mq.height * 0.03,
                  ),
                  Text(
                    widget.user.email!,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      hintText: 'eg. Peter Griffins',
                      label: const Text("Name"),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.02,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      hintText: 'eg. I\'m feeling lucky',
                      label: const Text("About"),
                    ),
                  ),
                  SizedBox(height: mq.height * 0.05),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: Size(mq.width * 0.4, mq.height * 0.06)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() {});
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showSnackbar(
                              context, "Profile updated successfully.");
                        });
                        log('inside validator');
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text(
                      "UPDATE",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: Visibility(
            visible: !showFab,
            maintainAnimation: true,
            maintainState: true,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              opacity: !showFab ? 1 : 0,
              child: FloatingActionButton.extended(
                shape: const StadiumBorder(),
                label: const Text("Logout"),
                onPressed: () async {
                  Dialogs.showProgressbar(context);
                  await APIs.auth.signOut().then((value) async {
                    await GoogleSignIn().signOut().then((value) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()));
                    });
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                icon: const Icon(
                  Icons.logout,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
