import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/data_manipulation.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';

class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({super.key});

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  List<Map<String, dynamic>> productList = [];
  double discount = 0.0;
  double discountPrice = 0.0;
  
  @override
  void initState() {
    super.initState();
    fetchProducts().then((value){
      setState(() {
        productList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Item'),
        backgroundColor: AppColors().secondaryColor,
      ),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: productList[index]['imageUrls']==null
                  ? Image.network("https://via.placeholder.com/150", width: 50, height: 50)
                  : Image.network(productList[index]['imageUrls'][0], width: 50, height: 50),
                title: Text(productList[index]['title']),
                trailing: Text(
                  productList[index]['price']+ ' DZD',
                  style: TextStyle(
                    color: AppColors().primaryColor,
                    fontSize: 15,
                  ),  
                ),
                onTap: () {
                  showDialog(
                    context: context, 
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Select percentage discount'),
                        content: StatefulBuilder(
                          builder: (context, setState) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height*0.15,
                              child: Column(
                                children: [
                                  Slider(
                                    value: discount,
                                    onChanged: (value) {
                                      setState(() {
                                        discount = value;
                                        discountPrice = double.parse(productList[index]['price'])*discount/100;
                                      });
                                    },
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    activeColor: AppColors().primaryColor,
                                    label: '${discount.toStringAsFixed(0)}%',
                                  ),
                                  Text(
                                    'Discount: ${discount.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      color: AppColors().primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Discount price: - ${discountPrice.toStringAsFixed(2)} DZD',
                                    style: TextStyle(
                                      color: AppColors().primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                discount = 0.0;
                                discountPrice = 0.0;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              addDiscountOffer(productList[index]['productID'], discount, context);
                              setState(() {
                                discount = 0.0;
                                discountPrice = 0.0;
                              });
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Add',
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
              ),
              Divider(
                height: 1,
                color: AppColors().primaryColor,
                indent: 20,
                endIndent: 20,
              ),
            ],
          );
        },
      ),
    );
  }
}