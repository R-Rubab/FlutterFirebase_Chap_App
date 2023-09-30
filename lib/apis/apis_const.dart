import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_application_11/model/chat_model.dart';
import 'package:flutter_chat_application_11/model/message_model.dart';

late Size mq;

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static User get user => auth.currentUser!;
  static late ChatUser me;

  static Future<bool> userExist() async {
    return (await firestore.collection('User').doc(user.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('User').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) {
          getSelfInfo();
        });
      }
    });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      image: user.photoURL.toString(),
      about: "hey! I'm using chat app...",
      name: user.displayName.toString(),
      online: false,
      id: user.uid,
      lastActive: time,
      createAt: time,
      email: user.email.toString(),
      pushToken: '',
    );
    return await firestore
        .collection('User')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser(
      // List<String> userIds
      ) {
    return firestore
        .collection('User')
        // .where('id', whereIn: userIds.isEmpty ? [''] : userIds)
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> upDateUserInfo() async {
    await firestore
        .collection('User')
        .doc(auth.currentUser!.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static Future<void> uploadingProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log('extension: $ext');
    final ref = storage.ref().child('Profile_picture/${user.uid}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/ $ext'))
        .then((p0) {
      log('Transfer data: ${p0.bytesTransferred / 1000} kb');
    });
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('User')
        .doc(user.uid)
        .update({'image': me.image});
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        // .collection('Message')
        .collection('Card/${getConversationID(user.id)}/Message/')
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
      formId: chatUser.id,
      msg: msg,
      read: '',
      told: user.uid,
      type: type,
      send: time,
    );

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
    // .then((value) =>
    //     sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }

  static Future<void> updateMessageReadStatus(Message msg) async {
    firestore
        .collection('chats/${getConversationID(msg.formId)}/message')
        .doc(msg.send)
        .update({'read': DateTime.now().toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser user) {
    return firestore
        // .collection('Message')
        .collection('Card/${getConversationID(user.id)}/Message/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
}
