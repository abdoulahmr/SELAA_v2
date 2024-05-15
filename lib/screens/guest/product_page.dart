// ignore_for_file: must_be_immutable

import "package:animated_rating_stars/animated_rating_stars.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:selaa/backend-functions/data_manipulation.dart";
import "package:selaa/backend-functions/links.dart";
import "package:selaa/backend-functions/load_data.dart";

class GuestProductPage extends StatefulWidget {
  const GuestProductPage({super.key, required this.productID});
  final String productID;

  @override
  State<GuestProductPage> createState() => _GuestProductPageState();
}

class _GuestProductPageState extends State<GuestProductPage> {
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
    required this.numRating}) : super(key: key);
  final String productID;
  final List<Map<String, dynamic>> userInfo;
  final double review;
  final int numRating;
  final List posteInfo;

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
    return SingleChildScrollView(
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
            child: Text(
              widget.posteInfo.isNotEmpty ? widget.posteInfo[1]['name'] : '',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.posteInfo.isNotEmpty ? "${widget.posteInfo[0]['price']} DA" : '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  " / ${widget.posteInfo.isNotEmpty ? "${widget.posteInfo[0]['minQuantity']} unit" : ''}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.locationDot,
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
        ],
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}
