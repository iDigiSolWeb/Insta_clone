import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_clone/models/post.dart';
import 'package:insta_clone/screens/auth/services/storage_methods.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    BuildContext context,
    Uint8List file,
    String description,
    String uid,
    String userName,
    String profileImage,
  ) async {
    String res = 'Error';
    try {
      String photoUrl = await StorageMethods().uploadImagetoStorage('posts', file, true);
      String postId = Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: userName,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profileImage,
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'Success';
    } catch (e) {
      res = e.toString();
      showSnackBar(context, e.toString());
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String textcomment, String uid, String name,
      String profilePic, BuildContext context) async {
    String res = 'Error';
    try {
      String commentID = Uuid().v1();
      if (textcomment.isNotEmpty) {
        _firestore.collection('posts').doc(postId).collection('comments').doc(commentID).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': textcomment,
          'commentId': commentID,
          'datePublished': DateTime.now(),
        });

        res = 'Successful';
        showSnackBar(context, 'Posted');
      } else {
        print('Text is empty');
      }
    } catch (e) {
      res = e.toString();
      print(e.toString());
    }
    return res;
  }

  Future<void> deletePost(String postId, BuildContext context) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
