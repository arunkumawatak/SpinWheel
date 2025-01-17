import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spin_wheel/features/Home/view/homeScreen.dart';
import 'package:spin_wheel/features/auth/Login/loginScreen.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  RxBool isLoginLoading = false.obs;
  RxBool isSignUpLoading = false.obs;
  RxBool isLogOutLoading = false.obs;

  // Helper to show snack bars
  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // User creation
  Future<User?> createUser(String email, String password) async {
    isSignUpLoading.value = true;
    try {
      if (email.isEmpty || password.isEmpty) {
        throw FirebaseAuthException(
          code: 'empty-field',
          message: 'Email or password cannot be empty.',
        );
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      log("user cread ${userCredential}");
      Get.off(() => HomeScreen());
      isSignUpLoading.value = false;
      _showSuccessSnackbar(
          "Registration Successful", "Your account has been created!");

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      isSignUpLoading.value = false;
      switch (e.code) {
        case 'email-already-in-use':
          _showErrorSnackbar(
              "Registration Error", "This email is already in use.");
          break;
        case 'invalid-email':
          _showErrorSnackbar("Registration Error", "Invalid email format.");
          break;
        case 'weak-password':
          _showErrorSnackbar("Registration Error",
              "Password is too weak. Please choose a stronger password.");
          break;
        case 'empty-field':
          _showErrorSnackbar(
              "Registration Error", e.message ?? "Invalid input.");
          break;
        default:
          _showErrorSnackbar("Registration Error",
              e.message ?? "An unexpected error occurred.");
      }

      log('Error during registration: $e');
      return null;
    } catch (e) {
      isSignUpLoading.value = false;
      _showErrorSnackbar("Error", "An unexpected error occurred.");
      log('Error during registration: $e');
      return null;
    }
  }

  // Login
  Future<User?> loginWithEmail(String email, String password) async {
    isLoginLoading.value = true;
    try {
      if (email.isEmpty || password.isEmpty) {
        throw FirebaseAuthException(
          code: 'empty-field',
          message: 'Email or password cannot be empty.',
        );
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Save login state in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Get.off(() => HomeScreen());

      isLoginLoading.value = false;

      _showSuccessSnackbar("Login Successful", "Welcome back!");

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      isLoginLoading.value = false;

      // Handling specific Firebase errors
      switch (e.code) {
        case 'user-not-found':
          _showErrorSnackbar("Login Error", "No user found with this email.");
          break;
        case 'wrong-password':
          _showErrorSnackbar("Login Error", "Incorrect password. Try again.");
          break;
        case 'invalid-email':
          _showErrorSnackbar("Login Error", "Invalid email format.");
          break;
        case 'empty-field':
          _showErrorSnackbar("Login Error", e.message ?? "Invalid input.");
          break;
        default:
          _showErrorSnackbar(
              "Login Error", e.message ?? "An unexpected error occurred.");
      }

      log('Error during login: $e');
      return null;
    } catch (e) {
      isLoginLoading.value = false;
      _showErrorSnackbar("Error", "An unexpected error occurred.");
      log('Error during login: $e');
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    isLogOutLoading.value = true;
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false); // Clear login state
      isLogOutLoading.value = false;

      _showSuccessSnackbar("Logout Successful", "You have been logged out.");
      Get.offAll(() => LoginScreen()); // Redirect to login screen
    } catch (e) {
      isLogOutLoading.value = false;
      _showErrorSnackbar("Logout Error", "Failed to log out. Try again.");
      log('Error during logout: $e');
    }
  }
}
