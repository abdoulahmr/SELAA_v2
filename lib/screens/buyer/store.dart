import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/seller/product_page.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key, required this.sellerId});
  final String sellerId;

  @override
  State<StoreScreen> createState() => _StoreState();
}

class _StoreState extends State<StoreScreen> {
  List<Map<String, dynamic>> sellerInfo = [];
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    loadSellerInfo(widget.sellerId, context).then((value) {
      setState(() {
        sellerInfo = value;
      });
    });
    fetchProducts(sellerID: widget.sellerId).then((value) {
      setState(() {
        products = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().secondaryColor,
        title: Text( sellerInfo.isNotEmpty
          ? sellerInfo[0]['username'].toString()
          : "unkown"
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors().secondaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: sellerInfo.isNotEmpty && sellerInfo[0]['profilePicture'] != null
                      ? NetworkImage(sellerInfo[0]['profilePicture'])
                      : NetworkImage(ImagePaths().defaultProfilePicture),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(sellerInfo.isNotEmpty
                        ?sellerInfo[0]['username'].toString():"",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Divider(
                      color: AppColors().primaryColor,
                      thickness: 0.5,
                      indent: 20,
                      endIndent: 20,
                    ),
                    const SizedBox(height: 20),
                    sellerInfo.isNotEmpty && sellerInfo[0]['address'] != null
                    ? Text(sellerInfo[0]['address'])
                    :const SizedBox(),
                    sellerInfo.isNotEmpty && sellerInfo[0]['phoneNumber']!=null
                    ? Text(sellerInfo[0]['phoneNumber'])
                    :const SizedBox(),
                    sellerInfo.isNotEmpty && sellerInfo[0]['email']!=null
                    ? Text(sellerInfo[0]['email'])
                    :const SizedBox(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute( builder: (context) => 
                          ProductPage(productID: products[index]['productID'],discount: 0,),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors().secondaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              child: Image.network(
                                products[index]['imageUrls'][0],
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
                                products[index]['title'],
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
                                "${products[index]['price']} D",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors().primaryColor,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w900,
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
