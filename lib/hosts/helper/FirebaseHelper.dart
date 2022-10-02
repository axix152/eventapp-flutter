import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/hosts/helper/provider_model.dart';

class FireBaseHelper {
  static Future<ProvideModel?> getuserModelById(String uid) async {
    ProvideModel? provideModel;
    final db = FirebaseFirestore.instance;
    final ref = db.collection("users").doc(uid).withConverter(
          fromFirestore: ProvideModel.fromFirestore,
          toFirestore: (ProvideModel providemodel, _) =>
              providemodel.toFirestore(),
        );
    final docSnap = await ref.get();
    provideModel = docSnap.data();
    if (provideModel != null) {
      return provideModel;
    }
  }
}
