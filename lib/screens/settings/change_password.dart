import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/account_settings.dart';
import 'package:selaa/backend-functions/links.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void checkInput(context) {
    if (_currentPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your current password')),
      );
    } else if (_newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your new password')),
      );
    } else if (_confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please re-enter your new password')),
      );
    } else if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated')),
      );
    }
    updatePassword(_currentPasswordController.text, _newPasswordController.text, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
        backgroundColor: AppColors().primaryColor,
      ),
      body: PopScope(
        canPop: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter your current password',
                  labelStyle: const TextStyle(
                    color: Color(0xFF415B5B),
                  ),  
                  hintText: '********',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF415B5B))
                  )
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _newPasswordController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Enter your new password',
                  labelStyle: const TextStyle(
                    color: Color(0xFF415B5B),
                  ),  
                  hintText: '********',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF415B5B))
                  )
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _confirmPasswordController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Renter your new password',
                  labelStyle: const TextStyle(
                    color: Color(0xFF415B5B),
                  ),  
                  hintText: '********',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF415B5B))
                  )
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width*0.85, MediaQuery.of(context).size.height*0.06),
                  ),
                  backgroundColor:
                    MaterialStateProperty.all(AppColors().primaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: const BorderSide(color: Color(0xFF415B5B)),
                    ),
                  ),
                ),
                onPressed: (){
                  checkInput(context);
                },
                child: const Text('Update Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
