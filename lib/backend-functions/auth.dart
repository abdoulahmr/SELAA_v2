import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'package:selaa/screens/register/complete_info.dart';
import 'package:selaa/screens/register/redirect_login.dart';
import '../screens/register/login.dart';

// Function to register a user with email and password (bute)
Future<User?> registerWithEmailPassword({
  required email,
  required password,
  required firstname,
  required lastname,
  required accountType,
  context,
}) async {
  // Show loading alert while registering
  QuickAlert.show(
    context: context,
    type: QuickAlertType.loading,
    title: 'Loading',
    text: 'Please wait...',
  );
  try {
    // Create user with email and password
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    if (user != null) {
      // Save additional user data to Firestore
      if(accountType == "buyer"){
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'password': password,
          'phoneNumber': '',
          'shippingAdress': '',
          'accountType': accountType,
          'balance': 0,
          'check': true
        });
      }
      else if(accountType == "seller"){
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'password': password,
          'address': '',
          'phoneNumber': '',
          'accountType': accountType,
          'username': firstname + " " + lastname,
          'bio': '',
          'profilePicture': '',
          'balance': 0,
          'check': true
        });
      }
    }
    // Dismiss loading alert
    Navigator.pop(context);
    // Show success alert
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Account created successfully!',
    );
    if (user != null) {
      // Send email verification and navigate to login screen
      await user.sendEmailVerification();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  } on FirebaseAuthException catch (e) {
    // Handle FirebaseAuth exceptions
    if (e.code == 'weak-password') {
      Fluttertoast.showToast(
        msg: "Password should be at least 8 characters. code 1-1-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.yellow,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    } else if (e.code == 'email-already-in-use') {
      Fluttertoast.showToast(
        msg: "The account already exists for that email. code 1-1-2",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.yellow,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  } catch (e) {
    // Handle other exceptions
    Fluttertoast.showToast(
        msg: "Error creating account please send us a feedback code 1-1-3",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
  }
  return null;
}

// Function to log in with email and password
Future<User?> loginWithEmailPassword(
  String email,
  String password,
  context,
) async {
  try {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Loading',
      text: 'Please wait...',
    );
    // Sign in with email and password
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    // Get the FCM token
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    // Save the FCM token to the user's document in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'fcmToken': fcmToken});
    Navigator.push(context, MaterialPageRoute(builder: (context) => const RedirectLogin()));
    // remove the comment to check email
    ////////////////////////////////////////////////
    // if (user != null && !user.emailVerified) {
    //   Navigator.pop(context);
    //   // Show info alert if email is not verified
    //   Fluttertoast.showToast(
    //     msg: "Please confirm your email address! code 1-2-1",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.yellow,
    //     textColor: Colors.black,
    //     fontSize: 16.0,
    //   );
    // } else {
    //   // Navigate to home screen after successful login
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => const RedirectLogin()));
    // }
  } on FirebaseAuthException catch (e) {
    // Handle FirebaseAuth exceptions
    if (e.code == 'user-not-found') {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "No user found for $email. code 1-2-2",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (e.code == 'wrong-password') {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Wrong password provided for that user. code 1-2-3",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );    
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 1-2-4",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  } catch (e) {
    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 1-2-5",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
  }
  return null;
}

// Function to resend email verification
Future<void> resendEmailVerification(User user, context) async {
  try {
    await user.sendEmailVerification();
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 1-3-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.yellow,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  } catch (e) {
    Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 1-3-2",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
  }
}

// Function to sign out
Future<void> signOut(context) async {
  try {
    // Sign out user
    await FirebaseAuth.instance.signOut();
    // Navigate to login screen after sign out
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  } catch (e) {
    // Handle errors
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 1-4-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

// Function to sign up with Google account
Future<User?> signInWithGoogle(BuildContext context, String accountType, ScaffoldMessengerState scaffoldMessenger) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut(); // Sign out the current account
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        // Check if the user's email already exists in Firestore
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();
        if (querySnapshot.docs.isEmpty) {
          // Get the FCM token
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'firstname': user.displayName?.split(' ')[0] ?? '',
            'lastname': user.displayName?.split(' ')[1] ?? '',
            'email': user.email,
            'phoneNumber': '',
            'shippingAdress': '',
            'accountType': accountType,
            'balance': 0,
            'check': false,
            'fcmToken': fcmToken
          });
          // Navigate to user info screen to complete registration
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CompleteRegistrationPage()));
          return null;
        }
        // Email exists, proceed with sign-in
        // Dismiss loading alert
        scaffoldMessenger.hideCurrentSnackBar();
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        // Save the FCM token to the user's document in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'fcmToken': fcmToken});
        // Navigate to home screen after successful login
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RedirectLogin()),
        );
      }
    }
  } catch (e) {
    Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 1-5-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
  }
  return null;
}

// Function to sign up with Facebook account
Future<void> signInWithFacebook(BuildContext context, String accountType, ScaffoldMessengerState scaffoldMessenger) async {
  try {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.token);

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      
      if (user != null) {
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();
        
        if (querySnapshot.docs.isEmpty) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'firstname': user.displayName?.split(' ')[0] ?? '',
            'lastname': user.displayName?.split(' ')[1] ?? '',
            'email': user.email,
            'phoneNumber': '',
            'shippingAdress': '',
            'accountType': accountType,
            'balance': 0,
            'check': false
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteRegistrationPage()));
        } else {
          scaffoldMessenger.hideCurrentSnackBar();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const RedirectLogin()));
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 1-6-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  } catch (e) {
    Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 1-6-2",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
  }
}
