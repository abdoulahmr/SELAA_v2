// ignore_for_file: deprecated_member_use, must_be_immutable
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import '../../backend-functions/data_manipulation.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.productID, required this.discount}) : super(key: key);
  final String productID;
  final double discount;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Map<String, dynamic>> userInfo = [];
  List<Map<String, dynamic>> productReviews = [];
  List posteInfo = [];
  bool _isloading = true;
  double _review = 0.0;
  int numRating = 0;

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
        _isloading = false;
      });
    });
    loadProductRating(context, widget.productID).then((List<Map<String, dynamic>> ratings) {
      setState(() {
        if (ratings.isNotEmpty) {
          _review = calculateAverageRating(ratings);
        }
        numRating = ratings.length;
      });
    });
    loadProductReviews(context, widget.productID).then((List<Map<String, dynamic>> reviews){
      setState(() {
        productReviews = reviews;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: AppColors().primaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.values[2],
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: userInfo.isNotEmpty && userInfo[0]['profilePicture'] != null
                  ? NetworkImage(userInfo[0]['profilePicture'])
                  : NetworkImage(ImagePaths().defaultProfilePicture),
              ),
              const SizedBox(width: 10),
              Text(
                userInfo.isNotEmpty ? userInfo[0]['username'] ?? '' : '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            Visibility(
              visible: userInfo.isNotEmpty && FirebaseAuth.instance.currentUser?.uid == posteInfo[0]['sellerID'],
              child: IconButton(
                icon: const Icon(Icons.delete,color: Colors.red,),
                onPressed: () {
                  deletePoste(widget.productID, context);
                },
              ),
            )
          ],
          automaticallyImplyLeading: false,
          backgroundColor: AppColors().secondaryColor,
          bottom: TabBar(
              labelColor: AppColors().primaryColor,
              indicatorColor: AppColors().primaryColor,
              tabs: const [
                Tab(text: "Product Details"),
                Tab(text: "Reviews"),
              ],
            ),
        ),
        body: _isloading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
            children: [
              ProductDetails(
                productID: widget.productID,
                userInfo: userInfo, 
                posteInfo: posteInfo,
                review: _review,
                numRating: numRating,
                discount: widget.discount,
              ),
              ProductReview(
                productID: widget.productID, 
                productReviews: productReviews, 
                sellerID: posteInfo[0]['sellerID'],
              ),
            ],
          ),
      ),
    );
  }
}

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, 
    required this.productID, 
    required this.userInfo, 
    required this.posteInfo, 
    required this.review, 
    required this.numRating, required this.discount}) : super(key: key);
  final String productID;
  final List<Map<String, dynamic>> userInfo;
  final double review;
  final int numRating;
  final List posteInfo;
  final double discount;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  int quantityValue = 1;

  @override
  void initState() {
    super.initState();
    quantityValue = widget.posteInfo[0]['minQuantity'];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(color: Color(0xFFF2F4F4)),
              child: widget.posteInfo.isNotEmpty && widget.posteInfo[0]['imageUrls'] != null
                ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.posteInfo[0]['imageUrls'].length,
                    itemBuilder: (context, index) {
                      return Image.network(widget.posteInfo[0]['imageUrls'][index]);
                    },
                  ),
                )
                : const Text('No images available'),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.posteInfo.isNotEmpty ? widget.posteInfo[0]['title'] ?? '' : '',
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
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      AnimatedRatingStars(
                        initialRating: widget.review,
                        filledColor: AppColors().primaryColor,
                        emptyColor: Colors.grey,
                        emptyIcon: Icons.star_border,
                        onChanged: (double rating) {},
                        displayRatingValue: true,
                        interactiveTooltips: true,
                        customFilledIcon: Icons.star,
                        customHalfFilledIcon: Icons.star_half,
                        customEmptyIcon: Icons.star_border,
                        starSize: 20.0,
                        readOnly: true,
                      ),
                      const SizedBox(width: 10),
                      Text("(${widget.numRating})"),
                    ],
                  ),
                  const SizedBox(width: 20),
                  widget.discount == 0.0
                  ? const SizedBox(width: 10)
                  : Text(
                    "-${widget.discount.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ],
              )
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                widget.posteInfo.isNotEmpty ? widget.posteInfo[1]['name'] : '',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F4),
                borderRadius: const  BorderRadius.all(Radius.circular(20.0)),
                border: Border.all(
                  color: AppColors().borderColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors().primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.posteInfo.isNotEmpty ? widget.posteInfo[0]['description'] ?? '' : '',
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
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F4),
                borderRadius: const  BorderRadius.all(Radius.circular(20.0)),
                border: Border.all(
                  color: AppColors().borderColor,
                ),
              ),
              child: widget.discount == 0.0
              ? Text(
                widget.posteInfo.isNotEmpty ? "${widget.posteInfo[0]['price']} D" : '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.posteInfo.isNotEmpty ? "${widget.posteInfo[0]['price']} DA" : '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${double.parse(widget.posteInfo[0]['price'])-(double.parse(widget.posteInfo[0]['price'])*widget.discount/100)} DA",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20, 
                      color: Colors.red
                    )
                  ),
                ],
              )
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F4),
                borderRadius: const  BorderRadius.all(Radius.circular(20.0)),
                border: Border.all(
                  color: AppColors().borderColor,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.mapMarkerAlt,
                    color: AppColors().primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.posteInfo.isNotEmpty ? widget.posteInfo[0]['location'] : '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: widget.posteInfo.isNotEmpty && FirebaseAuth.instance.currentUser?.uid != widget.posteInfo[0]['sellerID'],
              child: ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    Size(
                      MediaQuery.of(context).size.width * 0.9,
                      MediaQuery.of(context).size.height * 0.06,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: AppColors().borderColor),
                    ),
                  ),
                ),
                child: const Text('Add to cart',style: TextStyle(color:Colors.white)),
                onPressed: () async {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Select quantity:",
                              style: TextStyle(
                                fontSize: 20,
                              ),  
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: InputQty(
                                maxVal: 10000,
                                initVal: widget.posteInfo[0]['minQuantity'],
                                minVal: widget.posteInfo[0]['minQuantity'],
                                steps: 1,
                                onQtyChanged: (value) {
                                  String intValue = value.toString().split('.')[0];
                                  setState(() => quantityValue = int.parse(intValue));
                                }
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(
                                  Size(
                                    MediaQuery.of(context).size.width * 0.9,
                                    MediaQuery.of(context).size.height * 0.06,
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(color: AppColors().borderColor),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                addItemToCart(
                                  widget.posteInfo[0]['sellerID'], 
                                  widget.productID, 
                                  quantityValue,
                                  widget.posteInfo[0]['price'].toString(),
                                  context
                                );
                                Navigator.pop(context);
                              },
                              child: const Text('Add to cart',style: TextStyle(color:Colors.white)),
                            ),
                          ],
                        )
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class ProductReview extends StatefulWidget {
  ProductReview({Key? key, 
            required this.productID, 
            required this.productReviews, 
            required this.sellerID, 
                      }) : super(key: key);
  final String productID;
  final String sellerID;
  List<Map<String, dynamic>> productReviews;

  @override
  State<ProductReview> createState() => _Tab2ContentState();
}

