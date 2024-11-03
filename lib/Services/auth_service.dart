import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loonigo/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // TODO: New user authenication
  Future<AppUser?> signInAnonymously(
      {required String name,
      required String age,
      required String gender}) async {
    UserCredential userCredential = await _auth.signInAnonymously();

    if (userCredential.user != null) {
      User user = userCredential.user!;

      _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'age': age,
        'gender': gender.toLowerCase(),
        'signInMethod': 'anonymous',
        'timestamp': Timestamp.now()
      });

      _firestore
          .collection('userPool')
          .doc(gender.toLowerCase())
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': name,
        'age': age,
        'gender': gender,
        'timestamp': Timestamp.now()
      });
      return AppUser(uid: user.uid, name: name, age: age, gender: gender);
    }

    return null;
  }

  // TODO: Upgrade authentication to phone number
}
