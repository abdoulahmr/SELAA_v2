import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void saveData() async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create user accounts for each user
    await auth.createUserWithEmailAndPassword(
      email: 'test-seller-01@gmail.com',
      password: '123456789',
    );

    await auth.createUserWithEmailAndPassword(
      email: 'test-seller-02@gmail.com',
      password: '123456789',
    );

    await auth.createUserWithEmailAndPassword(
      email: 'test-seller-03@gmail.com',
      password: '123456789',
    );

    // Add user data to Firestore
    await firestore.collection('users').add({
      'firstname': 'Sarah',
      'address': 'Algiers - Bab El Oued',
      'accountType': 'seller',
      'bio': 'Fashion designer',
      'check': true,
      'lastname': 'Smith',
      'profilePicture': 'https://source.unsplash.com/random/?profile',
      'password': '123456789',
      'phoneNumber': '0550123456',
      'balance': 15000,
      'email': 'test-seller-01@gmail.com',
      'username': 'sarah_designs'
    });

    await firestore.collection('users').add({
      'firstname': 'Ahmed',
      'address': 'Oran - Sidi El Houari',
      'accountType': 'seller',
      'bio': 'Electronics retailer',
      'check': true,
      'lastname': 'Khaled',
      'profilePicture': 'https://source.unsplash.com/random/?profile',
      'password': '123456789',
      'phoneNumber': '0550555555',
      'balance': 23000,
      'email': 'test-seller-02@gmail.com',
      'username': 'ahmed_electronics'
    });

    await firestore.collection('users').add({
      'firstname': 'Lina',
      'address': 'Algiers - Bab El Oued',
      'accountType': 'seller',
      'bio': 'Fashion designer',
      'check': true,
      'lastname': 'Benali',
      'profilePicture': 'https://source.unsplash.com/random/?profile',
      'password': '123456789',
      'phoneNumber': '0550666666',
      'balance': 15000,
      'email': 'test-seller-03@gmail.com',
      'username': 'lina_fashion'
    });

    print('Data saved successfully');
  } catch (e) {
    print('Error saving data: $e');
  }
}
