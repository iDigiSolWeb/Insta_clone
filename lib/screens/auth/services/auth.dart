import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/screens/auth/services/storage_methods.dart';
import 'package:insta_clone/utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapshot = await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.fromSnap(snapshot);
  }

  ///sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String bio,
    required String userName,
    required Uint8List? file,
    required BuildContext context,
  }) async {
    String res = 'Error Occurred';

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          userName.isNotEmpty ||
          file != null) {
        String? downloadUrl;
        UserCredential usercred =
            await _auth.createUserWithEmailAndPassword(email: email, password: password);

        downloadUrl = await StorageMethods()
            .uploadImagetoStorage('profilePic/${usercred.user!.uid}', file!, false);

        UserModel userModel = UserModel(
          username: userName,
          uid: usercred.user!.uid,
          photoUrl: downloadUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );

        _firestore.collection('users').doc(usercred.user!.uid).set(userModel.toJson());

        res = 'Success';
        showSnackBar(context, 'You have succesfully created an account , please login');
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'The password is badly formatted';
      }
    } catch (e) {
      res = e.toString();
      showSnackBar(context, res);
    }

    return res;
  }

  ///Login
  Future<String> loginUser(
      {required String email, required String password, required BuildContext context}) async {
    String res = 'Error Occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'Successful Login';
      } else {
        res = 'Please enter all fields';
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return res;
  }
}
