import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:spin_wheel/features/Home/model/userModel.dart';
import 'package:spin_wheel/features/Notification/notificationServices.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // Initialize the local notifications plugin

  Rx<UserModel> userModel = UserModel().obs;
  RxBool isSpinning = false.obs;
  RxString cooldownTime = ''.obs;
  Timer? cooldownTimer;
  late StreamController<int> selectedController;
  late ConfettiController _confettiController;

  final List<int> rewards = [23, 40, 60, 100, 200];
  final List<double> probabilities = [0.98, 0.01, 0.004, 0.005, 0.001];

  @override
  void onInit() {
    super.onInit();
    selectedController = StreamController<int>();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    // _initializeNotifications();
    fetchUserData();
  }

  // Initialize local notifications
  // void _initializeNotifications() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings(
  //           'app_icon'); // Replace with your app's icon

  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);

  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        userModel.value = UserModel.fromMap(doc.data()!);
      } else {
        userModel.value = UserModel(
          uid: user.uid,
          email: user.email,
          freeSpins: 5,
          coins: 100,
          lastSpinTime: DateTime.now().toIso8601String(),
          spinsCompleted: 0,
        );
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.value.toMap());
      }
      startCooldownTimer();
    }
  }

  // Deduct coins from the user's account
  Future<void> deductCoins(int amount) async {
    userModel.update((user) {
      if (user != null) {
        user.coins -= amount;
        if (user.coins < 0) user.coins = 0;
      }
    });

    await _firestore
        .collection('users')
        .doc(userModel.value.uid)
        .update({'coins': userModel.value.coins});
  }

  // Spin wheel logic
  void spinWheel(List<int> rewards, RxInt selectedReward,
      StreamController<int> selectedController) async {
    isSpinning.value = true;

    final user = userModel.value;

    if (user == null) {
      Get.snackbar("Error", "User not logged in",
          snackPosition: SnackPosition.BOTTOM);
      isSpinning.value = false;
      return;
    }

    final canSpinResult = await canSpin();
    if (!canSpinResult) {
      Get.snackbar("No Spins Left",
          "You need either free spins, 50 coins, or wait for the cooldown.",
          snackPosition: SnackPosition.BOTTOM);
      isSpinning.value = false;
      return;
    }

    // Deduct resources
    if (user.freeSpins > 0) {
      await updateFreeSpins(-1); // Deduct 1 free spin
    } else if (user.coins >= 50) {
      await deductCoins(50); // Deduct 50 coins
    } else {
      Get.snackbar("Insufficient Coins", "You need at least 50 coins to spin.",
          snackPosition: SnackPosition.BOTTOM);
      isSpinning.value = false;
      return;
    }

    // Perform spin logic
    final random = Random();
    double roll = random.nextDouble();
    double cumulativeProbability = 0.0;

    for (int i = 0; i < probabilities.length; i++) {
      cumulativeProbability += probabilities[i];
      if (roll <= cumulativeProbability) {
        selectedReward.value = i;
        break;
      }
    }

    selectedController.add(selectedReward.value);
    final winningAmount = rewards[selectedReward.value];

    await updateCoins(winningAmount);
    await incrementSpinsCompleted();

    if (user.spinsCompleted >= 5) {
      startCooldownTimer(); // Start cooldown if max spins reached
    }

    await updateLastSpinTime(); // Update last spin time

    // Show result dialog
    Get.defaultDialog(
      title: "Congratulations!",
      middleText: "You won $winningAmount coins!",
      confirm: InkWell(
        onTap: () => Get.back(),
        child: const Text("OK"),
      ),
    );

    _confettiController.play(); // Play confetti animation
    isSpinning.value = false;
  }

  // Start cooldown timer
  void startCooldownTimer() {
    final user = userModel.value;

    if (user == null || (user.freeSpins > 0 || user.coins >= 50)) {
      cooldownTime.value = ''; // Reset cooldown if resources are available
      return;
    }

    if (user.lastSpinTime != null && user.lastSpinTime!.isNotEmpty) {
      final lastSpin = DateTime.parse(user.lastSpinTime!);
      final now = DateTime.now();
      final remainingTime = Duration(hours: 2) - now.difference(lastSpin);

      if (remainingTime.isNegative) {
        cooldownTime.value = 'Cooldown over, you can spin again!';
        // _showCooldownEndNotification(); // Trigger notification
      } else {
        cooldownTimer?.cancel();
        cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          final currentTime = DateTime.now();
          final remaining = remainingTime - currentTime.difference(lastSpin);

          if (remaining.isNegative) {
            cooldownTime.value = 'Cooldown over, you can spin again!';
            timer.cancel();
            // _showCooldownEndNotification(); // Trigger notification when timer ends
          } else {
            final minutes = remaining.inMinutes;
            final seconds = remaining.inSeconds % 60;
            cooldownTime.value =
                'Cooldown: $minutes:${seconds.toString().padLeft(2, '0')}';
          }
        });
      }
    }
  }

  // Show notification when cooldown ends
  // Future<void> _showCooldownEndNotification() async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     'cooldown_channel', // Channel ID
  //     'Cooldown Notifications', // Channel name
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     showWhen: false,
  //   );

  //   const NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);

  //   await flutterLocalNotificationsPlugin.show(
  //     0, // Notification ID
  //     'Cooldown Over', // Title
  //     'You can now spin again!', // Body
  //     notificationDetails,
  //     payload:
  //         'cooldown_over', // Optional payload (data associated with the notification)
  //   );
  // }

  // Helper methods to update user data
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

  Future<void> updateFreeSpins(int count) async {
    userModel.update((user) {
      if (user != null) {
        user.freeSpins += count;
        if (user.freeSpins < 0) user.freeSpins = 0;
      }
    });

    await _firestore
        .collection('users')
        .doc(userModel.value.uid)
        .update({'freeSpins': userModel.value.freeSpins});
  }

  Future<void> updateLastSpinTime() async {
    final now = DateTime.now();
    userModel.update((user) {
      if (user != null) {
        user.lastSpinTime = now.toIso8601String();
      }
    });

    await _firestore
        .collection('users')
        .doc(userModel.value.uid)
        .update({'lastSpinTime': now.toIso8601String()});
  }

  Future<void> incrementSpinsCompleted() async {
    userModel.update((user) {
      if (user != null) {
        user.spinsCompleted += 1;
      }
    });

    await _firestore
        .collection('users')
        .doc(userModel.value.uid)
        .update({'spinsCompleted': userModel.value.spinsCompleted});
  }

  Future<bool> canSpin() async {
    final user = userModel.value;

    if (user.freeSpins > 0) {
      return true; // Free spins available
    }

    if (user.coins >= 50) {
      return true; // Sufficient coins
    }

    if (user.spinsCompleted >= 5) {
      startCooldownTimer(); // Trigger cooldown if max spins reached
      return false;
    }

    return false; // Cannot spin
  }
}
