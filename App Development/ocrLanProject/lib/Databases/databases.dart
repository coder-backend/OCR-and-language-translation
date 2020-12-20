import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ocrLanProject/Databases/urlData.dart';
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

////////////////////////////////////////////////////////////////////////////////
class DatabaseServiceURL {
  final String uid;
  DatabaseServiceURL({this.uid});

  // user reference
  final CollectionReference userCollectionURL =
      FirebaseFirestore.instance.collection('URL');

  Future updateUserDataURL(String url) async {
    //print("user id: ${uid}");
    return await userCollectionURL.doc(uid).set({
      'url': url,
    });
  }

  // student list from snapshot

  UserDataURL _userDataURLFromSnapshot(DocumentSnapshot snapshot) {
    return UserDataURL(
      uid: uid,
      url: snapshot.data()["url"],
    );
  }

  Stream<UserDataURL> get userDataURL {
    return userCollectionURL.doc(uid).snapshots().map(_userDataURLFromSnapshot);
  }
}