class _Tab2ContentState extends State<ProductReview> {
  double userRating = 0.0;
  String label = "Add rating";
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: FirebaseAuth.instance.currentUser?.uid != widget.sellerID,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F4),
                      borderRadius: const  BorderRadius.all(Radius.circular(20.0)),
                      border: Border.all(
                        color: AppColors().borderColor,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors().primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedRatingStars(
                              initialRating: 0,
                              filledColor: AppColors().primaryColor,
                              emptyColor: Colors.grey,
                              emptyIcon: Icons.star_border,
                              onChanged: (double rating) {
                                setState(() {
                                  userRating = rating;
                                  label = "Thank you for your review!";
                                });
                                addProductRating( widget.productID, userRating, context);
                              },
                              displayRatingValue: true,
                              interactiveTooltips: true,
                              customFilledIcon: Icons.star,
                              customHalfFilledIcon: Icons.star_half,
                              customEmptyIcon: Icons.star_border,
                              starSize: 20.0,
                              readOnly: false,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              userRating.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors().primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F4),
                      borderRadius: const  BorderRadius.all(Radius.circular(20.0)),
                      border: Border.all(
                        color: AppColors().borderColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Add a comment',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors().borderColor))),
                            maxLines: 3,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            fixedSize: MaterialStateProperty.all(
                              Size(MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.05),
                            ),
                            backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(  
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(color: AppColors().primaryColor),
                              ),
                            ),
                          ),
                          onPressed: () async{
                            await addProductReview(widget.productID, _commentController.text, context);
                            setState(() {
                              _commentController.clear();
                              // Reload the product reviews after adding a new review
                              loadProductReviews(context, widget.productID).then((List<Map<String, dynamic>> reviews){
                                setState(() {
                                  widget.productReviews = reviews;
                                });
                              });
                            });
                          },
                          child: const Text(
                            'Submit Comment',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    )
                  ),                  
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F4),
                borderRadius: const  BorderRadius.all(Radius.circular(20.0)),
                border: Border.all(
                  color: AppColors().borderColor,
                ),
              ),
              child: widget.productReviews.isNotEmpty
                ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.productReviews.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text("${widget.productReviews[index]['buyerInfo']['firstname']}  ${widget.productReviews[index]['buyerInfo']['lastname']}"),
                          subtitle: Text(widget.productReviews[index]['review']),
                        ),
                        if (index != widget.productReviews.length - 1) const Divider(),
                      ],
                    );
                  },
                )
                : const Center(child: Text('No reviews available')),
            ),
          ],
        ),
      ),
    );
  }
}
