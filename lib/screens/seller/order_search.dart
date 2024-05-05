import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';

class SearchOrderPage extends StatefulWidget {
  const SearchOrderPage({Key? key}) : super(key: key);

  @override
  State<SearchOrderPage> createState() => _SearchOrderPageState();
}

class _SearchOrderPageState extends State<SearchOrderPage> {
  final TextEditingController _search = TextEditingController();
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> filteredOrders = [];

  @override
  void initState() {
    super.initState();
    loadSellerOrders(context).then((List<Map<String, dynamic>> data) {
      setState(() {
        orders = data;
        filteredOrders = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
        child: AppBar(
          backgroundColor: AppColors().secondaryColor,
          iconTheme: IconThemeData(color: AppColors().primaryColor),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * 0.65,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFF415B5B),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _search,
                        decoration: const InputDecoration(
                          hintText: 'Search order',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            filteredOrders = orders
                                .where((order) => order['orderId']
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    ),
                    const Icon(Icons.search, color: Color(0xFF415B5B)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () async {},
              icon: Icon(
                Icons.qr_code_scanner,
                color: AppColors().primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: FutureBuilder<String>(
                        future: loadUserName(context, orders[index]["buyerID"]),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else {
                            if (snapshot.hasError) {
                              return const Text('Error loading user name');
                            } else {
                              return ListTile(
                                title: Text(snapshot.data ?? 'Unknown'),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orders[index]["status"],
                                    ),
                                    Text(orders[index]["date"]),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
