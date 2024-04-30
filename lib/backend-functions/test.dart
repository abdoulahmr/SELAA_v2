import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void saveData() async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').add({
      'vehiculeType': 'Truck',
      'firstname': 'John',
      'licencePlate': 'ABC123',
      'accountType': 'delivery',
      'lastLocation': GeoPoint(34.0522, -118.2437), // Example coordinates for Los Angeles
      'verified': true,
      'check': true,
      'driverLicenceNumber': 987654321,
      'lastname': 'Doe',
      'profilePicture': 'https://source.unsplash.com/random/?profile2',
      'phoneNumber': '1234567890',
      'balance': 100,
      'model': 'Ford F-150',
      'totalDistance': 500,
      'deliveryCount': 10,
      'fcmToken': 'fcmTokenValue2',
      'brand': 'Ford',
      'email': 'john.doe@example.com',
      'status': true
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

