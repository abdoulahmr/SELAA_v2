// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/screens/buyer/product_search_list.dart';
import 'package:selaa/screens/settings/phone_number.dart';
import 'package:uuid/uuid.dart';
import 'package:selaa/backend-functions/data_manipulation.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/buyer/home_buyer.dart';
import 'package:selaa/backend-functions/oreder_structure.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> userInfo = [];
  List<Map<String, dynamic>> shoppingCart = [];
  List<OrderItem> orderItems = [];
  String shippingAdress = '';
  double totalPrice = 0;
  int _currentIndex = 0;
  bool _isClicked = false;
  final List<Widget> _pages = [
    const HomeBuyer(),
    const ProductSearchPage(),
    const ShoppingCart(),
  ];
  
  @override
  void initState() {
    super.initState();
    loadCartItems(context).then((List<Map<String, dynamic>> items) {
      setState(() {
        shoppingCart = items;
      });
    });
    calculateTotalPrice(context).then((double price) {
      setState(() {
        totalPrice = price;
      });
    });
    loadUserInfo(context).then((List<Map<String, dynamic>> info) {
      setState(() {
        userInfo = info;
      });
    });
    loadUserShippingAddress(context).then((String adress){
      setState(() {
        shippingAdress = adress;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                margin: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 240, 239, 239),
                  borderRadius: BorderRadius.all(Radius.circular(30))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Total : $totalPrice DA",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    shoppingCart.isNotEmpty
                    ? IconButton(
                      onPressed: () {
                        if(_isClicked == false){
                          if(userInfo[0]['phoneNumber'].isEmpty){
                            showDialog(
                              context: context,
                              builder: (BuildContext scaffoldKey) {
                                return AlertDialog(
                                  title: const Text('No Phone number'),
                                  content: const Text('Please update your phone number'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(scaffoldKey);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const AddPhoneNumberPage()
                                          ),
                                        );
                                      },
                                      child: const Text('OK',style: TextStyle(color: Color(0xFF415B5B))),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(scaffoldKey);
                                      },
                                      child: const Text('Cancel',style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            if(shippingAdress == ''){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please update shipping address (settings > shipping address)'),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext scaffoldKey) {
                                  return AlertDialog(
                                    title: const Text('Do you want it to be delivered?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(scaffoldKey);                                          
                                        },
                                        child: const Text('Cancel',style: TextStyle(color: Colors.red)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(scaffoldKey);                                          
                                          String uuid = const Uuid().v4();
                                          saveOrder(
                                            shoppingCart, 
                                            uuid, 
                                            false, 
                                            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                                            scaffoldKey
                                          );
                                          saveItemsInOrder(shoppingCart, uuid);
                                          deleteItemFromCart(scaffoldKey);
                                          setState(() {
                                            _isClicked = true;
                                            shoppingCart = [];
                                            totalPrice = 0;
                                          });
                                        },
                                        child: const Text('No',style: TextStyle(color: Color(0xFF415B5B))),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(scaffoldKey);                                          
                                          String uuid = const Uuid().v4();
                                          saveOrder(
                                            shoppingCart, 
                                            uuid, 
                                            true, 
                                            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                                            scaffoldKey
                                          );
                                          saveItemsInOrder(shoppingCart, uuid);
                                          deleteItemFromCart(scaffoldKey);
                                          setState(() {
                                            _isClicked = true;
                                            shoppingCart = [];
                                            totalPrice = 0;
                                          });
                                        },
                                        child: const Text('Yes',style: TextStyle(color: Color(0xFF415B5B))),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        }
                      }, 
                      icon: Icon(
                        Icons.check,
                        color: AppColors().primaryColor,
                      ),
                    )
                    : const SizedBox(height: 20),
                  ],
                ),
              ),
              ListView.builder(
                itemCount: shoppingCart.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 230, 230, 230),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                          child: Image.network(
                            shoppingCart[index]['product']['imageUrls'][0],
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.2,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Text(
                            shoppingCart[index]['product']["title"],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            shoppingCart[index]['quantity'].toString(),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (index < shoppingCart.length) {
                              deleteItemFromCart(context);
                              setState(() {
                                shoppingCart.removeAt(index);
                                totalPrice = 0;
                                calculateTotalPrice(context).then((double price) {
                                  setState(() {
                                    totalPrice = price;
                                  });
                                });
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  );
                },
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
                size: 35,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search_outlined,
                size: 35,
              ),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_outlined,
                size: 35,
              ),
              label: "Cart",
            ),
          ],
        ),
      ),
    );
  }
}
