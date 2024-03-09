import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/auth.dart';
import '../screens/register/login.dart';
import '../screens/seller/edit_profile.dart';

// Function to reset password
Future<void> resetPassword(String email, context) async {
  try {
    // Send password reset email
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
    // Show success alert
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Password reset email sent to $email',
    );
    signOut(context);
    // Navigate to home screen after changing password
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  } catch (e) {
    // Handle errors
    Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 2-1-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
  }
}

// Function to update user profile
Future<void> updateUserInfo(
  context,
  String username,
  String firstname,
  String lastname,
  String bio,
  String address,
  ) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
            'username': username,
            'firstname': firstname,
            'lastname': lastname,
            'bio': bio,
            'address': address,
          });
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'User information updated successfully!',
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EditProfile()),
      );
    }
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 2-2-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

// Function to update user shipping address
Future<void> updateUserShippingAddress(String shippingAddress, context) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'shippingAddress': shippingAddress});
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Shipping address updated successfully!',
      );
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 2-3-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  } else {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 2-3-2",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

// Function to update user phone number
Future<void> updateUserPhoneNumber(String phoneNumber, context) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null && phoneNumber.isNotEmpty) {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'phoneNumber': phoneNumber});

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Phone number updated successfully!',
      );
      // Wait for a short duration before popping the context
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 2-4-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  } else {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 2-4-2",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

// Function to update user password
Future<void> updatePassword(String currentPassword, String newPassword, context) async {
  User? user = FirebaseAuth.instance.currentUser;

  // Reauthenticate the user with their current password
  AuthCredential credential = EmailAuthProvider.credential(email: user!.email!, password: currentPassword);
  try {
    await user.reauthenticateWithCredential(credential);
  } catch (e) {
    // Handle reauthentication failure
    // Check the specific error and provide a more user-friendly message
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 2-5-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return;
  }

  // Update the user's password
  try {
    await user.updatePassword(newPassword);
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Password updated successfully!',
    );
  } catch (e) {
    // Handle password update failure
    // Check the specific error and provide a more user-friendly message
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 2-5-2",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}