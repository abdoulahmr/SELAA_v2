import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:selaa/backend-functions/links.dart";
import "package:selaa/backend-functions/load_data.dart";
import "package:selaa/screens/buyer/product_search_list.dart";
import "package:selaa/screens/guest/guest_option_menu.dart";
import "package:selaa/screens/guest/product_page.dart";
import "package:selaa/screens/guest/product_search.dart";
import "package:selaa/screens/register/choice_auth.dart";

class HomeGuest extends StatefulWidget {
  const HomeGuest({super.key});

  @override
  State<HomeGuest> createState() => HomeGuestState();
}

class HomeGuestState extends State<HomeGuest> {
  List<Map<String, dynamic>?> stores = [];
  List<Map<String, dynamic>> postes = [];
  List<Map<String, dynamic>> offers = [];
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeGuest(),
    const GuestProductSearchPage(),
  ];

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
    loadOffers(context).then((value){
      setState(() {
        offers = value;
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
                margin: const EdgeInsets.only(left: 30, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => const GuestOptionMenue()));
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
                            Icons.login_outlined,
                          size: 35,
                          color: AppColors().primaryColor,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>const ChoiceAuthPage()));
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
                    Image(image: NetworkImage(ImagePaths().ad1)),
                    Image(image: NetworkImage(ImagePaths().ad2)),
                    Image(image: NetworkImage(ImagePaths().ad3)),
                  ],
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.15,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    viewportFraction: 1,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>const ProductSearchPage())
                        );
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
                  const SizedBox(height: 15),
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
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Sign In Required",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: const Text("You need to sign in to access this feature"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                            color: AppColors().primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
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
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Sign In Required",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: const Text("You need to sign in to access this feature"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                            color: AppColors().primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
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
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Sign In Required",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: const Text("You need to sign in to access this feature"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                            color: AppColors().primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
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
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Sign In Required",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: const Text("You need to sign in to access this feature"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                            color: AppColors().primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
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
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Sign In Required",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: const Text("You need to sign in to access this feature"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                            color: AppColors().primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
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
                        )
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Divider(
                color: AppColors().primaryColor,
                indent: 20,
                endIndent: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      ImagePaths().bestOffers,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "Sign In Required",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text("You need to sign in to access this feature"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                      color: AppColors().primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
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
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                height: MediaQuery.of(context).size.height * 0.23,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    double oldprice =
                        double.parse(offers[index]['product']['price']);
                    double discount = offers[index]['discount'];
                    double newprice = oldprice - (oldprice * discount / 100);
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "Sign In Required",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text("You need to sign in to access this feature"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                      color: AppColors().primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                child: Image.network(
                                  offers.isNotEmpty &&
                                  index < offers.length &&
                                  offers[index]['product']['imageUrls'] !=null &&
                                  offers[index]['product']['imageUrls'].isNotEmpty
                                ? offers[index]['product']['imageUrls'][0]
                                : "https://via.placeholder.com/150",
                                height:MediaQuery.of(context).size.height * 0.15,
                                width:MediaQuery.of(context).size.height * 0.15,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.12,
                              child: Text(
                                offers.isNotEmpty && index < offers.length
                                ? "${newprice.toStringAsFixed(2)} DA"
                                : '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            SizedBox(
                              width:MediaQuery.of(context).size.height * 0.12,
                              child: Text(
                                offers.isNotEmpty && index < offers.length
                                ? "${oldprice.toStringAsFixed(2)} DA"
                                : '',
                                style: const TextStyle(
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                    );
                  },
                ),
              ),
              Divider(
                color: AppColors().primaryColor,
                indent: 20,
                endIndent: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      ImagePaths().suggestedStores,
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "Sign In Required",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text("You need to sign in to access this feature"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                      color: AppColors().primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
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
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                height: MediaQuery.of(context).size.height * 0.25,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "Sign In Required",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text("You need to sign in to access this feature"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                      color: AppColors().primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors().secondaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                                child: Image.network( stores.isNotEmpty && index < stores.length
                                ? stores[index]!['data']['profilePicture']
                                : ImagePaths().defaultProfilePicture,
                                  height: MediaQuery.of(context).size.height *0.1,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: Text( stores.isNotEmpty
                              ? stores[index]!['data']['username'] ?? '': '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            stores[index]!['data']['bio'] != null
                            ? SizedBox(
                              width: MediaQuery.of(context).size.width *0.35,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: Text( stores.isNotEmpty
                              ? stores[index]!['data']['bio'] ?? '': '',
                                style: const TextStyle(
                                  fontSize: 10,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            )
                            : Container(),
                            stores[index]!['data']['address'] != null
                            ? SizedBox(
                              width: MediaQuery.of(context).size.width *0.35,
                              child: Text( stores.isNotEmpty
                              ? stores[index]!['data']['address'] ?? '': '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.clip,
                                  color: AppColors().primaryColor,
                                ),
                              ),
                            )
                            : Container(),
                          ],
                        )
                      ),
                    );
                  },
                ),
              ),
              Divider(
                color: AppColors().primaryColor,
                indent: 20,
                endIndent: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      ImagePaths().newestProducts,
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors().primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: postes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute( builder: (context) => 
                          GuestProductPage(productID: postes[index]['productID']),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors().secondaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              child: Image.network(
                                postes[index]['imageUrls'][0],
                                height: MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                postes[index]['title'],
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 15,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                "${postes[index]['price']} DA",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors().primaryColor,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
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
          ],
        ),
      ),
    );
  }
}