import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:selaa/backend-functions/account_settings.dart';
import 'package:selaa/backend-functions/links.dart';
import 'login.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _email = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 50, left: 30),
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                },
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 150, left: 30, right: 30),
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E232C)),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top:30,left: 30, right: 30),
              child: const Text(
                "Don't worry! It occurs. Please enter the email address linked with your account.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF415B5B)
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top:30, left: 30, right: 30),
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
                    borderSide: BorderSide(color: Color(0xFF415B5B))
                  )
                ),
              ),
            ),
            const SizedBox(height: 50,),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 30),
              child: ElevatedButton(
                onPressed: () {
                  resetPassword(_email.text, context);
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
                  "Send Code",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 220,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Remember Password?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: const Text(
                    " Login",
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
    );
  }
}