import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart' as model;
import '../models/videos.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Future<void> registerUser(UserModel user) async {

  //   try {
  //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: user.email,
  //       password: 'your_password_here',
  //     );

  //     await _firestore.collection('users').doc(userCredential.user!.uid).set({
  //       'name': user.name,
  //       'email': user.email,
  //       'location': user.location,
  //       'dateOfBirth': user.dateOfBirth,
  //       'phoneNumber': user.phoneNumber,
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     _errorMessage = e.message;
  //     notifyListeners();
  //   }
  // }

  Future<String> signUpUser({
    required String firstName,
    required String email,
    required String password,
    required String location,
    required String dateOfBirth,
    required String phoneNumber,
    required userType,
  }) async {
    String res = "Some error has occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.phoneNumber);

        // String photoUrl = await StorageMethod()
        //     .uploadImageToStorage('profilePic', file, false);
        //add user

        model.UserModel user = model.UserModel(
          uid: cred.user!.uid,
          firstName: firstName,
          location: location,
          dateOfBirth: dateOfBirth,
          phoneNumber: phoneNumber,
          email: email,
          userType: userType,
        );
        await _firestore.collection('Users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Future<String> loginUser(
  //     {required String email, required String password}) async {
  //   String id = "Empty";
  //   try {
  //     if (email.isNotEmpty || password.isNotEmpty) {
  //       UserCredential user = await _auth.signInWithEmailAndPassword(
  //           email: email, password: password);
  //       if (user.user!.uid.isNotEmpty) {
  //         print(user.user!.uid);
  //
  //         id = user.user!.uid;
  //       }
  //     } else {
  //       return "Please Enter all the fields";
  //     }
  //   } catch (err) {
  //     id = err.toString();
  //   }
  //   return id;
  // }

  Future<model.UserModel> getUserDetails(var id) async {
    String res = "Some error has occur";
    try {
      if (id.isNotEmpty) {
        print(id);
        DocumentSnapshot doc =
            await _firestore.collection('Users').doc(id).get();
        res = doc.data().toString();
        res = jsonEncode(doc.data());
        var data = await jsonDecode(res);
        return model.UserModel(
            firstName: data['firstName'],
            uid: data['uid'],
            location: data['location'],
            dateOfBirth: data['dateOfBirth'],
            phoneNumber: data['phoneNumber'],
            email: data['email'],
            userType: data['userType']);
      } else {
        res = "Please Enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return model.UserModel(
        uid: "Empty",
        firstName: "Empty",
        location: "Empty",
        dateOfBirth: "Empty",
        phoneNumber: "Empty",
        email: "Empty",
        userType: "Empty");
  }

  Future forgetPass({required String email}) async {
    String res = "Some error has occur";
    try {
      if (email.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: email);
        res = "Success";
      } else {
        res = "Please Enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future StoreVideos(Video Videos) async {
    String res = "Some error has occur";
    try {
      //register user
      await FirebaseFirestore.instance
          .collection('Videos')
          .doc(Videos.videoId)
          .set({
        'videoId': Videos.videoId,
        'videoTitle': Videos.videoTitle,
        'videoDescription': Videos.videoDescription,
        'videoUrl': Videos.videoUrl,
        'videoThumbnail': Videos.videoThumbnail
      });
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Subcribe to coach
  Future<String> Subscirbe(String coach_id) async {
    var user_id = _auth.currentUser!.uid;
    try {
      await _firestore
          .collection('Subscriptions')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({'subscriber': user_id, 'subscribed': coach_id});
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> checkSubscription(String coach_id) async {
    var user_id = _auth.currentUser!.uid;
    try {
      var data = await _firestore
          .collection('Subscriptions')
          .where('subscriber', isEqualTo: user_id)
          .where('subscribed', isEqualTo: coach_id)
          .get();
      if (data.docs.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}