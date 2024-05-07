// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/screens/register/signup_buyer.dart';
import 'package:selaa/screens/register/signup_seller.dart';

class CheckNifScreen extends StatefulWidget {
  const CheckNifScreen({Key? key, required this.accountType}) : super(key: key);
  final String accountType;

  @override
  State<CheckNifScreen> createState() => _CheckNifScreenState();
}

class _CheckNifScreenState extends State<CheckNifScreen> {
  TextEditingController nifController = TextEditingController();
  bool isLoading = false;
  bool nifExist = false;

  Future<void> fetchHtmlContent(int nif) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(Uri.parse('https://nif.mfdgi.gov.dz/nif.asp?Nif=$nif'));
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          nifExist = response.body.contains("Il existe");
        });
        if (nifExist) {
          if(widget.accountType == 'buyer') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpBuyer(nif: nif)));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpSeller(nif: nif)));
          }
        } else {
          showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                title: const Text('NIF Not Found'),
                content: const Text('NIF Not Found'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: const Text('OK')
                  ),
                ],
              );
            },
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context, 
          builder: (context) {
            return AlertDialog(
              icon: const Icon(Icons.error),
              title: const Text('NIF Not Found'),
              content: const Text('NIF Not Found'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: const Text('OK')
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            icon: const Icon(Icons.error),
            title: const Text('NIF Not Found'),
            content: const Text('NIF Not Found'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                }, 
                child: const Text('OK')
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check NIF'),
      ),
      body: isLoading 
      ? Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
      ) 
      :Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter NIF Code to Check NIF Existence",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors().primaryColor
              )
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nifController,
              decoration: const InputDecoration(
                labelText: 'NIF',
                hintText: 'Enter NIF',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                fixedSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width, 
                  MediaQuery.of(context).size.height*0.07),
                ),
                backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(  
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: AppColors().borderColor),
                  ),
                ),
              ),
              onPressed: () {
                fetchHtmlContent(int.tryParse(nifController.text) ?? 0);
              },
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
