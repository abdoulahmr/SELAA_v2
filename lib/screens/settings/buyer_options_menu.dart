import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/auth.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/screens/buyer/my_orders.dart';
import 'package:selaa/screens/register/redirect_login.dart';
import 'package:selaa/screens/settings/change_language.dart';
import 'package:selaa/screens/settings/report_bug.dart';
import 'package:selaa/screens/settings/settings_list.dart';

class BuyerOptionsMenu extends StatelessWidget {
  const BuyerOptionsMenu({super.key});

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
                          builder: (context) => const RedirectLogin()),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsList()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 40),
                      Icon(
                        Icons.settings_outlined,
                        size: 40,
                        color: AppColors().primaryColor,
                      ),
                      const SizedBox(width: 40),
                      const Text(
                        "Settings",
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
                        MaterialPageRoute(
                            builder: (context) => const MyOrdersPage()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 40),
                      Icon(
                        Icons.delivery_dining_outlined,
                        size: 40,
                        color: AppColors().primaryColor,
                      ),
                      const SizedBox(width: 40),
                      const Text(
                        "My Orders",
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
              Container(
                margin: const EdgeInsets.only(top: 50, bottom: 20),
                height: MediaQuery.of(context).size.height * 0.1,
                child: OutlinedButton(
                  onPressed: () {
                    signOut(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Row(
                    children: <Widget>[
                      SizedBox(width: 40),
                      Icon(
                        Icons.exit_to_app,
                        size: 40,
                        color: Colors.red,
                      ),
                      SizedBox(width: 40),
                      Text(
                        "Log out",
                        style: TextStyle(fontSize: 20, color: Colors.red),
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
