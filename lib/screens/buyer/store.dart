import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/load_data.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store'),
      ),
      body: Center(
        child: Text('Store'),
      ),
    );
  }
}
