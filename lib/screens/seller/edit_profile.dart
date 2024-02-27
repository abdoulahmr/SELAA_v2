import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:selaa/backend-functions/account_settings.dart';
import 'package:selaa/backend-functions/links.dart';
import 'user_page.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _firsname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _adress = TextEditingController();
  final picker = ImagePicker();
  List<Map<String, dynamic>> userInfo = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        setState(() {
          userInfo = [snapshot.data()!];
          isLoading = false;
          _username.text = userInfo[0]['username'];
          _firsname.text = userInfo[0]['firstname'];
          _lastname.text = userInfo[0]['lastname'];
          _bio.text = userInfo[0]['bio'];
          _adress.text = userInfo[0]['address'];
        });
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Error uploading image',
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Error uploading image: $error',
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateProfilePicture(context) async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: 'Loading',
          text: 'Please wait...',
        );
        File file = File(pickedFile.path);
        final firebase_storage.Reference storageRef =
            firebase_storage.FirebaseStorage.instance.ref().child(
                'profilePicture/${DateTime.now().millisecondsSinceEpoch}');
        await storageRef.putFile(file);
        final String downloadURL = await storageRef.getDownloadURL();
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'profilePicture': downloadURL});
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfile()),
        );
      }
    } catch (error) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Error uploading image: $error',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFCCE6E6),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.32,
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
                          child: Row(
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                    Size(
                                      MediaQuery.of(context).size.width * 0.25,
                                      MediaQuery.of(context).size.height * 0.04,
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(const Color(0xFFF4F4F4)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: const BorderSide(color: Color(0xFF415B5B)),
                                    ),
                                  ),
                                ),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const UserPage()));
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Color(0xFF001A1A),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                    Size(
                                      MediaQuery.of(context).size.width * 0.25,
                                      MediaQuery.of(context).size.height * 0.04,
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
                                onPressed: (){
                                  updateUserInfo(
                                    context,
                                    _username.text,
                                    _firsname.text,
                                    _lastname.text,
                                    _bio.text,
                                    _adress.text
                                  );
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? const CircularProgressIndicator()
                        : CircleAvatar(
                      radius: 100,
                      backgroundImage: userInfo.isNotEmpty && userInfo[0]['profilePicture'] != null
                          ? NetworkImage(userInfo[0]['profilePicture'])
                          : const NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/selaa-2ff93.appspot.com/o/profilePicture%2Fkisspng-computer-icons-download-avatar-5b3848b5343f86.741661901530415285214-removebg-preview%20(1).png?alt=media&token=0c01bbf5-f998-4ad9-af94-235ba6fd4ab5',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(
                            MediaQuery.of(context).size.width * 0.35,
                            MediaQuery.of(context).size.height * 0.05,
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
                      onPressed: (){
                        updateProfilePicture(context);
                      }, 
                      child: const Text('Change Picture'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _username,
                  decoration: InputDecoration(
                    labelText: "Username",
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
                  controller: _firsname,
                  decoration: InputDecoration(
                    labelText: "First name",
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
                  controller: _lastname,
                  decoration: InputDecoration(
                    labelText: "Last name",
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
                  controller: _bio,
                  decoration: InputDecoration(
                    labelText: "Bio",
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
                  controller: _adress,
                  decoration: InputDecoration(
                    labelText: "Adress",
                    labelStyle: const TextStyle(
                      color: Color(0xFF415B5B),
                    ),  
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF415B5B)))),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}