import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/hosts/helper/provider_model.dart';
import 'package:eventapp/hosts/helper/usermodel.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({required this.uid});
  String title = '';
  String desc = '';
  double price = 0.0;
  String profilepic = '';
  List<String> request = [];
  List<String> images = [];
  List<String> review = [];
  List<String> location = [];
  String accountcategory = '';
  String provider = 'provider';

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future savingUserData(
      String fullName, String email, String phone, String category) async {
    if (category == 'Host') {
      UserModel userModel = UserModel(
        fullName: fullName,
        email: email,
        phone: phone,
        category: category,
        profilepic: profilepic,
        uid: uid,
      );
      return await userCollection
          .doc(uid)
          .set(userModel.toMap())
          .whenComplete(() {
        print("added user scessfully");
      });
    } else {
      ProvideModel provideModel = ProvideModel(
        fullName: fullName,
        email: email,
        phone: phone,
        category: category,
        profilepic: profilepic,
        uid: uid,
        title: title,
        desc: desc,
        price: price,
        request: request,
        images: images,
        review: review,
        loaction: location,
        accountcategory: accountcategory,
        provider: provider,
      );
      return await userCollection
          .doc(uid)
          .set(provideModel.toFirestore())
          .whenComplete(() {
        print("added sucessfully");
      });
    }
  }

// this method check the database collection and find the category if != null the navgatie to home otherwise select category

  Future updateProviderData(String accountcategory, String title, String desc,
      double? price, List<String> images, List<String> location) async {
    return await userCollection.doc(uid).update({
      "accountcategory": accountcategory,
      "title": title,
      "desc": desc,
      "price": price,
      "images": images,
      "location": location,
    }).then((value) {
      print("User data updated");
    }).catchError((error) {
      print("Failed to update user data $error");
      return error;
    });
  }

  bool _isaccepted = false;

  Future updateRequest(
      String name, String email, String uid, String puid) async {
    final db = await userCollection.doc(puid).collection("request");
    db.doc(uid).set({
      "id": uid,
      "puid": puid,
      "name": name,
      "email": email,
      "isaccepted": _isaccepted,
    }).whenComplete(() {
      print("Hello aizz");
    });
  }

  Future updateProfilePic(String url) async {
    return await userCollection.doc(uid).update({
      'profilepic': url,
    });
  }
}
