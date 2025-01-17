import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initializeUser(String userId) async {
    final userDoc = _firestore.collection('users').doc(userId);
    final userExists = (await userDoc.get()).exists;

    if (!userExists) {
      await userDoc.set({
        'coins': 100,
        'freeSpins': 5,
        'lastSpinTime': null,
      });
    }
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.data()!;
  }

  Future<void> updateCoins(String userId, int coins) async {
    final userDoc = _firestore.collection('users').doc(userId);
    await userDoc.update({'coins': coins});
  }

  Future<void> updateLastSpinTime(String userId, DateTime lastSpinTime) async {
    final userDoc = _firestore.collection('users').doc(userId);
    await userDoc.update({'lastSpinTime': lastSpinTime});
  }
}
