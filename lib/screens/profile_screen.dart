import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
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
  String? _image;
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
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                File(_image!),
                                width: 175.0,
                                height: 175.0,
                                fit: BoxFit.cover,
                              ),
                            )
                          : CachedNetworkImage(
                              // alignment: Alignment.center,
                              imageUrl: widget.user.image!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 175.0,
                                height: 175.0,
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
                      Positioned(
                        bottom: 5,
                        right: 0,
                        child: MaterialButton(
                          onPressed: () {
                            _showBottomSheet();
                          },
                          elevation: 1,
                          minWidth: 0,
                          height: 45,
                          shape: const CircleBorder(),
                          color: Theme.of(context).colorScheme.primary,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 25,
                            color: Theme.of(context).colorScheme.background,
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
                label: Text(
                  "Logout",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                ),
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
                icon: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (builder) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: mq.height * 0.03, bottom: mq.height * 0.08),
            children: [
              const Text(
                "Pick profile picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: mq.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.white,
                              fixedSize: const Size(100, 100)),
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            // Pick an image.
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              setState(() {
                                _image = image.path;
                              }); 
                              log('Image Path: ${image.path} --mimetype: ${image.mimeType}');
                              if (!mounted) return;
                              Navigator.pop(context);
                            }
                          },
                          child: Image.asset('images/image-gallery.png')),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Gallery",
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.white,
                              fixedSize: const Size(100, 100)),
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            // Pick an image.
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.camera);
                            if (image != null) {
                              setState(() {
                                _image = image.path;
                              }); 
                              log('Image Path: ${image.path}');
                              if (!mounted) return;
                              Navigator.pop(context);
                            }
                          },
                          child: Image.asset('images/camera.png')),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Camera",
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          );
        });
  }
}
