// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'package:selaa/screens/seller/user_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


// function to add a poste
Future<void> addProduct(
  String category,
  String type,
  String selling,
  String price,
  String location,
  String description,
  List<XFile> images,
  int quantity,
  context,
) async {
  try {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Loading',
      text: 'Please wait...',
    );
    // Reference to the Firestore collection
    CollectionReference<Map<String, dynamic>> postsCollection =
        FirebaseFirestore.instance.collection('products');
    // Reference to the Firebase Storage bucket
    Reference storageRef =
        FirebaseStorage.instance.ref().child('poste_images');
    // List to store image download URLs
    List<String> imageUrls = [];
    // Upload each image to Firebase Storage
    for (XFile image in images) {
      File file = File(image.path);
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference imageRef = storageRef.child(imageName);
      await imageRef.putFile(file);
      String imageUrl = await imageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }
    // Create a map with post data
    Map<String, dynamic> postData = {
      'sellerID': FirebaseAuth.instance.currentUser!.uid,
      'category': category,
      'type': type,
      'title': selling,
      'price': price,
      'location': location,
      'description': description,
      'imageUrls': imageUrls,
      'minQuantity': quantity,
      'createdAt': DateTime.now(),
    };
    // Add the post data to Firestore and get the document reference
    DocumentReference<Map<String, dynamic>> documentReference =
        await postsCollection.add(postData);
    // Get the productID (document ID) from the reference
    String productID = documentReference.id;
    // Update the document with the productID
    await documentReference.update({'productID': productID});
    // Dismiss loading alert
    Navigator.pop(context);
    // Show success alert
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Post added successfully!',
    );
    // Navigate to home screen after adding post
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserPage()),
    );
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 3-1-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

// Function to delete poste and associated images
Future<void> deletePoste(String productID, context) async {
  try {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Loading',
      text: 'Please wait...',
    );
    // Retrieve associated image URLs from Firestore
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('user').doc(productID).get();
    if (documentSnapshot.exists) {
      final List<dynamic> imageUrls = documentSnapshot.data()?['imageUrls'] ?? [];
      // Delete associated images from Firebase Storage
      for (final String imageUrl in imageUrls) {
        final Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await imageRef.delete();
      }
    }
    // Delete poste from Firestore
    await FirebaseFirestore.instance.collection('user').doc(productID).delete();
    Navigator.pop(context);
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Post deleted successfully!',
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserPage()),
    );
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 3-2-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

// add to cart
Future<void> addItemToCart(
  String sellerID, 
  String productID, 
  int quantityValue, 
  String price, 
  context
) async {

  User? user = FirebaseAuth.instance.currentUser;
  int totalPrice = int.parse(price) * quantityValue;
  if (user != null) {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid)
        .collection("cart").doc().set({
          'seller': FirebaseFirestore.instance.collection('users').doc(sellerID),
          'buyer': FirebaseFirestore.instance.collection('users').doc(user.uid),
          'product': FirebaseFirestore.instance.collection('products').doc(productID),
          'quantity': quantityValue,
          'totalPrice': totalPrice,
        });
      Navigator.pop(context);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 3-3-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}

