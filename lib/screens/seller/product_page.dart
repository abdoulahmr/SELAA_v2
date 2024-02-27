// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:selaa/backend-functions/links.dart';

import 'package:selaa/backend-functions/load_data.dart';
import '../../backend-functions/data_manipulation.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.productID}) : super(key: key);

  final String productID;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Map<String, dynamic>> userInfo = [];
  List posteInfo = [];
  int quantityValue = 1;

 @override
  void initState() {
    super.initState();
    loadPosteInfo(widget.productID, context).then((List<Map<String, dynamic>> poste) {
      setState(() {
        posteInfo = poste;
        if (posteInfo.isNotEmpty) {
          loadSellerInfo(posteInfo[0]['sellerID'], context).then((List<Map<String, dynamic>> user) {
            setState(() {
              userInfo = user;
            });
          });
        }
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
                padding: const EdgeInsets.only(left: 30, top: 20),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // bug
                    Visibility(
                      visible: posteInfo.isNotEmpty && FirebaseAuth.instance.currentUser?.uid == posteInfo[0]['userId'],
                      child: IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.trash,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          deletePoste(widget.productID, context);
                        },
                      ),
                    ),
                  ],
                )
              ),
              Container(
                margin: const EdgeInsets.only(left:20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: userInfo.isNotEmpty && userInfo[0]['profilePicture'] != null
                          ? NetworkImage(userInfo[0]['profilePicture'])
                          : const NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/selaa-2ff93.appspot.com/o/profilePicture%2Fkisspng-computer-icons-download-avatar-5b3848b5343f86.741661901530415285214-removebg-preview%20(1).png?alt=media&token=0c01bbf5-f998-4ad9-af94-235ba6fd4ab5',
                            ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        userInfo.isNotEmpty ? userInfo[0]['username'] ?? '' : '',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: const BoxDecoration(color: Color(0xFFF2F4F4)),
                child: posteInfo.isNotEmpty && posteInfo[0]['imageUrls'] != null
                  ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: posteInfo[0]['imageUrls'].length,
                      itemBuilder: (context, index) {
                        return Image.network(posteInfo[0]['imageUrls'][index]);
                      },
                    ),
                  )
                  : const Text('No images available'),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    posteInfo.isNotEmpty ? posteInfo[0]['title'] ?? '' : '',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  posteInfo.isNotEmpty ? posteInfo[1]['name'] : '',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F4),
                  borderRadius: const  BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: const Color(0xFF001A1A),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF008080),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      posteInfo.isNotEmpty ? posteInfo[0]['description'] ?? '' : '',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F4),
                  borderRadius: const  BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: const Color(0xFF001A1A),
                  ),
                ),
                child: Text(
                  posteInfo.isNotEmpty ? "${posteInfo[0]['price']} DZ" : '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F4),
                  borderRadius: const  BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: const Color(0xFF001A1A),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.mapMarkerAlt,
                      color: Color(0xFF008080),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      posteInfo.isNotEmpty ? posteInfo[0]['location'] : '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Visibility(
                    visible: posteInfo.isNotEmpty && FirebaseAuth.instance.currentUser?.uid != posteInfo[0]['userId'],
                    child: ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(
                            MediaQuery.of(context).size.width * 0.35,
                            MediaQuery.of(context).size.height * 0.06,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: const BorderSide(color: Color(0xFF415B5B)),
                          ),
                        ),
                      ),
                      child: const Text('Add to cart',style: TextStyle(color:Colors.white)),
                      onPressed: () async {
                        addItemToCart(
                          posteInfo[0]['sellerID'], 
                          widget.productID, 
                          quantityValue,
                          posteInfo[0]['price'],
                          context
                        );
                      }
                    ),
                  ),
                  InputQty(
                    maxVal: 10000,
                    initVal: 1,
                    minVal: 1,
                    steps: 1,
                    onQtyChanged: (value) {
                      String intValue = value.toString().split('.')[0];
                      setState(() => quantityValue = int.parse(intValue));
                    }
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}