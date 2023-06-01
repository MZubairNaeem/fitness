import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coachingapp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coachProvider = FutureProvider<List<UserModel>>((ref) async {
  String res = "Some error has occurred";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await _firestore
      .collection('Users')
      .where('userType', isEqualTo: 'coachKey')
      .get();

  List<UserModel> userModels = doc.docs.map((snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return UserModel(
      firstName: data['firstName'],
      uid: data['uid'],
      location: data['location'],
      dateOfBirth: data['dateOfBirth'],
      phoneNumber: data['phoneNumber'],
      email: data['email'],
      userType: data['userType'],
    );
  }).toList();

  return userModels;
});