// calculate total price
Future<double> calculateTotalPrice(context) async {
  User? user = FirebaseAuth.instance.currentUser;
  double total = 0;
  if (user != null) {
    try {
      // Fetch user cart items from Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .collection('cart')
              .get();
      // Extract the data from the documents in the query snapshot
      List<Map<String, dynamic>> userCart =
          querySnapshot.docs.map((doc) => doc.data()).toList();
      // Calculate the total price
      for (int i = 0; i < userCart.length; i++) {
        // Ensure that the 'totalPrice' field is present and non-null
        if (userCart[i]['totalPrice'] != null) {
          total += int.parse(userCart[i]['totalPrice'].toString());
        }
      }
    } catch (error) {
      // Handle any errors that may occur during the process
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 3-4-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  } else {
    // Handle case when the user is null
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 3-4-2",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  return total;
}

// Function to delete item from cart
Future<void> deleteItemFromCart(context) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    // Fetch items to delete from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection('cart')
        .get();
     WriteBatch batch = FirebaseFirestore.instance.batch();
     for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 3-6-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

// pass an order
Future<void> saveOrder(
  List<Map<String, dynamic>> orderDetails,
  String orderID,
  bool deliveryOption,
  String date,
  context
) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 3-7-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return;
  }
  try{
    // Save order for the buyer
    await FirebaseFirestore.instance.collection('users')
        .doc(user.uid)
        .collection("orders")
        .add({
          "orderId": orderID,
          "deliveryOption": deliveryOption,
          "date": date,
          "status": "Pending"
        });
    
    // Save order for each seller
    Set<String> sellerIds = <String>{};
    for (var orderDetail in orderDetails) {
      String sellerID = orderDetail['product']['sellerID'];
      // Check if an order for the same seller already exists
      if (!sellerIds.contains(sellerID)) {
        await FirebaseFirestore.instance.collection('users')
            .doc(sellerID)
            .collection("orders")
            .add({
              "orderID": orderID,
              "buyer": FirebaseFirestore.instance.collection('users').doc(user.uid),
              "deliveryOption": deliveryOption,
              "date": date,
              "status": "Pending"
            });
        sellerIds.add(sellerID);
      }
    }
  } catch(e){
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 3-7-2",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

// save items in orders
Future<void> saveItemsInOrder(
  List<Map<String, dynamic>> items,
  String orderID) async {
  try {
    // Save items in the order
    for(var t in items) {
      FirebaseFirestore.instance.collection('orders')
        .add({
          "orderID": orderID,
          "product": FirebaseFirestore.instance.collection('products').doc(t["product"]["productID"]),
          "quantity": t["quantity"],
        });
    }
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 3-8-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    
  }
}


// Future function to load buyer's orders
Future<List<Map<String, dynamic>>> loadBuyerOrders(context) async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    // Get the orders collection for the current user
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('orders')
      .get();
    // Return a list of order data
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } catch (e) {
    // Handle errors
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 3-9-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return []; // Return an empty list if there's an error
  }
}


// Function to calculate total price of an order
Future<double> calculateOrderTotalPrice(List<Map<String, dynamic>> items, BuildContext context) async {
  // Initialize total price
  double total = 0;
  // Iterate through items and calculate total price
  for(int i = 0; i < items.length; i++){
    total = total + (items[i]['unitPrice']*items[i]['quantity']);
  }
  // Return the total price
  return total;
}

// add product rating
Future<void> addProductRating(
  String productID,
  double rating,
  context
) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      // Add the rating and review to the product document
      await FirebaseFirestore.instance.collection('products').doc(productID).collection('ratings').doc(user.uid).set({
        'rating': rating,
        'buyer':  FirebaseFirestore.instance.collection('users').doc(user.uid),
        'createdAt': DateTime.now(),
      });
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 3-10-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}

// add product rating
Future<void> addProductReview(
  String productID,
  String review,
  context
) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      // Add the rating and review to the product document
      await FirebaseFirestore.instance.collection('products').doc(productID).collection('reviews').doc(user.uid).set({
        'review': review,
        'buyer': FirebaseFirestore.instance.collection('users').doc(user.uid),
        'createdAt': DateTime.now(),
      });
    } catch (error) {
      // Handle errors
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 3-11-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}

// calculate average rating
double calculateAverageRating(List<Map<String, dynamic>> reviews) {
  if (reviews.isNotEmpty) {
    double totalRating = 0;
    for (var review in reviews) {
      totalRating += review['rating'];
    }
    return totalRating / reviews.length;
  } else {
    return 0;
  }
}

// request delivery
Future<void> requestDelivery(String agentID,LatLng position, String orderID)async{
  User? user = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance.collection('requests')
    .doc().set({
    'location': GeoPoint(position.latitude, position.longitude),
    'seller': user!.uid,
    'createdAt': DateTime.now(),
    'status': 'pending',
    'orderID': orderID,
    'agentID': agentID
  });
}