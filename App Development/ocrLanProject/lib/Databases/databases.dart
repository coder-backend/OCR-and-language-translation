import 'package:cloud_firestore/cloud_firestore.dart';
import './user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // user reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  Future updateUserData(String name, String phoneNo, String gender) async {
    //print("user id: ${uid}");
    return await userCollection.doc(uid).set({
      'name': name,
      'phoneNo': phoneNo,
      'gender': gender,
    });
  }

  // student list from snapshot

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()["name"],
      phoneNo: snapshot.data()["phoneNo"],
      gender: snapshot.data()["gender"],
    );
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
