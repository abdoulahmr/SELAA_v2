import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/buyer/home_buyer.dart';
import 'package:selaa/screens/seller/home_seller.dart';

class RedirectLogin extends StatefulWidget {
  const RedirectLogin({Key? key}) : super(key: key);

  @override
  State<RedirectLogin> createState() => _PreLoginState();
}

class _PreLoginState extends State<RedirectLogin> {
  String userType = "none";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAccountType().then((String? data) {
      if (data != null) {
        setState(() {
          userType = data;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoading
          ? Scaffold(
            body: Center(
              child: Image(
                image: AssetImage(ImagePaths().verticalLogo),
                width: 150,
                height: 150,  
              ),
            ),
          )
          : userType == "buyer"
              ? const HomeBuyer()
              : userType == "seller"
                  ? const HomeSeller()
                  : Container(),
    );
  }
}
