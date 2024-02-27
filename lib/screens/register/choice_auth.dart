// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/generated/l10n.dart';
import 'package:selaa/screens/register/signup_seller.dart';
import 'login.dart';
import 'signup_buyer.dart';

class ChoiceAuthPage extends StatelessWidget {
  const ChoiceAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height -
                      (MediaQuery.of(context).size.height * 0.3),
                  decoration: BoxDecoration(
                    color: AppColors().secondaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60.0),
                      bottomRight: Radius.circular(60.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      const Image(
                        image: AssetImage(
                          'assets/images/1-removebg-preview-removebg-preview-removebg-preview.png',
                        ),
                        width: 250,
                        height: 250,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 70.0, bottom: 20.0, left: 20.0, right: 20.0),
                        child: Text(
                          S.of(context).theAlgerianCommercialNetwork,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => Login()));
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      fixedSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width*0.8, MediaQuery.of(context).size.height*0.07),
                      ),
                      backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    child: Text(
                      S.of(context).login,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ElevatedButton(
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    fixedSize: MaterialStateProperty.all(
                                      Size(MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.05),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(const Color(0xFFFFFFFF)),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(  
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        side: const BorderSide(color: Color(0xFF415B5B)),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpBuyer()));
                                  },
                                  child: const Text(
                                    'Register as a Buyer',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF415B5B),
                                    )
                                  )
                                ),
                                const SizedBox(height: 20,),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    fixedSize: MaterialStateProperty.all(
                                      Size(MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.05),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(const Color(0xFFFFFFFF)),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(  
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        side: const BorderSide(color: Color(0xFF415B5B)),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Register as a Seller',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF415B5B),
                                    )
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpSeller()));
                                  }
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    fixedSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width*0.8, MediaQuery.of(context).size.height*0.07),
                    ),
                    backgroundColor: MaterialStateProperty.all(const Color(0xFFF4F4F4)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(color: Color(0xFF415B5B)),
                      ),
                    ),
                  ),
                  child: Text(
                    S.of(context).register,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF001A1A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}