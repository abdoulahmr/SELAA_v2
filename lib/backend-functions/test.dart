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

void saveProducts() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference docRef = firestore.collection('products').doc();
  String docId = docRef.id; 

  await docRef.set({
    'productID': docId,
    'category': 'Xdk6BS0tiQjCgCNEEORK',
    'createdAt': Timestamp.now(),
    'imageUrls': [
      'https://source.unsplash.com/random/?product',
      'https://source.unsplash.com/random/?product',
      'https://source.unsplash.com/random/?product'
    ],
    'location': 'Algiers - Bab El Oued',
    'minQuantity': 80,
    'price': '700',
    'sellerID': 'iwBX09tcVOXXiqceN1A9d5Cm8r92',
    'title': 'Cozy Hoodie',
    'description': 'Stay warm and cozy with this stylish hoodie.',
  });
  
  print('Document with ID $docId saved successfully');
}

