import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spin_wheel/Utils/colorConst.dart';
import 'package:spin_wheel/features/Notification/notificationServices.dart';
import 'package:spin_wheel/features/auth/Splash/splashScreen.dart';
import 'package:spin_wheel/features/permission/permisssionHelper.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Request necessary permissions
  // await PermissionHelper.requestPermissions();

  // Initialize notifications
  // final notificationService = NotificationService();
  // await notificationService.initializeNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: whiteColor,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}
