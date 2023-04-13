import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/auth/checkAuthentication.dart';
import 'package:finderspetters/auth/forgotPass.dart';
import 'package:finderspetters/auth/loginScreen.dart';
import 'package:finderspetters/components/utils.dart';
import 'package:finderspetters/model/profile.dart';
import 'package:finderspetters/profile/editAddress.dart';
import 'package:finderspetters/profile/editContactNumber.dart';
import 'package:finderspetters/profile/editName.dart';
import 'package:finderspetters/profile/editUsername.dart';
import 'package:finderspetters/profile/userPictureContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Profile> _profiles = [];
  final User user = FirebaseAuth.instance.currentUser!;
  String currentAddress = "";
  bool noImage = true;
  File? image;
  String imageUrl = "";
  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    Navigator.pop(context);
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    Navigator.pop(context);
  }

  void saveImage() async {
    try {
      if (image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('Account Profiles')
            .child(user.uid + '.jpg');
        await ref.putFile(image!);
        imageUrl = await ref.getDownloadURL();

        final docUser = FirebaseFirestore.instance
            .collection('User Profile')
            .doc(_profiles.first.id);

        final data = {
          'imageUrl': imageUrl,
        };
        docUser.update(data);

        Utils.successSnackBar(Icons.check, "Successfully Change Image Profile");
        Navigator.pop(context);
      } else {
        Utils.errorSnackBar(Icons.error, 'You did not upload any image');
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('User Profile')
        .where('email', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Profile.fromJson(doc.data());
        _profiles.add(myOrder);
        print(_profiles);
        setState(() {
          if (_profiles.first.address == "") {
            currentAddress = "Address Not Set";
          } else {
            currentAddress = _profiles.first.address!;
          }
        });
      });

      // Move the print statement inside the then() block
      if (_profiles.first.imageUrl!.isEmpty) {
        setState(() {
          noImage = true;
        });
      } else {
        setState(() {
          noImage = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color.fromRGBO(249, 235, 227, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(186, 215, 98, 1),
          title: Padding(
              padding: const EdgeInsets.all(15), child: Text("My Profile")),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                height: 260,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(186, 215, 98, 1),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffD9D9D9),
                          ),
                          height: 180,
                          width: 150,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: (image != null)
                                  ? Image.file(
                                      image!,
                                      width: 150,
                                      height: 180,
                                      fit: BoxFit.fill,
                                    )
                                  : (noImage)
                                      ? UserPictureContainer()
                                      : Image.network(
                                          _profiles.first.imageUrl!,
                                          width: 150,
                                          height: 180,
                                          fit: BoxFit.fill,
                                        ))),
                    ),
                    SizedBox(height: 20),
                    Center(child: changeImage())
                  ],
                ),
              ),
              SizedBox(height: 15),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => EditNamePage(
                                  name: _profiles.first.fullName,
                                  profileId: _profiles.first.id,
                                )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text("Full Name",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.green)),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => EditContactPage(
                                  contact: _profiles.first.mobileNumber,
                                  profileId: _profiles.first.id,
                                )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text("Mobile Number",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.green)),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => EditUsernamePage(
                                  username: _profiles.first.username,
                                  profileId: _profiles.first.id,
                                )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text("Username",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.green)),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(
                                  isLogin: "true",
                                )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text("Edit Password",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.green)),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => MapScreen(
                                  profileId: _profiles.first.id,
                                  currentAddress: currentAddress,
                                )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text("Address",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.green)),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        signOut();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text("Logout",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.green)),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])
            ],
          ),
        ));
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CheckAuthenticationPage()));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  InkWell changeImage() {
    return InkWell(
      onTap: (() {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Choose option',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black),
                ),
                content: SingleChildScrollView(
                  child: ListBody(children: [
                    InkWell(
                      onTap: pickImageCamera,
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.camera,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Camera',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: pickImageGallery,
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.image,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Gallery',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: saveImage,
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.save,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Save',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
              );
            });
      }),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromRGBO(255, 160, 55, 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        child: const Text(
          "Change Image",
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
