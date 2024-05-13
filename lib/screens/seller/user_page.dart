import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/seller/add_product.dart';
import 'package:selaa/screens/seller/edit_profile.dart';
import 'package:selaa/screens/seller/home_seller.dart';
import 'package:selaa/screens/seller/offer.dart';
import 'package:selaa/screens/seller/order.dart';
import 'package:selaa/screens/seller/product_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  List<Map<String, dynamic>> userInfo = [];
  List<Map<String, dynamic>> userPostes = [];
  int _currentIndex = 1;
  final List<Widget> _pages = [
    const HomeSeller(),
    const UserPage(),
    const OfferScreen(),
    const ListOrderPage(),
  ];

  @override
  void initState() {
    super.initState();
    loadUserInfo(context).then((List<Map<String, dynamic>> user) {
      setState(() {
        userInfo = user;
      });
    });
    fetchProducts().then((List<Map<String, dynamic>> postes) {
      setState(() {
        userPostes = postes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors().secondaryColor,
                ),
                child: Column(
                  children: [
                  if (userInfo.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              userInfo[0]['username'].toString(),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ),
                          CircleAvatar(
                            radius: 60,
                            backgroundImage:userInfo[0]['profilePicture'] != null
                            ? NetworkImage(userInfo[0]['profilePicture'])
                                        : const NetworkImage(
                                            "https://via.placeholder.com/150"),
                        ),
                        ],
                      ),
                    ),
                  if (userInfo.isNotEmpty)
                    Container(
                    margin: const EdgeInsets.only(left: 40, bottom: 20),
                      child: Text(
                        userInfo[0]['bio'],
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  if (userInfo.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(width: 10),
                              Text(
                                userInfo[0]['address'],
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.phone),
                              const SizedBox(width: 10),
                              Text(
                                userInfo[0]['phoneNumber'],
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.alternate_email_outlined),
                              const SizedBox(width: 10),
                              Text(
                                userInfo[0]['email'],
                                style: const TextStyle(
                                fontSize: 18,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(
                            MediaQuery.of(context).size.width * 0.36,
                            MediaQuery.of(context).size.height * 0.06,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF415B5B)),
                        shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: const BorderSide(color: Color(0xFF415B5B)),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => const AddPoste()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Add', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(
                            MediaQuery.of(context).size.width * 0.39,
                            MediaQuery.of(context).size.height * 0.06,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF415B5B)),
                        shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: const BorderSide(color: Color(0xFF415B5B)),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => const EditProfile()));
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.edit_square, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Edit profile',
                            style: TextStyle(color: Colors.white)
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.builder(
                  itemCount: userPostes.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductPage(
                                  productID: userPostes[index]['productID'],
                                ),
                              ),
                            );
                          },
                          leading: userPostes[index]['imageUrls']==null
                          ? Image.network("https://via.placeholder.com/150", width: 50, height: 50)
                          : Image.network(userPostes[index]['imageUrls'][0], width: 50, height: 50),
                          title: Text(
                            userPostes[index]['title'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            userPostes[index]['description'],
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          trailing: Text(
                              "${userPostes[index]['price']} DA",
                            style: TextStyle(
                              color: AppColors().primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Divider(
                          color: AppColors().primaryColor,
                          indent: 20,
                          endIndent: 20,
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
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
      )
    );
  }
}
