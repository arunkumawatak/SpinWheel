// import 'package:permission_handler/permission_handler.dart';

// class PermissionHelper {
//   // Request location permission
//   static Future<bool> requestLocationPermission() async {
//     final status = await Permission.location.request();
//     return status.isGranted;
//   }

//   // Request storage permission
//   static Future<bool> requestStoragePermission() async {
//     final status = await Permission.storage.request();
//     return status.isGranted;
//   }

//   // Request notification permission (for iOS)
//   static Future<bool> requestNotificationPermission() async {
//     final status = await Permission.notification.request();
//     return status.isGranted;
//   }

//   // Request all necessary permissions
//   static Future<void> requestPermissions() async {
//     // You can call each permission request method here
//     await requestLocationPermission();
//     await requestStoragePermission();
//     await requestNotificationPermission();
//   }
// }
