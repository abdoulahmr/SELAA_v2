import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/buyer/notification.dart';
import 'package:selaa/seller/product_page.dart';
import 'package:selaa/buyer/shopping_cart.dart';
import 'package:selaa/seller/user_page.dart';
import 'package:selaa/buyer/product_search_list.dart';
import 'package:selaa/settings/buyer_options_menu.dart';

class HomeBuyer extends StatefulWidget {
  const HomeBuyer({Key? key}) : super(key: key);

  @override
  State<HomeBuyer> createState() => _HomeState();
}

class _HomeState extends State<HomeBuyer> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeBuyer(),
    const UserPage(),
    const NotificationPage(),
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
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF008080)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(color: Color(0xFF415B5B)),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BuyerOptionsMenu()));
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
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications,
                          size: 40,
                          color: Color(0xFF008080),
                          ),
                        onPressed: (){

                        },
                      )
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(50),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 199, 199, 199),
                ),
                child: const Center(
                  child: Text("Advertisement")
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductSearchPage()));
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
                            ),
                          ),
                          Icon(
                            Icons.search,
                            color: Color(0xFF415B5B),
                          )
                        ],
                      ),
                    )
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width /6,
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFCCE6E6),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              print("Electronics");
                            },
                            icon: const Icon(Icons.devices),
                              iconSize: 30,
                              color: const Color(0xFF008080),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width /6,
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFCCE6E6),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              print("Food");
                            },
                            icon: const Icon(Icons.fastfood_outlined),
                            iconSize: 30,
                            color: const Color(0xFF008080),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width /6,
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFCCE6E6),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              print("Fashion");
                            },
                            icon: const Icon(Icons.checkroom),
                            iconSize: 30,
                            color: const Color(0xFF008080),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width /6,
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFCCE6E6),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              print("Furniture");
                            },
                            icon : const Icon(Icons.chair_outlined),
                            iconSize: 30,
                            color: const Color(0xFF008080),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width /9,
                        height: MediaQuery.of(context).size.height / 15,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              
                            },
                            child: const Text(
                              "See More",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF008080),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ),
                    ],
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left:10),
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
                          onTap: ()async{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(productID: postes[index]['productID'])));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFCCE6E6),
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                            width: MediaQuery.of(context).size.width*0.45,
                            height: MediaQuery.of(context).size.height*0.35,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(25.0),
                                  ),
                                  child: Image.network(
                                    postes[startIndex]['imageUrls'][0],
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.07,
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
                                  height: MediaQuery.of(context).size.height * 0.03,
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
                          )
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(productID: postes[endIndex]['productID'])));
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFCCE6E6),
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                            width: MediaQuery.of(context).size.width*0.45,
                            height: MediaQuery.of(context).size.height*0.35,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(25.0),
                                  ),
                                  child: Image.network(
                                    postes[endIndex]['imageUrls']?[0] ?? 'fallback_url',
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.07,
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
                                  height: MediaQuery.of(context).size.height * 0.03,
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
                          )
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
          canvasColor: const Color(0xFFCCE6E6),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFF008080),
          unselectedItemColor: const Color(0xFF008080),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _pages[index]),
            );
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 35,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                size: 35,
              ),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                size: 35,
              ),
              label: "Notification",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
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