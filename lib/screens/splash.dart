import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/screens/after_splash.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Internet'),
            content: const Text('Please check your internet connection and try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      await Future.delayed(const Duration(milliseconds: 200));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AfterSplash()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage(ImagePaths().verticalLogo),
          width: 150,
          height: 150,  
        ),
      ),
    );
  }
}
