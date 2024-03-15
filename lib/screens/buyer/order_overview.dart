import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';

class OrderOverView extends StatefulWidget {
  const OrderOverView({Key? key, required this.orderId}) : super(key: key);
  final String orderId;

  @override
  State<OrderOverView> createState() => _OrderOverViewState();
}

class _OrderOverViewState extends State<OrderOverView> {
  List<Map<String, dynamic>> order = [];
  List<Map<String, dynamic>> items = [];
  double total = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrderInfo(widget.orderId).then((value) {
      setState(() {
        order = value;
      });
    });
    loadOrderItems(widget.orderId).then((value) {
      setState(() {
        items = value;
        _isLoading = false;
      });
    });
    calculateOrderTotalPrice().then((value){
      total = value;
    });
  }

  Future<double> calculateOrderTotalPrice() async {
    for (int i = 0; i < items.length; i++) {
      total = total + (items[i]['quantity']*double.parse(items[i]['product']['price']));
    }
    return total;
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      case 'Canceled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: _isLoading 
        ? Center(
          child: CircularProgressIndicator(
            color: AppColors().primaryColor,
          ),
        )
        :Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30, left: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: (){
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Status: ',
                          style: const TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: order.isNotEmpty ? order[0]['status'] ?? "Pending" : "Pending",
                              style: TextStyle(
                                color: order.isNotEmpty ? _getStatusColor(order[0]['status']) : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(items.isNotEmpty ? "date: ${order[0]['date']}" : ""),
                      const SizedBox(height: 10),
                      FutureBuilder<double>(
                        future: calculateOrderTotalPrice(),
                        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text("Price: ${snapshot.data} DZD");
                          }
                        },
                      ),
                    ],
                  ),
                  QrImageView(
                    data: widget.orderId,
                    version: QrVersions.auto,
                    size: MediaQuery.of(context).size.width * 0.3,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFCCE6E6),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index){
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
