// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:selaa/screens/splash.dart';
import 'firebase_options.dart';
import 'package:selaa/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();

  static final GlobalKey<_MainState> mainStateKey = GlobalKey<_MainState>();

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MainState state = mainStateKey.currentState!;
    state.setLocale(newLocale);
  }
}

class _MainState extends State<Main> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: Main.mainStateKey,
      localizationsDelegates: const[
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      locale: _locale,
      debugShowCheckedModeBanner: false,
      home: const Splash()
    );
  }
}
