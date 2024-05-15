import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/screens/guest/home_guest.dart';
import 'package:selaa/screens/register/choice_auth.dart';
import 'package:selaa/screens/register/login.dart';
import 'package:selaa/screens/settings/change_language.dart';
import 'package:selaa/screens/settings/report_bug.dart';

class GuestOptionMenue extends StatelessWidget {
  const GuestOptionMenue({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 50),
                height: MediaQuery.of(context).size.height * 0.1,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeGuest()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 40),
                      Icon(
                        Icons.home_outlined,
                        size: 40,
                        color: AppColors().primaryColor,
                      ),
                      const SizedBox(width: 40),
                      const Text(
                        "Home",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ChoiceAuthPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 40),
                      Icon(
                        Icons.person_add_outlined,
                        size: 40,
                        color: AppColors().primaryColor,
                      ),
                      const SizedBox(width: 40),
                      const Text(
                        "Create Account",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 40),
                      Icon(
                        Icons.login,
                        size: 40,
                        color: AppColors().primaryColor,
                      ),
                      const SizedBox(width: 40),
                      const Text(
                        "Sign In",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                height: MediaQuery.of(context).size.height * 0.1,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LanguageScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 40),
                      Icon(
                        Icons.language_outlined,
                        size: 40,
                        color: AppColors().primaryColor,
                      ),
                      const SizedBox(width: 40),
                      const Text(
                        "Language",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReportBugScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 40),
                      Icon(
                        Icons.bug_report_outlined,
                        size: 40,
                        color: AppColors().primaryColor,
                      ),
                      const SizedBox(width: 40),
                      const Text(
                        "Report a Bug",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 40),
                      Icon(
                        Icons.info_outline,
                        size: 40,
                        color: AppColors().primaryColor,
                      ),
                      const SizedBox(width: 40),
                      const Text(
                        "About Us",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
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