import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/buyer/order_overview.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(
            color: AppColors().primaryColor,
          ),
        ),
        backgroundColor: AppColors().secondaryColor,
        iconTheme: IconThemeData(color: AppColors().primaryColor),
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadBuyerOrders(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors().primaryColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Text(
                          '# ${index + 1}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors().primaryColor,
                          ),
                        ),
                        title: Text(
                          '${orders[index]['orderId']}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors().primaryColor,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'Date: ${orders[index]['date']}',
                              style: const TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Status: ${orders[index]['status']}',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>OrderOverView(orderId: orders[index]['orderId']),
                          ));
                        },
                      ),
                      const Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
