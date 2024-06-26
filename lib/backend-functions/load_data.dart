// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:selaa/backend-functions/console_logs.dart';

// Function to get account type (buyer,seller) and check for infos
Future<Map<String, dynamic>> loadAccountDetails() async {
  try {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;
    // Retrieve the document snapshot from Firestore using the user's UID
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    // Check if the document exists in the 'users' collection
    if (documentSnapshot.exists) {
      // Return the 'accountType' field from the document and a check value
      return {
        'accountType': documentSnapshot.data()!['accountType'],
        'check': documentSnapshot.data()!['check'], // Add your check value here
      };
    } else {
      // Return null if the document does not exist
      return {
        'accountType': null,
        'check': 'value', // Add your check value here
      };
    }
  } catch (e) {
    // Handle exceptions and return null in case of an error
    return {
      'accountType': null,
      'check': 'value', // Add your check value here
    };
  }
}

// load user information
Future<List<Map<String, dynamic>>> loadUserInfo(context) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists) {
        // Return a list containing user data
        return [documentSnapshot.data()!];
      } else {
        // Handle case when document does not exist
        Fluttertoast.showToast(
          msg: "Error logging in please send us a feedback code 4-1-1",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        addLog("error", '3-2-1');
        return [];
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 4-2-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      addLog(error.toString(), '3-2-2');
      return [];
    }
  } else {
    // Handle case when user is null
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error please send us a feedback  code 30'),
      ),
    );
    return [];
  }
}

Future loadProfilePicture(context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        final data = snapshot.data();
        return data?['profilePicture'];
      } else {
        Fluttertoast.showToast(
          msg: "Error logging in please send us a feedback code 4-3-1",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return '';
      }
    } else {
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 4-3-2",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return '';   
    }
  }

// Load seller information
Future<List<Map<String, dynamic>>> loadSellerInfo(uid, context) async {
  try {
    // Fetch seller data from Firestore
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      // Return a list containing seller data
      return [documentSnapshot.data()!];
    } else {
      // Handle case when document does not exist
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 4-4-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return [];
    }
  } catch (error) {
    // Handle errors
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-4-2",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return [];
  }
}

// Load user postes
Future<List<Map<String, dynamic>>> fetchProducts({String? sellerID}) async {
  List<Map<String, dynamic>> result = [];
  User? user = FirebaseAuth.instance.currentUser;
  List<DocumentSnapshot> products = []; // Define products list here

  try {
    // Fetch products
    if (sellerID == null) {
      QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('sellerID', isEqualTo: user?.uid)
          .get();
      products = productsSnapshot.docs.toList(); // Assign products to the defined list
    } else {
      QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('sellerID', isEqualTo: sellerID)
          .get();
      products = productsSnapshot.docs.toList(); // Assign products to the defined list
    }

    // Fetch categories
    Map<String, String> categoryMap = {};
    QuerySnapshot categoriesSnapshot = await FirebaseFirestore.instance
        .collection('productCategory')
        .get();
    for (var categoryDoc in categoriesSnapshot.docs) {
      categoryMap[categoryDoc.id] = categoryDoc['name'];
    }

    // Combine product and category information
    for (var product in products) {
      Map<String, dynamic> productData = product.data() as Map<String, dynamic>;
      String categoryId = productData['category'];

      // Check if category exists
      if (categoryMap.containsKey(categoryId)) {
        productData['categoryName'] = categoryMap[categoryId];
        result.add(productData);
      }
    }
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-5-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  return result;
}

// load poste information
Future<List<Map<String, dynamic>>> loadPosteInfo(String productID, context) async {
  List<Map<String, dynamic>> result = [];
  try {
    // Fetch product data from Firestore
    DocumentSnapshot<Map<String, dynamic>> productSnapshot =
      await FirebaseFirestore.instance.collection('products')
        .doc(productID)
        .get();

    if (productSnapshot.exists) {
      // Fetch category data using the category ID from the product
      String categoryID = productSnapshot.data()?['category'];
      DocumentSnapshot<Map<String, dynamic>> categorySnapshot =
          await FirebaseFirestore.instance.collection('productCategory').doc(categoryID).get();

      // Add product and category data to the result list
      result.add(productSnapshot.data()!);
      result.add(categorySnapshot.data()!);

      return result;
    } else {
      // Handle case when product document does not exist
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 4-6-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return [];
    }
  } catch (error) {
    // Handle errors
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-6-2",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(error.toString(), '4-6-2');
    return [];
  }
}

// Load all postes
Future<List<Map<String, dynamic>>> loadAllPostes(context) async {
  try {
    // Fetch poste data from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('products')
            .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  } catch (error) {
    // Handle errors
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-7-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(error.toString(), '4-6-2');
    return [];
  }
}

Future<List<Map<String, dynamic>>> loadCartItems(context) async {
  User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> userCart = [];
  if (user != null) {
    try {
      // Fetch user cart items from Firestore
      QuerySnapshot<Map<String, dynamic>> cartSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .get();

      // Iterate over the cart items and construct a list
      for (var cartItem in cartSnapshot.docs) {
        // Get the referenced documents
        DocumentSnapshot<Map<String, dynamic>> buyerDocSnapshot = await cartItem['buyer'].get();
        DocumentSnapshot<Map<String, dynamic>> productDocSnapshot = await cartItem['product'].get();
        DocumentSnapshot<Map<String, dynamic>> sellerDocSnapshot = await cartItem['seller'].get();

        // Construct the cart item data
        userCart.add({
          'buyer': buyerDocSnapshot.data(),
          'product': productDocSnapshot.data(),
          'quantity': cartItem['quantity'],
          'seller': sellerDocSnapshot.data(),
          'totalPrice': cartItem['totalPrice'],
        });
      }
    } catch (error) {
      // Handle any errors that may occur during the process
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 4-8-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      addLog(error.toString(), '4-8-1');
    }
  } else {
    // Handle case when user is null
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-8-2",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  return userCart;
}

// Function to get user shipping address
Future<String> loadUserShippingAddress(context) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists) {
        String shippingAddress = (documentSnapshot.data() as Map<String, dynamic>)['shippingAddress'] ?? '';
        return shippingAddress;
      } else {
        Fluttertoast.showToast(
          msg: "Error logging in please send us a feedback code 4-9-1",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return 'User document does not exist.';
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 4-9-2",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return 'Error getting user shipping address.';
    }
  } else {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-9-3",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return 'User not authenticated.';
  }
}

