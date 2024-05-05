import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/buyer/product_search_list.dart';
import 'package:selaa/screens/seller/product_page.dart';

class ProductCategoryOverviewPage extends StatefulWidget {
  const ProductCategoryOverviewPage({Key? key, required this.categoryId})
      : super(key: key);
  final String categoryId;

  @override
  State<ProductCategoryOverviewPage> createState() =>
      _ProductCategoryOverviewPageState();
}

class _ProductCategoryOverviewPageState
    extends State<ProductCategoryOverviewPage> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    loadProductsByCategory(widget.categoryId, context).then((data) {
      setState(() {
        products = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50, left: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProductSearchPage()));
                      },
                      child: Container(
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
                      )),
                ),
                const SizedBox(width: 30),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: products.isEmpty
                ? const Center(
                    child: Text(
                      'No product',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: (products.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      int startIndex = index * 2;
                      int endIndex = startIndex + 1;
                      if (endIndex >= products.length) {
                        endIndex = products.length - 1;
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
                                            productID: products[index]
                                                ['productID'])));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors().secondaryColor,
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(30.0)),
                                ),
                                width: MediaQuery.of(context).size.width * 0.45,
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0),
                                      ),
                                      child: Image.network(
                                        products[startIndex]['imageUrls'][0],
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        products[startIndex]['title'],
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
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        "${products[startIndex]['price']} DZ",
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
                              )),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductPage(
                                            productID: products[endIndex]
                                                ['productID'])));
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
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0),
                                      ),
                                      child: Image.network(
                                        products[endIndex]['imageUrls']?[0] ??
                                            'fallback_url',
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        products[endIndex]['title'],
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
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        "${products[endIndex]['price']} DZ",
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
                              )),
                        ],
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
