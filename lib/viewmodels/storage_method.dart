import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethod{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(String userID, Uint8List file) async {

    Reference ref = _storage.ref().child(userID).child(_auth.currentUser!.uid);
     
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
  }
}