// Function to get user phone number
Future<String> loadUserPhoneNumber(context) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (documentSnapshot.exists) {
        String phoneNumber = (documentSnapshot.data() as Map<String, dynamic>)['phoneNumber'] ?? '';
        return phoneNumber;
      } else {
        Fluttertoast.showToast(
          msg: "Error logging in please send us a feedback code 4-10-1",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return 'User document does not exist.';
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 4-10-2",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return 'Error getting user phone number.';
    }
  } else {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-10-3",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return 'User not authenticated.';
  }
}

// load buyer orders
Future<List<Map<String, dynamic>>> loadBuyerOrders(context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('orders')
      .get();

    List<Map<String, dynamic>> orders = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> orderData = {
        'orderId': doc['orderId'],
        'date': doc['date'],
        'status': doc['status']
      };
      if (!orders.any((order) => order['orderId'] == doc['orderId'])) {
        orders.add(orderData);
      }
    }
    return orders;
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-11-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(e.toString(), '4-11-1');
    return []; 
  }
}

// load seller orders
Future<List<Map<String, dynamic>>> loadSellerOrders(context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('orders')
      .get();

    List<Map<String, dynamic>> orders = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      // Get the buyer reference
      DocumentReference<Map<String, dynamic>> buyerRef = data['buyer'];
      // Load the buyer document
      DocumentSnapshot<Map<String, dynamic>> buyerSnapshot = await buyerRef.get();
      // Get the buyer data
      Map<String, dynamic>? buyerData = buyerSnapshot.data();
      // Add the buyer data to the order item data
      data['buyer'] = {
        'firstname': buyerData!['firstname'],
        'lastname': buyerData['lastname'],
        'buyerID': buyerSnapshot.id // Add document id here,
      };
      orders.add(data);
    }
    return orders;
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-12-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(e.toString(), '4-12-1');
    return []; 
  }
}


// load order items
Future<List<Map<String, dynamic>>> loadOrderInfo(String orderID) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('orders')
        .where('orderId', isEqualTo: orderID)
        .get();
    
    List<Map<String, dynamic>> documentsData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return documentsData;
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-24-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );    
    addLog(e.toString(), '4-24-1');
    return [];
  }
}


