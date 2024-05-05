import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/screens/register/redirect_login.dart';
import 'package:selaa/screens/seller/order_overview.dart';
import 'package:selaa/screens/seller/order_search.dart';
import 'package:selaa/screens/seller/user_page.dart';
import 'package:selaa/backend-functions/load_data.dart';

// Main class
class ListOrderPage extends StatefulWidget {
  const ListOrderPage({Key? key}) : super(key: key);

  @override
  State<ListOrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<ListOrderPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const RedirectLogin(),
    const UserPage(),
    const ListOrderPage()
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors().secondaryColor,
            bottom: TabBar(
              labelColor: AppColors().primaryColor,
              indicatorColor: AppColors().primaryColor,
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Pending"),
                Tab(text: "In Progress"),
                Tab(text: "Completed"),
              ],
            ),
            title: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchOrderPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.05,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF415B5B),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Search...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF415B5B),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: Color(0xFF415B5B),
                      )
                    ],
                  ),
                ))),
        body: const TabBarView(
          children: [
            AllOrdersTab(),
            PendingOrdersTab(),
            InProgressOrdersTab(),
            CompletedOrdersTab(),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: AppColors().secondaryColor,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedItemColor: AppColors().primaryColor,
            unselectedItemColor: AppColors().primaryColor,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => _pages[index]),
              );
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
                label: "Profile",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.sort,
                  size: 30,
                ),
                label: "Order",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// All orders class
class AllOrdersTab extends StatefulWidget {
  const AllOrdersTab({Key? key}) : super(key: key);

  @override
  State<AllOrdersTab> createState() => _AllOrdersTabState();
}

class _AllOrdersTabState extends State<AllOrdersTab> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    loadSellerOrders(context).then((List<Map<String, dynamic>> data) {
      setState(() {
        orders = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orders.isEmpty
          ? const Center(child: Text('No orders available'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                Color textColor = Colors.black;
                if (orders[index]["status"] == "Pending") {
                  textColor = Colors.orange;
                } else if (orders[index]["status"] == "In Progress") {
                  textColor = Colors.blue;
                } else if (orders[index]["status"] == "Delivered") {
                  textColor = Colors.green;
                } else if (orders[index]["status"] == "Canceled") {
                  textColor = Colors.red;
                }
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellerOrderOverview(
                              orderId: orders[index]["orderID"],
                              buyerId: orders[index]['buyer']["buyerID"],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(
                            '${orders[index]['buyer']['firstname']} ${orders[index]['buyer']['lastname']}'),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              orders[index]["status"],
                              style: TextStyle(color: textColor),
                            ),
                            Text(orders[index]["date"]),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
    );
  }
}

// Pending orders class
class PendingOrdersTab extends StatefulWidget {
  const PendingOrdersTab({Key? key}) : super(key: key);

  @override
  State<PendingOrdersTab> createState() => _PendingOrdersTabState();
}

class _PendingOrdersTabState extends State<PendingOrdersTab> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    loadSellerOrders(context).then((List<Map<String, dynamic>> data) {
      setState(() {
        orders = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orders.isEmpty
          ? const Center(
              child: Text('No pending orders'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                if (orders[index]["status"] != "Pending") {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellerOrderOverview(
                              orderId: orders[index]["orderID"],
                              buyerId: orders[index]['buyer']["buyerID"],
                            ),
                          ),
                        );
                      },
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
                                title: Text(
                                    '${orders[index]['buyer']['firstname']} ${orders[index]['buyer']['lastname']}'),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orders[index]["status"],
                                      style: const TextStyle(
                                        color: Colors.orange,
                                      ),
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
    );
  }
}

class InProgressOrdersTab extends StatefulWidget {
  const InProgressOrdersTab({Key? key}) : super(key: key);

  @override
  State<InProgressOrdersTab> createState() => _InProgressOrdersTabState();
}

class _InProgressOrdersTabState extends State<InProgressOrdersTab> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    loadSellerOrders(context).then((List<Map<String, dynamic>> data) {
      setState(() {
        orders = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orders.isEmpty
          ? const Center(
              child: Text('No in progress orders'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                if (orders[index]["status"] != "In Progress") {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellerOrderOverview(
                              orderId: orders[index]["orderID"],
                              buyerId: orders[index]['buyer']["buyerID"],
                            ),
                          ),
                        );
                      },
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
                                title: Text(
                                    '${orders[index]['buyer']['firstname']} ${orders[index]['buyer']['lastname']}'),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orders[index]["status"],
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
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
    );
  }
}

class CompletedOrdersTab extends StatefulWidget {
  const CompletedOrdersTab({Key? key}) : super(key: key);

  @override
  State<CompletedOrdersTab> createState() => _CompletedOrdersTabState();
}

class _CompletedOrdersTabState extends State<CompletedOrdersTab> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    loadSellerOrders(context).then((List<Map<String, dynamic>> data) {
      setState(() {
        orders = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orders.isEmpty
          ? const Center(
              child: Text('No completed orders'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                if (orders[index]["status"] != "Completed") {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellerOrderOverview(
                              orderId: orders[index]["orderID"],
                              buyerId: orders[index]['buyer']["buyerID"],
                            ),
                          ),
                        );
                      },
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
                                title: Text(
                                    '${orders[index]['buyer']['firstname']} ${orders[index]['buyer']['lastname']}'),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orders[index]["status"],
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
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
    );
  }
}
