import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/seller/order_delivery.dart';

class SellerOrderOverview extends StatefulWidget {
  const SellerOrderOverview({Key? key, required this.orderId, required this.buyerId}) : super(key: key);
  final String orderId;
  final String buyerId;

  @override
  State<SellerOrderOverview> createState() => _SellerOrderOverviewState();
}

class _SellerOrderOverviewState extends State<SellerOrderOverview> {
  Map<String, dynamic> buyerInfo = {};
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> orderInfo = [];
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() { 
    super.initState();
    loadOrderItems(widget.orderId).then((data) {
      setState(() {
        items = data;
      });
    });
    loadOrderInfo(widget.orderId).then((data){
      setState(() {
        orderInfo = data;
      });
    });
    loadBuyerInfo(context, widget.buyerId).then((data) {
      setState(() {
        buyerInfo = data;
      });
    });
  }

  Future<double> calculateOrderTotalPrice() async {
    double total = 0;
    for (int i = 0; i < items.length; i++) {
      total = total + (double.parse(items[i]['product']['price']) * items[i]['quantity']);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30, left: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFCCE6E6),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              buyerInfo["firstname"] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              buyerInfo["lastname"] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Text(buyerInfo["shippingAddress"] ?? ""),
                        Text(buyerInfo["email"] ?? ""),
                        Text(buyerInfo["phoneNumber"] ?? ""),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                          .collection('requests')
                          .where('orderID', isEqualTo: widget.orderId)
                          .snapshots()
                          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList()), 
                        builder: (context, snapshot) {
                          if(snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return ElevatedButton(
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(
                                  Size(
                                    MediaQuery.of(context).size.width * 0.4,
                                    MediaQuery.of(context).size.height * 0.05,
                                  ),
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
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => OrderDelivery(
                                    orderID: widget.orderId,
                                    selected: true,
                                  ))
                                );
                              },
                              child: const Text(
                                "Track Order ",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          } else {
                            return ElevatedButton(
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(
                                  Size(
                                    MediaQuery.of(context).size.width * 0.4,
                                    MediaQuery.of(context).size.height * 0.05,
                                  ),
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
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => OrderDelivery(
                                    orderID: widget.orderId,
                                    selected: false,
                                  ))
                                );
                              },
                              child: const Text(
                                "Request Delivery",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      QrImageView(
                        data: widget.orderId,
                        version: QrVersions.auto,
                        size: MediaQuery.of(context).size.width * 0.35,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.only(left: 20, right: 20),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFCCE6E6),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: FutureBuilder<double>(
                future: calculateOrderTotalPrice(),
                builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "Total ${snapshot.data.toString()} DZD",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  );
                } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              endIndent: 20,
              indent: 20,
              thickness: 2,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFCCE6E6),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                index.toString(),
                                style: const TextStyle(
                                  overflow: TextOverflow.fade,
                                )
                              )
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                items[index]['product']['title'],
                                style: const TextStyle(
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                items[index]['quantity'].toString(),
                                style: const TextStyle(
                                  overflow: TextOverflow.fade,
                                )
                              )
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                "${items[index]['product']['price']} DZD",
                                style: const TextStyle(
                                  overflow: TextOverflow.fade,
                                )
                              )
                            )
                          ],
                        ),
                        const Divider()
                      ]
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}