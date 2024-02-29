import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password should be at least 8 characters. code 9'),
        ),
      );
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The account already exists for that email. code 10'),
        ),
      );
    }
  } catch (e) {
    // Handle other exceptions
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error creating account please send us a feedback code 11'),
      ),
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
    if (user != null && !user.emailVerified) {
      Navigator.pop(context);
      // Show info alert if email is not verified
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please confirm your email address! code 12'),
          action: SnackBarAction(
            label: 'Resend',
            onPressed: () {
              resendEmailVerification(user, context);
            },
          ),
        ),
      );
    } else {
      // Navigate to home screen after successful login
      Navigator.push(context, MaterialPageRoute(builder: (context) => const RedirectLogin()));
    }
  } on FirebaseAuthException catch (e) {
    // Handle FirebaseAuth exceptions
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No user found for $email. code 13'),
        ),
      );
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong password provided for that user. code 14'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error logging in please send us a feedback code 15'),
        ),
      );
    }
  } catch (e) {
    // Handle other exceptions
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error logging in please send us a feedback code 16'),
      ),
    );
  }
  return null;
}

// Function to resend email verification
Future<void> resendEmailVerification(User user, context) async {
  try {
    await user.sendEmailVerification();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification email sent. Please check your inbox.  code 17'),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error sending verification email. Please try again.  code 18'),
      ),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error signing out please send us a feedback code 19'),
      ),
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
          // Navigate to user info screen to complete registration
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CompleteRegistrationPage()));
          return null;
        }
        // Email exists, proceed with sign-in
        // Dismiss loading alert
        scaffoldMessenger.hideCurrentSnackBar();
        // Navigate to home screen after successful login
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RedirectLogin()),
        );
      }
    }
  } catch (e) {
    // Handle exceptions
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Error signing in with Google. Please try again later.'),
      ),
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
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Facebook. Please try again.'),
        ),
      );
    }
  } catch (e) {
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Error signing in with Facebook. Please try again later.'),
      ),
    );
  }
}
