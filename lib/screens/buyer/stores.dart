import 'package:flutter/material.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/screens/buyer/store.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  List<Map<String, dynamic>?> stores = [];
  List<Map<String, dynamic>?> filteredStores = [];

  @override
  void initState() {
    super.initState();
    loadStores().then((data) {
      setState(() {
        stores = data;
        filteredStores = stores;
      });
    });
  }

  void filterStores(String query) {
    setState(() {
      filteredStores = stores.where((store) =>
          store!['data']['username'].toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          ImagePaths().suggestedStores,
          width: MediaQuery.of(context).size.width * 0.5,
        ),
        backgroundColor: AppColors().secondaryColor,
        iconTheme: IconThemeData(color: AppColors().primaryColor),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.065,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors().borderColor,
                width: 1,
              ),
            ),
            child: TextField(        
              onChanged: (value) {
                filterStores(value);
              },
              decoration: InputDecoration(
                labelText: 'Search by username',
                border: InputBorder.none,
                suffixIcon: Icon(
                  Icons.search,
                  color: AppColors().primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStores.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoreScreen(sellerId: filteredStores[index]!['id']),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  filteredStores.isNotEmpty && index < filteredStores.length
                                      ? filteredStores[index]!['data']['profilePicture']
                                      : ImagePaths().defaultProfilePicture,
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.1,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      filteredStores.isNotEmpty
                                          ? filteredStores[index]!['data']['username'] ?? ''
                                          : '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    filteredStores[index]!['data']['bio'] != null
                                        ? SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.35,
                                            height: MediaQuery.of(context).size.height * 0.05,
                                            child: Text(
                                              filteredStores.isNotEmpty
                                                  ? filteredStores[index]!['data']['bio'] ?? ''
                                                  : '',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    filteredStores[index]!['data']['address'] != null
                                        ? SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.35,
                                            child: Text(
                                              filteredStores.isNotEmpty
                                                  ? filteredStores[index]!['data']['address'] ?? ''
                                                  : '',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.clip,
                                                color: AppColors().primaryColor,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}