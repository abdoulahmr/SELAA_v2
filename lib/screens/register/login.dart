import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:selaa/backend-functions/auth.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/screens/register/signup_buyer.dart';
import 'pre_register.dart';
import 'forget_password.dart';

class Login extends StatelessWidget {
  Login({super.key});
  
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _LoginKey = GlobalKey<FormState>();

  void checkInputs(context){
    if(_email.text.isNotEmpty && _password.text.isNotEmpty){
      loginWithEmailPassword(_email.text,_password.text,context);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _LoginKey,
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 50, left: 30),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PreRegister()));
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50, left: 30, right: 30),
                  child: const Text(
                    "Welcome back! Glad to see you, Again !",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF415B5B)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100, left: 30, right: 30),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: 'Enter your email',
                      labelStyle: const TextStyle(
                        color: Color(0xFF415B5B),
                      ),  
                      hintText: 'ex : selaa@examle.org',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF415B5B)))),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Enter your password',
                      labelStyle: const TextStyle(
                        color: Color(0xFF415B5B),
                      ),  
                      hintText: '********',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF415B5B)))),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    checkInputs(context);
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
                    "Login",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 1,
                      color: Colors.black,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "or Register with",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 1,
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const FaIcon(FontAwesomeIcons.facebookF),
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
                                          signInWithFacebook(context,"buyer",ScaffoldMessenger.of(context));
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
                                          signInWithFacebook(context,"seller",ScaffoldMessenger.of(context));
                                        }
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        color: Colors.blue,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const FaIcon(FontAwesomeIcons.google),
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
                                          signInWithGoogle(context,"buyer",ScaffoldMessenger.of(context));
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
                                          signInWithGoogle(context,"seller",ScaffoldMessenger.of(context));
                                        }
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        color: Colors.red,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const FaIcon(FontAwesomeIcons.apple),
                        onPressed: () {},
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpBuyer()));
                      },
                      child: const Text(
                        " Sign Up",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF008080),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}