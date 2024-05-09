import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messages/models/chat_user.dart';

class APIs {
  static final auth = FirebaseAuth.instance;
  static final firestore = FirebaseFirestore.instance;
  static get user => auth.currentUser!;
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
        email: user.email,
        pushToken: '');
    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set(chatUser.toJson(), SetOptions(merge: true))
        .onError((error, stackTrace) => log('Error writing document $error'));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }
}
