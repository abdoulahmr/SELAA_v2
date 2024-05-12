import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';

class ReportBugScreen extends StatelessWidget {
  final TextEditingController _content = TextEditingController();
  
  ReportBugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report a bug'),
        backgroundColor: AppColors().secondaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const Text(
              'Please report any bugs you find in the app to the developer.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF415B5B),
              ),
            )
          ),
          Container(
            margin: const EdgeInsets.only(top: 100, left: 30, right: 30),
            child: TextFormField(
              controller: _content,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF415B5B))
                )
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(
                Size(
                  MediaQuery.of(context).size.width*0.85, 
                  MediaQuery.of(context).size.height*0.06
                ),
              ),
              backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(color: Color(0xFF415B5B)),
                ),
              ),
            ),
            onPressed: () {
              // Open email app with pre-filled email
            },
            child: const Text(
              'Report a bug',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}