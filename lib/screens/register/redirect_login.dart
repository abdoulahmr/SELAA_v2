import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/auth.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/buyer/home_buyer.dart';
import 'package:selaa/screens/register/complete_info.dart';
import 'package:selaa/screens/seller/home_seller.dart';

class RedirectLogin extends StatefulWidget {
  const RedirectLogin({Key? key}) : super(key: key);

  @override
  State<RedirectLogin> createState() => _PreLoginState();
}

class _PreLoginState extends State<RedirectLogin> {
  Map<String, dynamic> _userDetails = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAccountDetails().then((data) {
      setState(() {
        _userDetails = data;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ElevatedButton(onPressed: (){
        print(_userDetails);
          signOut(context);
              }, child: Text("test")),

      // home: isLoading
      //     ? Scaffold(
      //         body: Center(
      //           child: Image(
      //             image: AssetImage(ImagePaths().verticalLogo),
      //             width: 150,
      //             height: 150,
      //           ),
      //         ),
      //       )
      //      : !_userDetails['check']
      //         ? CompleteRegistrationPage()
      //         : _userDetails['accountType'] == "buyer"
      //             ? const HomeBuyer()
      //             : _userDetails['accountType'] == "seller"
      //                 ? const HomeSeller()
      //                 : Container()
    );
  }
}