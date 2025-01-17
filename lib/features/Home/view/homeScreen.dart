import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spin_wheel/features/Home/controller/userController.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController userController = Get.put(UserController());
  final List<int> rewards = [23, 40, 60, 100, 200];
  late StreamController<int> selectedController;
  int selectedReward = 0;

  @override
  void initState() {
    super.initState();
    selectedController = StreamController<int>();
  }

  @override
  void dispose() {
    selectedController.close();
    super.dispose();
  }

  void spinWheel() async {
    final random = Random();
    double roll = random.nextDouble();
    double cumulativeProbability = 0.0;
    final probabilities = [0.98, 0.01, 0.004, 0.005, 0.001];

    for (int i = 0; i < probabilities.length; i++) {
      cumulativeProbability += probabilities[i];
      if (roll <= cumulativeProbability) {
        selectedReward = i;
        break;
      }
    }

    selectedController.add(selectedReward);

    await userController.updateCoins(rewards[selectedReward]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Congratulations!"),
        content: Text("You won ${rewards[selectedReward]} coins!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Spin Wheel")),
      body: Obx(() {
        final user = userController.userModel.value;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Coins: ${user.coins}", style: TextStyle(fontSize: 24)),
            Text("Free Spins: ${user.freeSpins}",
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<int>(
                stream: selectedController.stream,
                builder: (context, snapshot) {
                  return FortuneWheel(
                    selected: Stream.value(snapshot.data ?? 0),
                    items: rewards
                        .map((reward) => FortuneItem(
                              child: Text("$reward Coins"),
                            ))
                        .toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: spinWheel,
              child: const Text("Spin"),
            ),
          ],
        );
      }),
    );
  }
}
