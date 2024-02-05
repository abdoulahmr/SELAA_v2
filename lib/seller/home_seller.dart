import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/buyer/notification.dart';
import 'package:selaa/seller/order.dart';
import 'package:selaa/seller/user_page.dart';
import 'package:selaa/settings/seller_option_menu.dart';

class HomeSeller extends StatefulWidget {
  const HomeSeller({Key? key}) : super(key: key);

  @override
  State<HomeSeller> createState() => _HomeState();
}

class _HomeState extends State<HomeSeller> {
  String profilePicture = '';
  List<int> orderStatus = [100,20,30,50];
  List<int> productStatus = [3,10];
  int balance = 1000;
  final List<Widget> _pages = [
    const HomeSeller(),
    const UserPage(),
    const NotificationPage(),
    const OrderPage(),
  ];

  List<Map<String, dynamic>> postes = [];

  @override
  void initState() {
    super.initState();
    loadProfilePicture(context).then((data){
      setState(() {
        profilePicture = data;
      });
    });
    loadAllPostes(context).then(
      (List<Map<String, dynamic>> data) {
      setState(() {
        postes = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SingleChildScrollView(
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
                        fixedSize: MaterialStateProperty.all(
                          Size(
                            MediaQuery.of(context).size.width * 0.04,
                            MediaQuery.of(context).size.height * 0.05,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF0A1747)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(color: Color(0xFF0A1747)),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const OptionsMenu()));
                      },
                      child: const Icon(Icons.menu),
                    ),
                    const Image(
                      image: AssetImage(
                        'assets/images/2-removebg-preview-removebg-preview.png',
                      ),
                      width: 120,
                      height: 120,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 30),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const UserPage()));
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: profilePicture.isNotEmpty
                              ? NetworkImage(profilePicture)
                              : const NetworkImage('https://firebasestorage.googleapis.com/v0/b/selaa-2ff93.appspot.com/o/profilePicture%2Fkisspng-computer-icons-download-avatar-5b3848b5343f86.741661901530415285214-removebg-preview%20(1).png?alt=media&token=0c01bbf5-f998-4ad9-af94-235ba6fd4ab5'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: const BoxDecoration(
                  color: Color(0xFF66D6E4),
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
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: const BoxDecoration(
                      color: Color(0xFF66D6E4),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
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
                          orderStatus[0].toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "On the way:",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          orderStatus[1].toString(),
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
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: const BoxDecoration(
                      color: Color(0xFF66D6E4),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
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
                          orderStatus[2].toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Canceld:",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          orderStatus[3].toString(),
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
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            color: const Color(0xFF66D6E4),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Center(
                            child: Text(
                              "${balance.toString()} DZD",
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
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: const BoxDecoration(
                            color: Color(0xFF66D6E4),
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
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
                                    productStatus[0].toString(),
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
                                    productStatus[1].toString(),
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
                decoration: const BoxDecoration(
                  color: Color(0xFF66D6E4),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              )
            ],            
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey, width: 0.5), // Add top border
            ),
          ),
        child: FloatingNavbar(
          selectedItemColor: const Color(0xFF0A1747),
          unselectedItemColor: const Color(0xFF66D6E4),
          backgroundColor: Colors.white,
          onTap: (int val) {
            if(val != 0){
              Navigator.push(context,MaterialPageRoute(builder: (context) => _pages[val]));
            }
          },
          currentIndex: 0,
          items: [
            FloatingNavbarItem(icon: Icons.home, title: 'Home'),
            FloatingNavbarItem(icon: Icons.account_circle, title: 'Profile'),
            FloatingNavbarItem(icon: Icons.notifications, title: 'Notifications'),
            FloatingNavbarItem(icon: Icons.all_inbox, title: 'Orders'),
          ],
        ),
      ),
    );
  }
}