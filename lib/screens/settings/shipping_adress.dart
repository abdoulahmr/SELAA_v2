import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/account_settings.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';

class ShippingAddressPage extends StatefulWidget {
  const ShippingAddressPage({Key? key}) : super(key: key);

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  String userAddress = '';

  @override
  void initState() { 
    super.initState();
    loadUserShippingAddress(context).then((String data) {
      setState(() {
        userAddress = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Address'),
        backgroundColor: AppColors().primaryColor,
      ),
      body: PopScope(
        canPop: false,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Current shipping address: $userAddress",
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color(0xFF415B5B),
                ),
              ),
              const SizedBox(height: 32.0),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  labelStyle: const TextStyle(color: Color(0xFF415B5B)), 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF415B5B))
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: const TextStyle(color: Color(0xFF415B5B)), 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF415B5B))
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _zipCodeController,
                decoration: InputDecoration(
                  labelText: 'Zip Code',
                  labelStyle: const TextStyle(color: Color(0xFF415B5B)), 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF415B5B))
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  fixedSize: MaterialStateProperty.all(
                    Size(
                      MediaQuery.of(context).size.width * 0.8,
                      MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(color: Color(0xFF415B5B)),
                    ),
                  ),
                ),
                onPressed: () {
                  updateUserShippingAddress('${_addressController.text},${_cityController.text},${_zipCodeController.text}', context);
                },
                child: const Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
