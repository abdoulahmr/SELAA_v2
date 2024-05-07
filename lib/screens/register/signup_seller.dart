import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:selaa/backend-functions/auth.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/screens/register/login.dart';
import 'package:selaa/screens/register/pre_register.dart';

class SignUpSeller extends StatefulWidget {
  const SignUpSeller({Key? key, required this.nif}) : super(key: key);
  final int nif;

  @override
  State<SignUpSeller> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpSeller> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _isChecked = false;
  Color color = Colors.black;

  void checkInputs(context) {
    if (_isChecked == true) {
      if (_email.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email is empty'),
          ),
        );
      } else if (_firstname.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('First name is empty'),
          ),
        );
      } else if (_lastname.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Last name is empty'),
          ),
        );
      } else if (_password.text != _confirmPassword.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match!'),
          ),
        );
      } else {
        registerWithEmailPassword(
          email: _email.text,
          password: _password.text,
          firstname: _firstname.text,
          lastname: _lastname.text,
          accountType: "seller",
          nif: widget.nif,
          context: context,
        );
      }
    } else {
      setState(() {
        color = Colors.red;
      });
    }
  }

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
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 40, left: 30),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PreRegister()));
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 35, left: 30, right: 30),
                  child: const Text(
                    "Hello ! Register and start selling",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF415B5B)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: TextFormField(
                    controller: _firstname,
                    decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: const TextStyle(
                          color: Color(0xFF415B5B),
                        ),
                        hintText: 'seller1',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF415B5B)))),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, left: 30, right: 30),
                  child: TextFormField(
                    controller: _lastname,
                    decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: const TextStyle(
                          color: Color(0xFF415B5B),
                        ),
                        hintText: 'seller1',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF415B5B)))),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, left: 30, right: 30),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    decoration: InputDecoration(
                        labelText: 'Email',
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
                  margin: const EdgeInsets.only(top: 5, left: 30, right: 30),
                  child: TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password',
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
                Container(
                  margin: const EdgeInsets.only(top: 5, left: 30, right: 30),
                  child: TextFormField(
                    controller: _confirmPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Confirm password',
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
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      key: const Key("checkbox"),
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    Text(
                      key: const Key('Text'),
                      'I agree to the terms and conditions',
                      style: TextStyle(
                        fontSize: 16,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    checkInputs(context);
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width * 0.85,
                          MediaQuery.of(context).size.height * 0.06),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF415B5B)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(color: Color(0xFF415B5B)),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text(
                        " Login Now",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors().secondaryColor,
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
