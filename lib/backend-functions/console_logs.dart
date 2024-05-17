import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addLog(String log,String code) async {
  await Firebase.initializeApp();
  CollectionReference logs = FirebaseFirestore.instance.collection('logs');
  logs.add({
    'log': log, 
    'timestamp': DateTime.now(),
    'code': code  
  });
}