import 'package:flutter/material.dart';
import 'package:selaa/main.dart';

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Selection'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Main.setLocale(context, const Locale("ar"));
              },
              child: Text('العربية'),
            ),
            ElevatedButton(
              onPressed: () {
                Main.setLocale(context, const Locale("en"));
              },
              child: Text('English'),
            ),
          ],
        ),
      ),
    );
  }
}
