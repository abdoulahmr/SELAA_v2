import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/seller/offer.dart';
import 'package:selaa/screens/seller/order.dart';
import 'package:selaa/screens/seller/user_page.dart';
import 'package:selaa/screens/settings/seller_option_menu.dart';

class HomeSeller extends StatefulWidget {
  const HomeSeller({Key? key}) : super(key: key);

  @override
  State<HomeSeller> createState() => _HomeState();
}

class _HomeState extends State<HomeSeller> {
  String profilePicture = "";
  Map<String, dynamic> ordersInfo = {};
  Map<String, dynamic> productsInfo = {};
  List<Map<String, dynamic>> ordersPreview = [];
  String balanceInfo = "";
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeSeller(),
    const UserPage(),
    const OfferScreen(),
    const ListOrderPage(),
  ];

  @override
  void initState() {
    super.initState();
    loadProfilePicture(context).then((data) {
      if (mounted) {
        setState(() {
          profilePicture = data;
        });
      }
    });
    loadSellerOrdersInfo(context).then((data) {
      setState(() {
        ordersInfo = data;
      });
    });
    loadSellerProductsInfo(context).then((data) {
      setState(() {
        productsInfo = data;
      });
    });
    loadSellerBalanceInfo(context).then((data) {
      setState(() {
        balanceInfo = data;
      });
    });
    loadSellerOrders(context).then((data) {
      setState(() {
        ordersPreview = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(color: Color(0xFF415B5B)),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => const OptionsMenu()));
                    },
                    child: const Center(
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                      )
                    ),
                  ),
                  Image(
                    image: AssetImage(ImagePaths().horizontalLogo),
                    width: 120,
                    height: 120,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 30),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => const UserPage()));
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: profilePicture.isNotEmpty
                        ? NetworkImage(profilePicture)
                        : NetworkImage(ImagePaths().defaultProfilePicture),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: AppColors().secondaryColor,
              ),
              child: CarouselSlider(
                items: [
                  Image(image: NetworkImage(ImagePaths().ad1)),
                  Image(image: NetworkImage(ImagePaths().ad2)),
                  Image(image: NetworkImage(ImagePaths().ad3)),
                ],
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.2,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.05,
              child: const Text(
                "Orders",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: AppColors().secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Pending:",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        ordersInfo['pendingOrders'].toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "On the way:",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        ordersInfo['onTheWayOrders'].toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: AppColors().secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Delivred:",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        ordersInfo['deliveredOrders'].toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Canceld:",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        ordersInfo['canceledOrders'].toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      const Text(
                        "Balance",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(30),
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: AppColors().secondaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Center(
                          child: Text(
                            "$balanceInfo DZD",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  child: Column(
                    children: [
                      const Text(
                        "Products",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: AppColors().secondaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Products:",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  productsInfo['totalProducts'].toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Category:",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  productsInfo['totalCategories'].toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.05,
              child: const Text(
                "Recent Orders",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: AppColors().secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              ),
              child: ordersPreview.isEmpty
              ? const Center(child: Text('No recent orders'))
              : ListView.builder(
                itemCount: ordersPreview.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(ordersPreview[index]["buyer"]["firstname"] +" " +
                          ordersPreview[index]["buyer"]["lastname"] ??'Unknown'),
                        subtitle: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            Text(ordersPreview[index]["date"] ?? ''),
                            Text(ordersPreview[index]["status"] ??'Unknown'),
                          ],
                        ),
                      ),
                      Divider(
                        color: AppColors().primaryColor,
                        thickness: 1,
                        height: 1,
                        indent: 10,
                        endIndent: 10,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
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
                Icons.home_outlined,
                size: 30,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
                size: 30,
              ),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.campaign_outlined,
                size: 30,
              ),
              label: "Offer",
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
    );
  }
}
