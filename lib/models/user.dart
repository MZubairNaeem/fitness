import 'package:cloud_firestore/cloud_firestore.dart';

// class UserModel {
//   String username;
//   String email;
//   String uid;
//   String location;
//   String dateOfBirth;
//   String phoneNumber;

//   UserModel({
//     required this.username,
//     required this.email,
//     required this.uid,
//     required this.location,
//     required this.dateOfBirth,
//     required this.phoneNumber,
//   });
// }

class UserModel {
  String uid;
  String firstName;
  String email;
  String location;
  String dateOfBirth;
  // String photoUrl;
  String phoneNumber;
  String userType;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.email,
    required this.location,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.userType,
    // this.photoUrl
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'firstName': firstName,
        'email': email,
        'location': location,
        'dateOfBirth': dateOfBirth,
        'phoneNumber': phoneNumber,
        'userType': userType,
        // 'photoUrl': photoUrl
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot['uid'],
      firstName: snapshot['firstName'],
      email: snapshot['email'],
      location: snapshot['location'],
      dateOfBirth: snapshot['dateOfBirth'],
      phoneNumber: snapshot['phoneNumber'],
      userType: snapshot['userType'],
      // photoUrl: snapshot['photoUrl'],
    );
  }
}