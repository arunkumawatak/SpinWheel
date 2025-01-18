import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:spin_wheel/features/Home/controller/userController.dart';
import 'package:spin_wheel/features/auth/controller/authController.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController userController = Get.put(UserController());
// finanl  AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spin Wheel"),
        actions: [
          IconButton(
              onPressed: () {},
              // authController.isLogOutLoading.isTrue
              //     ? () {}
              //     : () {
              //         authController.logout();
              //       },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Obx(() {
        final user = userController.userModel.value;

        return

            // authController.isLogOutLoading.isTrue
            //     ? Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     :
            Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Coins: ${user.coins}", style: TextStyle(fontSize: 24)),
            Text("Free Spins: ${user.freeSpins}",
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Expanded(
              child: FortuneWheel(
                selected: userController.selectedController.stream,
                items: userController.rewards
                    .map((reward) => FortuneItem(
                          child: Text("$reward Coins"),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: userController.isSpinning.value
                  ? null
                  : () {
                      userController.spinWheel(userController.rewards, RxInt(0),
                          userController.selectedController);
                    },
              child: userController.isSpinning.value
                  ? CircularProgressIndicator()
                  : const Text("Spin"),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return Text(
                userController.cooldownTime.value,
                style: TextStyle(fontSize: 18, color: Colors.red),
              );
            }),
          ],
        );
      }),
    );
  }
}
