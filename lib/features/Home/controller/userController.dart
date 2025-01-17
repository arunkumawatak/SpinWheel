import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spin_wheel/features/Home/model/userModel.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  // Fetch user data from Firebase
  Future<void> fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        userModel.value = UserModel.fromMap(doc.data()!);
      } else {
        // If the user is new, initialize data
        userModel.value = UserModel(
          uid: user.uid,
          email: user.email,
        );
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.value.toMap());
      }
    }
  }

  // Update coins in Firebase and locally
  Future<void> updateCoins(int amount) async {
    userModel.update((user) {
      if (user != null) {
        user.coins += amount;
      }
    });
    await _firestore
        .collection('users')
        .doc(userModel.value.uid)
        .update({'coins': userModel.value.coins});
  }

  // Update free spins
  Future<void> updateFreeSpins(int count) async {
    userModel.update((user) {
      if (user != null) {
        user.freeSpins += count;
      }
    });
    await _firestore
        .collection('users')
        .doc(userModel.value.uid)
        .update({'freeSpins': userModel.value.freeSpins});
  }

  // Update last spin time
  Future<void> updateLastSpinTime() async {
    final now = DateTime.now();
    userModel.update((user) {
      if (user != null) {
        user.lastSpinTime = now;
      }
    });
    await _firestore
        .collection('users')
        .doc(userModel.value.uid)
        .update({'lastSpinTime': now.toIso8601String()});
  }
}