// load order items
Future<List<Map<String, dynamic>>> loadOrderItems(String orderID) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('orderID', isEqualTo: orderID)
        .get();
    
    List<Map<String, dynamic>> documentsData = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      // Get the product reference
      DocumentReference<Map<String, dynamic>> productRef = data['product'];
      // Load the product document
      DocumentSnapshot<Map<String, dynamic>> productSnapshot = await productRef.get();
      // Get the product data
      Map<String, dynamic>? productData = productSnapshot.data();
      // Add the product data to the order item data
      data['product'] = productData;
      documentsData.add(data);
    }

    return documentsData;
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-13-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );    
    addLog(e.toString(), '4-13-1');
    return [];
  }
}

// load user name from uid
Future<String> loadUserName(context, uid) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid) 
        .get();
    if (documentSnapshot.exists) {
      return documentSnapshot.data()!['firstname']+" "+documentSnapshot.data()!['lastname'];
    } else {
      return 'User not found';
    }
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-14-2",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(e.toString(), '4-14-2');
    return 'Error getting user name';
  }
}

// load buyer information
Future<Map<String, dynamic>> loadBuyerInfo(BuildContext context, String buyerId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(buyerId)
        .get();
    return documentSnapshot.data() ?? {};
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-15-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(error.toString(), '4-14-2');
    return {};
  }
}

// load seller home page information
//// load seller orders info
Future<Map<String, dynamic>> loadSellerOrdersInfo(BuildContext context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    // Keep track of unique orderIds
    Set<String> uniqueOrderIds = {};
    // Count the number of pending, on the way, delivered, and canceled orders
    QuerySnapshot<Map<String, dynamic>> ordersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('orders')
        .get();
    
    // Filter out duplicate orders with the same orderId
    List<QueryDocumentSnapshot<Map<String, dynamic>>> uniqueOrders = ordersSnapshot.docs.where((doc) {
      if (uniqueOrderIds.contains(doc['orderID'])) {
        return false;
      } else {
        uniqueOrderIds.add(doc['orderID']);
        return true;
      }
    }).toList();

    int pendingOrders = uniqueOrders.where((doc) => doc['status'] == 'pending').length;
    int onTheWayOrders = uniqueOrders.where((doc) => doc['status'] == 'delivering').length;
    int deliveredOrders = uniqueOrders.where((doc) => doc['status'] == 'delivered').length;
    int canceledOrders = uniqueOrders.where((doc) => doc['status'] == 'canceled').length;
    
    return {
      'pendingOrders': pendingOrders,
      'onTheWayOrders': onTheWayOrders,
      'deliveredOrders': deliveredOrders,
      'canceledOrders': canceledOrders,
    };
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-16-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(error.toString(), '4-16-2');
    return {};
  }
}

//// load seller products info
Future<Map<String, dynamic>> loadSellerProductsInfo(BuildContext context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    // Fetch seller products from Firestore
    QuerySnapshot<Map<String, dynamic>> productsSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('sellerID', isEqualTo: user!.uid)
        .get();

    // Keep track of unique categories
    Set<String> uniqueCategories = {};
    for (var doc in productsSnapshot.docs) {
      uniqueCategories.add(doc['category']);
    }

    // Count the number of products and categories
    int totalProducts = productsSnapshot.docs.length;
    int totalCategories = uniqueCategories.length;

    return {
      'totalProducts': totalProducts,
      'totalCategories': totalCategories,
    };
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-17-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(error.toString(), '4-17-2');
    return {};
  }
}

//// load seller balance
Future<String> loadSellerBalanceInfo(BuildContext context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    // Fetch seller balance from Firestore
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data()!['balance'].toString();
    } else {
      Fluttertoast.showToast(
        msg: "Error logging in please send us a feedback code 4-18-1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return "0";
    }
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-18-2",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(error.toString(), '4-18-2');
    return "0";
  }
}

// load products categorys
Future<List<Map<String, dynamic>>> loadProductsCategorys(context) async {
  try {
    // Fetch products categorys from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('productCategory')
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-19-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(error.toString(), '4-19-1');
    return [];
  }
}

// load products by category
Future<List<Map<String, dynamic>>> loadProductsByCategory(String categoryID, context) async {
  try {
    // Fetch products from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: categoryID)
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-20-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(error.toString(), '4-20-1');
    return [];
  }
}

