import 'package:flutter/material.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selaa/backend-functions/load_data.dart';
import '../../backend-functions/data_manipulation.dart';

class AddPoste extends StatefulWidget {
  const AddPoste({Key? key}) : super(key: key);

  @override
  State<AddPoste> createState() => _AddPosteState();
}

class _AddPosteState extends State<AddPoste> {
  List<Map<String, dynamic>> _categoryList = [];
  String _category = "";
  final _type = TextEditingController();
  final _selling = TextEditingController();
  final _price = TextEditingController();
  final _location = TextEditingController();
  final _description = TextEditingController();
  final List<XFile> _imageFileList = [];

  void selectImages() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFileList.add(pickedFile);
      });
    }
  }

  void deleteImage(int index) {
    setState(() {
      _imageFileList.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    loadProductsCategories(context).then((value) {
      setState(() {
        _categoryList = value;
        _category = _categoryList[0]['id'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child :Column(
            children: [
              Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 50, left: 30),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  width: MediaQuery.of(context).size.width * 0.32,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                        Size(
                          MediaQuery.of(context).size.width * 0.25,
                          MediaQuery.of(context).size.height * 0.04,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(const Color(0xFF008080)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xFF415B5B)),
                        ),
                      ),
                    ),
                    onPressed: (){
                      addProduct(
                        _category,
                        _type.text,
                        _selling.text,
                        _price.text,
                        _location.text,
                        _description.text,
                        _imageFileList,
                        context
                      );
                    },
                    child: const Text(
                      "Publish",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(
                        MediaQuery.of(context).size.width * 0.45,
                        MediaQuery.of(context).size.height * 0.07,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF008080)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(color: Color(0xFF415B5B)),
                      ),
                    ),
                  ),
                  onPressed: selectImages,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.camera),
                      SizedBox(width: 10),
                      Text(
                        "Add Images",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_imageFileList.length, (index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        child: Stack(
                            children: [
                              Image.file(
                                File(_imageFileList[index].path),
                                width: 200,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Delete Image?'),
                                          content: const Text('Are you sure you want to delete this image?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteImage(index);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF415B5B),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Expanded(
                    child: DropdownButton<String>(
                      value: _category,
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _category = newValue!;
                        });
                      },
                      items: [
                        for (var category in _categoryList)
                          DropdownMenuItem<String>(
                            value: category['id'],
                            child: Text(category['name']),
                          )
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: _type,
                    decoration: InputDecoration(
                      labelText: "What type ?",
                      labelStyle: const TextStyle(
                        color: Color(0xFF415B5B),
                      ),  
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF415B5B)))),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: _selling,
                    decoration: InputDecoration(
                      labelText: "What are you selling ?",
                      labelStyle: const TextStyle(
                        color: Color(0xFF415B5B),
                      ),  
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF415B5B)))),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: _price,
                    decoration: InputDecoration(
                      labelText: "Price (DA)",
                      labelStyle: const TextStyle(
                        color: Color(0xFF415B5B),
                      ),  
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF415B5B)))),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: _location,
                    decoration: InputDecoration(
                      labelText: "Location",
                      labelStyle: const TextStyle(
                        color: Color(0xFF415B5B),
                      ),  
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF415B5B)))),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  margin: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: _description,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: const TextStyle(
                        color: Color(0xFF415B5B),
                      ),  
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF415B5B)))),
                  ),
                ),
              ]
            ),
          ),
      )
      );
  }
}