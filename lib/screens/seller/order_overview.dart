import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
//import 'package:selaa/generated/l10n.dart';

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
  String? _status;
  bool? _reqDel;

  @override
  void initState() { 
    super.initState();
    loadOrderItems(widget.orderId).then((data) {
      setState(() {
        items = data;
        _status = items[0]["status"];
        _reqDel = items[0]["delivery"];
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
      total = total + (items[i]['unitPrice'] * items[i]['quantity']);
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
                        RichText(
                          text: TextSpan(
                            text: 'Status: ',
                            style: const TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: _status,
                                style: TextStyle(
                                  color: _status == 'Pending' ? Colors.orange : 
                                        _status == 'In Progress' ? Colors.blue :
                                        _status == 'Delivered' ? Colors.green :
                                        _status == 'Canceled' ? Colors.red :
                                        Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(buyerInfo["firstname"] ?? ""),
                            const SizedBox(width: 10),
                            Text(buyerInfo["lastname"] ?? ""),
                          ],
                        ),
                        Text(buyerInfo["shippingAddress"] ?? ""),
                        Text(buyerInfo["email"] ?? ""),
                        Text(buyerInfo["phoneNumber"] ?? ""),
                        FutureBuilder<double>(
                          future: calculateOrderTotalPrice(),
                          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                            if (snapshot.hasData) {
                              return Text("${snapshot.data} DZD");
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      _reqDel == false && _status == "Pending"
                      ? ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors().primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(color: Color(0xFF415B5B)),
                            ),
                          ),
                        ),
                        onPressed: (){}, 
                        child: const Text(
                          "ask for delivery",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        )
                      ) 
                      : const SizedBox(),
                      _status == "Canceled"
                      ? ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors().primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(color: Color(0xFF415B5B)),
                            ),
                          ),
                        ),
                        onPressed: (){}, 
                        child: const Text(
                          "View rapport",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        )
                      ) 
                      : const SizedBox(),
                      _status == "In Progress"
                      ? ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors().primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(color: Color(0xFF415B5B)),
                            ),
                          ),
                        ),
                        onPressed: (){}, 
                        child: const Text(
                          "Track order",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        )
                      ) 
                      : const SizedBox(),
                      QrImageView(
                        data: widget.orderId,
                        version: QrVersions.auto,
                        size: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ],
                  ),
                ],
              ),
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
                                items[index]['productName'],
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
                                "${items[index]['unitPrice']} DZD",
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