import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spin_wheel/Utils/colorConst.dart';
import 'package:spin_wheel/Utils/common/appValidator.dart';
import 'package:spin_wheel/Utils/common/commonWidgets.dart';
import 'package:spin_wheel/Utils/stringConst.dart';
import 'package:spin_wheel/features/auth/SignUp/signUpScreen.dart';
import 'package:spin_wheel/features/auth/controller/authController.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  final controller = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            _buildGradientBackground(),
            _buildLoginForm(context),
          ],
        ),
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

  Widget _buildLoginForm(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            commonText(
                title: StringConst.welcomeBack,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: whiteColor),
            SizedBox(height: 40),
            _buildTextField(
                hintText: StringConst.enterYourEmail,
                icon: Icon(Icons.person_2_rounded),
                validator: (v) =>
                    AppValidator.email(controller.emailController.text.trim()),
                controller: controller.emailController),
            SizedBox(height: 20),
            _buildTextField(
                hintText: StringConst.enterYourPassword,
                obscureText: true,
                icon: Icon(Icons.password_rounded),
                validator: (v) => AppValidator.password(
                    controller.passController.text.trim()),
                controller: controller.passController),
            SizedBox(height: 30),
            Obx(() {
              return _buildAnimatedButton(
                  text: StringConst.login,
                  textColor: whiteColor,
                  bgColor: tealColor,
                  onTap: controller.isLoginLoading.isFalse
                      ? () {
                          if (formKey.currentState!.validate()) {
                            controller.loginWithEmail(
                                controller.emailController.text.trim(),
                                controller.passController.text.trim());
                          }
                        }
                      : () {},
                  isLoading: controller.isLoginLoading.isTrue);
            }),
            SizedBox(height: 15),
            _buildSignUpOption(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String hintText,
      bool obscureText = false,
      required Widget icon,
      required controller,
      required validator}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: textFieldDecoration(
          hint: hintText,
          fillColor: whiteColor.withOpacity(0.85),
          prefixIcon: icon),
      style: GoogleFonts.merriweather(color: blackColor),
    );
  }

  Widget _buildAnimatedButton(
      {required String text,
      required Color textColor,
      required Color bgColor,
      required VoidCallback onTap,
      required bool isLoading}) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: whiteColor,
                ),
              )
            : commonText(
                title: text,
                fontSize: 18,
                color: textColor,
              ),
      ),
    );
  }

  Widget _buildSignUpOption(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          commonText(
            title: StringConst.dontHaveAc,
            color: Colors.white.withOpacity(0.8),
          ),
          TextButton(
            onPressed: () {
              controller.emailController.clear();
              controller.passController.clear();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
            child: commonText(
              title: StringConst.signUp,
              fontSize: 16,
              color: Color(0xFF16A085),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
