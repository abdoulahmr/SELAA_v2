import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/buyer/home_buyer.dart';
import 'package:selaa/screens/buyer/shopping_cart.dart';
import 'package:selaa/screens/seller/product_page.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _productList = [];
  int _currentIndex = 1;
  final List<Widget> _pages = [
    const HomeBuyer(),
    const ProductSearchPage(),
    const ShoppingCart(),
  ];

  void _performSearch(String query) {
    setState(() {
      _searchResults = _productList
          .where((product) =>
              product['title']
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              product['price']
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    loadAllPostes(context).then((List<Map<String, dynamic>> data) {
      setState(() {
        _productList = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.06,
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a product',
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF415B5B),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF415B5B)),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onChanged: (query) {
                  _performSearch(query);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchResults[index]['title']),
                    subtitle: Text(_searchResults[index]['price']+" DZ"),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(productID: _searchResults[index]['productID'])));
                    },
                  );
                },
              ),
            ),
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