Future<List<Map<String, dynamic>>> loadProductsCategories(context) async {
  try {
    // Fetch products categories from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('productCategory')
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  } catch (error) {
    // Handle any errors
    Fluttertoast.showToast(
      msg: "Error logging in please send us a feedback code 4-21-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(error.toString(), '4-21-1');
    return []; // Return an empty list in case of error
  }
}

// load product review
Future<List<Map<String, dynamic>>> loadProductReviews(BuildContext context, String productID) async {
  try {      
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      .collection('products')
      .doc(productID)
      .collection('reviews')
      .get();
    List<Map<String, dynamic>> reviews = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      Map<String, dynamic> reviewData = doc.data();
      // Check if 'buyer' field is not null
      if (reviewData['buyer'] != null) {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot = await reviewData['buyer'].get();
        Map<String, dynamic> userData = userSnapshot.data() ?? {};
        reviewData['buyerInfo'] = userData;
        reviews.add(reviewData);
      }
    }
    return reviews;
  } catch (error) {
    // Handle any errors
    Fluttertoast.showToast(
      msg: "Error please send us a feedback code 4-22-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(error.toString(), '4-22-1');
    return []; // Return an empty list in case of error
  }
}

// load product rating
Future<List<Map<String, dynamic>>> loadProductRating(context, String productID) async {
  try {
  // Fetch product reviews from Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      .collection('products')
      .doc(productID)
      .collection('ratings')
      .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  } catch (error) {
  // Handle any errors
    Fluttertoast.showToast(
      msg: "Error please send us a feedback code 4-23-1",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    addLog(error.toString(), '4-23-1');
    return []; // Return 0 in case of error
  }
}

// load stores
Future<List<Map<String, dynamic>>> loadStores() async {
  try {
    // Get a reference to the collection
    QuerySnapshot<Map<String, dynamic>> storesSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('accountType', isEqualTo: 'seller')
            .get();

    // Convert the documents to a list of maps containing document data and ID
    return storesSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'data': doc.data(),
      };
    }).toList();
  } catch (error) {
    // Handle any errors
    addLog(error.toString(), '4-15-1');
    return [];
  }
}

// load agents
Future<List<Map<String, dynamic>>> loadAgents() async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('status', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      // Get data as a new map
      Map<String, dynamic> data = doc.data();
      // Add document ID to the map
      data['agentId'] = doc.id;
      return data;
    }).toList();
  } catch (error) {
    // Handle any errors
    addLog(error.toString(), '4-16-1');
    return [];
  }
}

// load request status stream
Stream<List<dynamic>> getRequestStatusStream(String orderID) {
  try{
    return FirebaseFirestore.instance
    .collection('requests')
    .where("orderID", isEqualTo: orderID)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  } catch (error) {
    addLog(error.toString(), '4-17-1');
    return Stream.value([]);
  }
}

// load request status
Future<List<Map<String, dynamic>>> loadRequestStatus(String agentID, String orderID) async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(agentID)
      .collection("request")
      .where('orderID', isEqualTo: orderID)
      .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  } catch (error) {
    addLog(error.toString(), '4-18-1');
    return [];
  }
}

// load offer
Future<List<Map<String, dynamic>>> loadSellerOffer(context) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('offer')
        .where('seller', isEqualTo: user?.uid)
        .get();

    List<Map<String, dynamic>> offers = [];
    for (var doc in snapshot.docs) {
      DocumentReference<Map<String, dynamic>> productRef = doc.data()['product'];
      DocumentSnapshot<Map<String, dynamic>> productSnapshot = await productRef.get();
      
      Map<String, dynamic> offerData = doc.data();
      offerData['product'] = productSnapshot.data();
      offerData['id'] = doc.id; // Add the document ID to the offerData map
      offers.add(offerData);
    }

    return offers;
  } catch (error) {
    addLog(error.toString(), '4-19-1');
    return [];
  }
}

// load all offers
Future<List<Map<String, dynamic>>> loadOffers(context) async{
  try{
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('offer')
        .get();

    List<Map<String, dynamic>> offers = [];
    for (var doc in snapshot.docs) {
      DocumentReference<Map<String, dynamic>> productRef = doc.data()['product'];
      DocumentSnapshot<Map<String, dynamic>> productSnapshot = await productRef.get();
      
      Map<String, dynamic> offerData = doc.data();
      offerData['product'] = productSnapshot.data();
      offerData['id'] = doc.id;
      offers.add(offerData);
    }
    return offers;
  }catch(e){
    addLog(e.toString(), '4-20-1');
    return [];
  }
}