import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messages/models/chat_user.dart';

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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    return firestore
        .collection('messages')
        .snapshots();
  }

}
