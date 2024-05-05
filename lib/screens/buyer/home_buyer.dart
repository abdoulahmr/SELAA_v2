import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/buyer/my_orders.dart';
import 'package:selaa/screens/buyer/product_category_overview.dart';
import 'package:selaa/screens/buyer/products_categorys.dart';
import 'package:selaa/screens/seller/product_page.dart';
import 'package:selaa/screens/buyer/shopping_cart.dart';
import 'package:selaa/screens/buyer/product_search_list.dart';
import 'package:selaa/screens/settings/buyer_options_menu.dart';

class HomeBuyer extends StatefulWidget {
  const HomeBuyer({Key? key}) : super(key: key);

  @override
  State<HomeBuyer> createState() => _HomeState();
}

class _HomeState extends State<HomeBuyer> {
  List<Map<String, dynamic>?> stores = [];
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeBuyer(),
    const ProductSearchPage(),
    const ShoppingCart(),
  ];
  List<Map<String, dynamic>> postes = [];

  @override
  void initState() {
    super.initState();
    loadAllPostes(context).then((List<Map<String, dynamic>> data) {
      setState(() {
        postes = data;
      });
    });
    loadStores().then((data) {
      setState(() {
        stores = data;
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
                margin: const EdgeInsets.only(left: 30, top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute( builder: (context) =>const BuyerOptionsMenu()));
                      },
                      icon: Icon(
                        Icons.menu_outlined,
                        size: 35,
                        color: AppColors().primaryColor,
                      ),
                    ),
                    Image(
                      image: AssetImage(ImagePaths().blackhorizontalLogo),
                      width: 120,
                      height: 120,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 30),
                      child: IconButton(
                        icon: Icon(
                          Icons.delivery_dining,
                          size: 35,
                          color: AppColors().primaryColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyOrdersPage()),
                          );
                        },
                      )
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.17,
                decoration: BoxDecoration(
                  color: AppColors().secondaryColor,
                ),
                child: CarouselSlider(
                  items: [
                    Image(
                      image: NetworkImage(ImagePaths().ad1),
                    ),
                    Image(
                      image: NetworkImage(ImagePaths().ad2),
                    ),
                    Image(
                      image: NetworkImage(ImagePaths().ad3),
                    ),
                  ],
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.15,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProductSearchPage()));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.065,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppColors().borderColor,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Search...",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                Icons.search,
                                color: AppColors().borderColor,
                              )
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors().secondaryColor,
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProductCategoryOverviewPage(
                                            categoryId: "ZlZfD5jmaypx4PJ5WKtr",
                                          )));
                            },
                            icon: const Icon(Icons.devices),
                            iconSize: 30,
                            color: AppColors().primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors().secondaryColor,
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProductCategoryOverviewPage(
                                            categoryId: "l7lxIu6It9Xu1tSLfuQ4",
                                          )));
                            },
                            icon: const Icon(Icons.fastfood_outlined),
                            iconSize: 30,
                            color: AppColors().primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors().secondaryColor,
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProductCategoryOverviewPage(
                                            categoryId: "Xdk6BS0tiQjCgCNEEORK",
                                          )));
                            },
                            icon: const Icon(Icons.checkroom),
                            iconSize: 30,
                            color: AppColors().primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors().secondaryColor,
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProductCategoryOverviewPage(
                                            categoryId: "xNrEZXO3xk8DTj04qKVw",
                                          )));
                            },
                            icon: const Icon(Icons.chair_outlined),
                            iconSize: 30,
                            color: AppColors().primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 9,
                          height: MediaQuery.of(context).size.height / 15,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProductsCategorysPage()));
                              },
                              child: Text(
                                "See More",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors().primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (postes.length / 2).ceil(),
                  itemBuilder: (context, index) {
                    int startIndex = index * 2;
                    int endIndex = startIndex + 1;
                    if (endIndex >= postes.length) {
                      endIndex = postes.length - 1;
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductPage(
                                    productID: postes[startIndex]['productID']),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors().secondaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30.0)),
                            ),
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                  child: Image.network(
                                    postes[startIndex]['imageUrls'][0],
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    postes[startIndex]['title'],
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "${postes[startIndex]['price']} DZ",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductPage(
                                    productID: postes[endIndex]['productID']),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors().secondaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30.0)),
                            ),
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                  child: Image.network(
                                    postes[endIndex]['imageUrls']?[0] ??
                                        'fallback_url',
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    postes[endIndex]['title'],
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "${postes[endIndex]['price']} DZ",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
