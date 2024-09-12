import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Firebase_Service {
  static Stream<Map<String, dynamic>> streamUserData() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Stream<DocumentSnapshot> userDataStream = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots();

        return userDataStream.map((userDataDoc) {
          if (userDataDoc.exists) {
            return userDataDoc.data() as Map<String, dynamic>;
          } else {
            return {}; // Return empty map if document does not exist
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user data: $e");
      }
    }

    // Return an empty stream if no user is authenticated or an error occurs
    return Stream.value({});
  }
}
