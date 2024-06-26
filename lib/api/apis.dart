import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messages/models/chat_user.dart';
import 'package:messages/models/message.dart';

class APIs {
  static final auth = FirebaseAuth.instance;
  static final firestore = FirebaseFirestore.instance;
  static final storageRef = FirebaseStorage.instance.ref();
  static User get user => auth.currentUser!;
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static late ChatUser me;

  static Future<void> getSelfInfo() async {
    firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "I'm feeling lucky.",
        createdAt: time,
        lastActive: '',
        id: user.uid,
        isOnline: false,
        email: user.email!,
        pushToken: '');
    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set(chatUser.toJson(), SetOptions(merge: true))
        .onError((error, stackTrace) => log('Error writing document $error'));
  }

  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static Future<void> updateProfilePicture(File file) async {
    final imageExt = file.path.split('.').last;
    final imageRef = storageRef.child('profile_pictures/${user.uid}.$imageExt');
    await imageRef
        .putFile(file, SettableMetadata(contentType: "image/$imageExt"))
        .then((snapshot) async {
      // me.image = await snapshot.ref.getDownloadURL();
      // log("imageURL: ${me.image}");
      me.image = await imageRef.getDownloadURL();
      log("data transferred: ${snapshot.bytesTransferred}");
      await firestore
          .collection('users')
          .doc(user.uid)
          .update({'image': me.image});
    });
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        sent: time,
        type: Type.text,
        fromId: user.uid);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(Message msg) async {
    firestore
        .collection('chats/${getConversationID(msg.fromId)}/messages/')
        .doc(msg.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent ', descending: true)
        .limit(1)
        .snapshots();
  }
}
