import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/screens/settings/change_password.dart';
import 'package:selaa/screens/settings/phone_number.dart';
import 'package:selaa/screens/settings/shipping_adress.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Settings',style: TextStyle(color: Colors.white)),
                backgroundColor: AppColors().primaryColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back,color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddPhoneNumberPage()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        'Phone number',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ShippingAddressPage()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        'Shipping address',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.01,
                    color: const Color.fromARGB(255, 185, 185, 185),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
