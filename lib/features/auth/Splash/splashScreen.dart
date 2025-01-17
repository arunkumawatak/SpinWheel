// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:spin_wheel/Utils/colorConst.dart';
// import 'package:spin_wheel/Utils/common/commonWidgets.dart';
// import 'package:spin_wheel/features/auth/Login/loginScreen.dart';
// import 'package:spin_wheel/Utils/stringConst.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(seconds: 4),
//       vsync: this,
//     );
//     _controller.forward();
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
// //navigate to the LoginScreen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => LoginScreen()),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // controller dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           _buildGradientBackground(),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Lottie.asset(
//                   "assets/animation/splashAnimation.json",
//                   controller: _controller,
//                   width: 200,
//                   height: 200,
//                   fit: BoxFit.fill,
//                 ),
//                 SizedBox(height: 40),
//                 commonText(
//                   title: StringConst.lettheWheelSpin,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGradientBackground() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [primaryColor, lightGrey],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Replace with your actual login screen
import 'package:spin_wheel/Utils/colorConst.dart';
import 'package:spin_wheel/Utils/common/commonWidgets.dart';
import 'package:spin_wheel/Utils/stringConst.dart';
import 'package:spin_wheel/features/Home/view/homeScreen.dart';
import 'package:spin_wheel/features/auth/Login/loginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _controller.forward();
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // Check user login status
        final currentUser = FirebaseAuth.instance.currentUser;
        final prefs = await SharedPreferences.getInstance();
        final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

        if (currentUser != null && isLoggedIn) {
          // User is already logged in
          Get.off(() => HomeScreen());
        } else {
          // User is not logged in
          Get.off(() => LoginScreen());
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildGradientBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/animation/splashAnimation.json",
                  controller: _controller,
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 40),
                commonText(
                  title: StringConst.lettheWheelSpin,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, lightGrey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
