import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/data_manipulation.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/seller/add_offer.dart';
import 'package:selaa/screens/seller/home_seller.dart';
import 'package:selaa/screens/seller/order.dart';
import 'package:selaa/screens/seller/product_page.dart';
import 'package:selaa/screens/seller/user_page.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  int _currentIndex = 2;
  final List<Widget> _pages = [
    const HomeSeller(),
    const UserPage(),
    const OfferScreen(),
    const ListOrderPage(),
  ];
  List<Map<String, dynamic>> sellerOffer = [];

  @override
  void initState() {
    super.initState();
    loadSellerOffer(context).then((value) {
      setState(() {
        sellerOffer = value;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sellerOffer.isNotEmpty
      ? ListView.builder(
        itemCount: sellerOffer.length,
        itemBuilder: (context, index) {
          double discountPrice = double.parse(sellerOffer[index]['product']['price'])*sellerOffer[index]['discount']/100;
          double newPrice = double.parse(sellerOffer[index]['product']['price']) - discountPrice;
          return Column(
            children: [
              ListTile(
                onTap: () {
                  showDialog(
                    context: context, 
                    builder: (context) {
                      return Dialog(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height*0.18,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: (){
                                  deleteOffer(sellerOffer[index]['id'],context);
                                  loadSellerOffer(context).then((value) {
                                    setState(() {
                                      sellerOffer = value;
                                    });
                                  });
                                  Navigator.pop(context);
                                },
                                trailing: const Icon(Icons.delete, color: Colors.red),
                                title: const Text(
                                  "Delete Offer",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Divider(
                                indent: 20,
                                endIndent: 20,
                              ),
                              ListTile(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductPage(
                                        productID: sellerOffer[index]['productID']['productID'],
                                      ),
                                    ),
                                  );
                                },
                                trailing: Icon(Icons.remove_red_eye, color: AppColors().primaryColor),
                                title: const Text(
                                  "View Product",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      );
                    },
                  );
                },
                leading: sellerOffer[index]['product']['imageUrls']==null
                  ? Image.network("https://via.placeholder.com/150", width: 50, height: 50)
                  : Image.network(sellerOffer[index]['product']['imageUrls'][0], width: 50, height: 50),
                title: Text(
                  sellerOffer[index]['product']['title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  '- ${sellerOffer[index]['discount'].toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Text(
                            "${sellerOffer[index]['product']['price']} DA",
                      style: TextStyle(
                        color: AppColors().primaryColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: AppColors().primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                            "${newPrice.toString()} DA",
                      style: TextStyle(
                        color: AppColors().primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
      )
      : const Center(
        child: Text('Press + to add an offer'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddOfferScreen()));
        },
        foregroundColor: AppColors().primaryColor,
        backgroundColor: AppColors().secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
        child: const Icon(Icons.add),
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