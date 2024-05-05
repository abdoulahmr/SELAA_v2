import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/buyer/product_category_overview.dart';

class ProductsCategorysPage extends StatefulWidget {
  const ProductsCategorysPage({Key? key}) : super(key: key);

  @override
  State<ProductsCategorysPage> createState() => _ProductsCategorysPageState();
}

class _ProductsCategorysPageState extends State<ProductsCategorysPage> {
  List<Map<String, dynamic>> categorys = [];
  List<Map<String, dynamic>> filteredCategorys = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProductsCategorys(context).then((value) {
      setState(() {
        categorys = value;
        filteredCategorys = categorys;
      });
    });
  }

  void filterCategorys(String query) {
    setState(() {
      filteredCategorys = categorys
          .where((category) =>
              category['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
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
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (query) {
                      filterCategorys(query);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF415B5B)),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      hintText: 'Search...',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF415B5B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: filteredCategorys.isEmpty
                  ? const Center(
                      child: Text(
                        'No product',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: filteredCategorys.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductCategoryOverviewPage(
                                          categoryId: filteredCategorys[index]
                                              ['id'],
                                        )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors().secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                filteredCategorys[index]['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors().primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
