// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:selaa/backend-functions/auth.dart';
import 'package:selaa/backend-functions/links.dart';

class CompleteRegistrationPage extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _shippingAddressController = TextEditingController();

  CompleteRegistrationPage({super.key});

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check if location permissions are granted
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    // Get the current position
    return await Geolocator.getCurrentPosition();
  }

  void _showLocationServiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text('Please enable location services to continue.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Open device location settings
                Geolocator.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveUserData(BuildContext context) async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog(context); // Show location service dialog
        return;
      }

      // Get the current position
      Position? position = await _getCurrentLocation();
      if (position != null) {
        final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'firstname': _firstNameController.text,
            'lastname': _lastNameController.text,
            'email': _emailController.text,
            'username': _usernameController.text,
            'phoneNumber': _phoneNumberController.text,
            'shippingAdress': 'Latitude: ${position.latitude}, Longitude: ${position.longitude}',
            'accountType': 'buyer',
            'balance': 0,
            'check': true
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User data saved successfully.'),
            ),
          );
          
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User not signed in.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error getting location. Please try again.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving user data.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complete Registration',
          style: TextStyle(color: AppColors().primaryColor),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: AppColors().primaryColor,
            ),
            onPressed: () async {
              signOut(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Enter your information:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: _shippingAddressController,
                decoration: InputDecoration(
                  labelText: 'Shipping Address',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.my_location),
                    onPressed: () async {
                      try{
                        Position? position = await _getCurrentLocation();
                        if (position != null) {
                        // Set the shipping address to the current location
                          _shippingAddressController.text = "Position got successfully";
                        } else {
                          // Handle error getting location
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error getting location. Please try again.'),
                            ),
                          );
                        }
                      }catch(e){
                        if(e == 'Location services are disabled.'){
                          _showLocationServiceDialog(context);
                        }
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text("Press on "),
                  Icon(Icons.my_location),
                  Text(" to get your current location"),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _saveUserData(context);
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width*0.85, MediaQuery.of(context).size.height*0.06),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(AppColors().primaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xFF415B5B)),
                    ),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
